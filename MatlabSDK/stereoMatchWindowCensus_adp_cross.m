function [D1,D2] = stereoMatchWindowCensus_adp_cross(I1, I2, window_radius, max_d,lambda_C,lambda_AD)

[~,cols,~] = size(I1);
[rows,cols2,~] = size(I2);
if cols > cols2
    I2(:,end+1:cols,:) = 0;
elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
end

IC1 = CCT(I1,'window_length',9,'window_width',7);%Census tranformation
IC2 = CCT(I2,'window_length',9,'window_width',7);

C1min = Inf(rows,cols);
C2min = Inf(rows,cols);
D1 = zeros(rows,cols);
D2 = zeros(rows,cols);
for d = 1:max_d
    fprintf('Computing cost volume...(disparity = %04d)', d);
    range1 = 1+d:cols;
    range2 = 1:cols-d;
    %S = Inf(rows,cols-d);
    match_cost_bit_bin = zeros(rows + 2*window_radius,cols - d + 2*window_radius);
    match_cost_bit_AD = zeros(rows + 2*window_radius,cols - d + 2*window_radius);
    match_cost_bit_bin(1+window_radius:end-window_radius,1+window_radius:end-window_radius) = bitxor(IC1(:,range1),IC2(:,range2));
    match_cost_bit = zeros(size(match_cost_bit_bin));    
    for k=1:64
        match_cost_bit = match_cost_bit + double(bitget(match_cost_bit_bin,k));
    end
    match_cost_bit_AD(1+window_radius:end-window_radius,1+window_radius:end-window_radius) = abs(I1(:,range1)-I2(:,range2));
    % Calculate the match cost in the given window by means of intgeral
    % image
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
%     windowed_match_cost_C = windowed_match_cost_C(min(windowed_match_cost_C(:)));
    total_windowed_match_cost = 2-exp(-windowed_match_cost_C/lambda_C)-exp(-windowed_match_cost_AD/lambda_AD);
    % The sum of cost in the window is the summation of value of bottom
    % right point and upper left point substract the value of bottom left
    % point and upper right point.
    total_windowed_match_cost(:,1:window_radius) = Inf;
    match_cost = total_windowed_match_cost;

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
    fprintf('\n');
end

end


