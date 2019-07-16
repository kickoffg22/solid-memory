%% This function performs window match by means of Census transform.
% The aggregation is performed by means of integral to calculate the sum of
% rectangular area.The window size is adaptive 
% The cost function is based on hamming distance and a penalty on small window.
function [D1,D2,C1] = Census_WM_adp(I1, I2, ws, ndisp,beta,gamma)
%Image allignment
[~,cols,~] = size(I1);
[rows,cols2,~] = size(I2);
if cols > cols2
    I2(:,end+1:cols,:) = 0;
elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
end
%% Defination of matrix and variables
max_window_radius = max(ws(:));
C1min = Inf(rows,cols);% Matrix of minimum cost
C2min = Inf(rows,cols);
D1 = zeros(rows,cols);% Matrix of disparity of minimum cost
D2 = zeros(rows,cols);
max_d = min(ndisp,cols-max(max_window_radius(:)));
n = 0;
%% Census Transform
tic
IC1 = CT(I1);
IC2 = CT(I2);
toc
%% Window matching along the epipolarline
for d = 1:max_d
    if n==round(max_d/10)
    fprintf('%04d percent completed', round(d/max_d*100));
    fprintf('\n');
    n=0;
    else
        n = n+1;
    end
 %% Computing pixelwise Hamming distance
    range1 = 1+d:cols;% Searching range in the left image
    range2 = 1:cols-d;% Searching range in the right image
    match_cost_bit_bin = zeros(rows + 2*max_window_radius,cols - d + 2*max_window_radius);
    match_cost_bit_bin(1+max_window_radius:end-max_window_radius,1+max_window_radius:end-max_window_radius) = bitxor(IC1(:,range1),IC2(:,range2));% Computing Hamming distance in binary string
    match_cost_bit = zeros(size(match_cost_bit_bin));   
    for k=1:64
        match_cost_bit = match_cost_bit + double(bitget(match_cost_bit_bin,k));%Converting Hamming distance in to decimal number.
    end
%% Aggregation
% Calculate the match cost in the given window by means of intgeral image
    intgerated_match_cost = zeros(size(match_cost_bit,1)+1,size(match_cost_bit,2)+1);
    intgerated_match_cost(2:end, 2:end) = cumsum(cumsum(match_cost_bit,1),2);%Computing intergral image.

windowed_match_cost_C = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
% The sum of cost in the window is the summation of value of bottom
% right point and upper left point substract the value of bottom left
% point and upper right point.
for r = 1:length(ws)
    windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = intgerated_match_cost(2*ws(r)+2:end,2*ws(r)+2:end)...
        - intgerated_match_cost(1:end-(2*ws(r)+1),2*ws(r)+2:end)...
        - intgerated_match_cost(2*ws(r)+2:end,1:end-(2*ws(r)+1))...
        + intgerated_match_cost(1:end-(2*ws(r)+1),1:end-(2*ws(r)+1));
    windowed_match_cost_C(:,:,r) =  windowed_match_cost_C(:,:,r)/(2*ws(r)+1)^2;
    windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) +beta/(2*ws(r)+1-gamma);% Matching cost is the sum of hamming distance add a penalty for small window.
end
 %% Comparing and recording the minimum cost and correspongding disparity.
   ra1 = max_window_radius+1:size(windowed_match_cost_C,1)-max_window_radius;%Range of valid rows
   ra2 = max_window_radius+1:size(windowed_match_cost_C,2)-max_window_radius;%Range of valid coloums
    match_cost = min(windowed_match_cost_C(ra1,ra2,:),[],3) ;
    match_cost(:,1:max_window_radius) = Inf;%Set the matching cost of invalid points to infinity

    C1c = C1min(:,range1);
    C2c = C2min(:,range2);
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
    C1 = C1min;
end
end


