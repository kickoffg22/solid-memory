%% This function performs window match by means of Census transform.
% The aggregation is performed by means of integral to calculate the sum of
% rectangular area.
% The cost function is a combination of SAD of color and hamming distance.
function [D1,D2,C1min,C2min] = Census_WM_joint(I1, I2, window_radius, ndisp)
%% Image allignment
[~,cols,~] = size(I1);
[rows,cols2,~] = size(I2);
if cols > cols2
    I2(:,end+1:cols,:) = 0;
elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
end
%% Matrix defination
C1min = Inf(rows,cols);% Matrix of minimum cost
C2min = Inf(rows,cols);
D1 = zeros(rows,cols);% Matrix of disparity of minimum cost
D2 = zeros(rows,cols);
max_d = min(ndisp,cols-max(window_radius(:)));
n=0;
%% Census Transform
IC1 = CT(I1,'window_length',7,'window_width',7);
IC2 = CT(I2,'window_length',7,'window_width',7);
%% Window matching along the epipolarline
for d = 1:max_d
%     n=round(max_d/10*d)-n;
    if n==20
    fprintf('%04d % completed', round(d/max_d*100));
    fprintf('\n');
    n=0;
    else
        n = n+1;
    end
 %% Computing pixelwise Hamming distance
    range1 = max(1,1+d):min(size(I1,2),size(I1,2)+d);
    range2 = max(1,1-d):min(size(I1,2),size(I1,2)-d);
    %S = Inf(rows,cols-d);
    match_cost_bit_bin = zeros(rows + 2*window_radius,cols - d + 2*window_radius);
    match_cost_bit_AD = zeros(rows + 2*window_radius,cols - d + 2*window_radius);
    match_cost_bit_bin(1+window_radius:end-window_radius,1+window_radius:end-window_radius) = bitxor(IC1(:,range1),IC2(:,range2));
    match_cost_bit = zeros(size(match_cost_bit_bin));    
%% Computing pixelwise Hamming distance and absolute color difference
    for k=1:64
        match_cost_bit = match_cost_bit + double(bitget(match_cost_bit_bin,k));
    end
    match_cost_bit_AD(1+window_radius:end-window_radius,1+window_radius:end-window_radius) = abs(I1(:,range1)-I2(:,range2));
%% Aggregation
% Calculate the match cost in the given window by means of intgeral image
    % The sum of cost in the window is the summation of value of bottom
    % right point and upper left point substract the value of bottom left
    % point and upper right point.
    intgerated_match_cost = zeros(size(match_cost_bit,1)+1,size(match_cost_bit,2)+1);
    intgerated_match_cost(2:end, 2:end) = cumsum(cumsum(match_cost_bit,1),2);
    intgerated_match_cost_AD = zeros(size(match_cost_bit_AD,1)+1,size(match_cost_bit_AD,2)+1);
    intgerated_match_cost_AD(2:end, 2:end) = cumsum(cumsum(match_cost_bit_AD,1),2);
    windowed_match_cost_C = intgerated_match_cost(2*window_radius+2:end,2*window_radius+2:end)...
        - intgerated_match_cost(1:end-(2*window_radius+1),2*window_radius+2:end)...
        - intgerated_match_cost(2*window_radius+2:end,1:end-(2*window_radius+1))...
        + intgerated_match_cost(1:end-(2*window_radius+1),1:end-(2*window_radius+1));
    windowed_match_cost_AD = intgerated_match_cost_AD(2*window_radius+2:end,2*window_radius+2:end)...
        - intgerated_match_cost_AD(1:end-(2*window_radius+1),2*window_radius+2:end)...
        - intgerated_match_cost_AD(2*window_radius+2:end,1:end-(2*window_radius+1))...
        + intgerated_match_cost_AD(1:end-(2*window_radius+1),1:end-(2*window_radius+1));
 % The final joint matching cost combines the color SAD and Hamming
 % distance
    total_windowed_match_cost = 2-exp(-2*windowed_match_cost_C/max(windowed_match_cost_C(:)))-exp(-1.5*windowed_match_cost_AD/max(windowed_match_cost_AD(:)));
    total_windowed_match_cost(:,1:window_radius) = Inf;%Set the matching cost of invalid points to infinity
    match_cost = total_windowed_match_cost;
 %% Comparing and recording the minimum cost and correspongding disparity.
    C1c = C1min(:,range1);%Range of valid rows
    C2c = C2min(:,range2);%Range of valid coloums
    D1c = D1(:,range1);
    D2c = D2(:,range2);
    index1 = match_cost < C1min(:,range1);
    index2 = match_cost < C2min(:,range2);
    C1c(index1) = match_cost(index1);
    C2c(index2) = match_cost(index2);
    D1c(index1) = d;
    D2c(index2) = d;
    C1min(:,range1) = C1c;
    C2min(:,range2) = C2c;
    D1(:,range1) = D1c;
    D2(:,range2) = D2c;
    
end
end


