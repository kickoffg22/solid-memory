function [D1,D2,C1] = stereoMatchWindowCensus_adpa(I1, I2, ws, max_d,thresh,lambda_C,lambda_AD)
%Image allignment
[~,cols,~] = size(I1);
[rows,cols2,~] = size(I2);
if cols > cols2
    I2(:,end+1:cols,:) = 0;
elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
end
%Census Transform
IC1 = CT(I1);%Census tranformation
IC2 = CT(I2);
max_window_radius = max(ws(:));
C1min = Inf(rows,cols);
C2min = Inf(rows,cols);
D1 = zeros(rows,cols);
D2 = zeros(rows,cols);
for d = 1:max_d
    fprintf('Computing cost volume...(disparity = %04d)', d);
    range1 = 1+d:cols;
    range2 = 1:cols-d;
    %S = Inf(rows,cols-d);
    match_cost_bit_bin = zeros(rows + 2*max_window_radius,cols - d + 2*max_window_radius);
%     match_cost_bit_AD = zeros(rows + 2*max_window_radius,cols - d + 2*max_window_radius);
    match_cost_bit_bin(1+max_window_radius:end-max_window_radius,1+max_window_radius:end-max_window_radius) = bitxor(IC1(:,range1),IC2(:,range2));
    match_cost_bit = zeros(size(match_cost_bit_bin));   
%     windowed_match_cost_C = zeros(size(I1,1),size(I1,2),max_window_radius-min_window_radius+1);
    for k=1:64
        match_cost_bit = match_cost_bit + double(bitget(match_cost_bit_bin,k));
    end
%     match_cost_bit_sq = match_cost_bit.^2;
%     size_mask = round((max_window_radius - min_window_radius) + ((2* min_window_radius)/(max(match_cost_bit(:))-min(match_cost_bit(:))))*abs(match_cost_bit-(max(match_cost_bit(:))-min(match_cost_bit(:)))/2));
%   match_cost_bit_AD(1+max_window_radius:end-max_window_radius,1+max_window_radius:end-max_window_radius) = abs(I1(:,range1)-I2(:,range2));
    
    % Calculate the match cost in the given window by means of intgeral
    % image
    intgerated_match_cost = zeros(size(match_cost_bit,1)+1,size(match_cost_bit,2)+1);
    intgerated_match_cost(2:end, 2:end) = cumsum(cumsum(match_cost_bit,1),2);
%     intgerated_match_cost_sq = zeros(size(match_cost_bit_sq,1)+1,size(match_cost_bit_sq,2)+1);
%     intgerated_match_cost_sq(2:end, 2:end) = cumsum(cumsum(match_cost_bit_sq,1),2);
%     windowed_match_cost_C = zeros(size(match_cost_bit,1),size(match_cost_bit,2),max_window_radius-min_window_radius+1);
%     intgerated_match_cost_AD = zeros(size(match_cost_bit_AD,1)+1,size(match_cost_bit_AD,2)+1);
%     intgerated_match_cost_AD(2:end, 2:end) = cumsum(cumsum(match_cost_bit_AD,1),2);
match_cost = zeros(size(I1));
% for r = 1:max_window_radius - min_window_radius + 1
% ws = [min_window_radius,max_window_radius];

windowed_match_cost_C = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
% windowed_match_cost_sq = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
% windowed_match_cost_var = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
% [Fx, Fy] = sobel(I1);
% F = (Fx>thresh)|(Fy>thresh);

for r = 1:length(ws)
    windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = intgerated_match_cost(2*ws(r)+2:end,2*ws(r)+2:end)...
        - intgerated_match_cost(1:end-(2*ws(r)+1),2*ws(r)+2:end)...
        - intgerated_match_cost(2*ws(r)+2:end,1:end-(2*ws(r)+1))...
        + intgerated_match_cost(1:end-(2*ws(r)+1),1:end-(2*ws(r)+1));
%     windowed_match_cost_sq(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = intgerated_match_cost_sq(2*ws(r)+2:end,2*ws(r)+2:end)...
%         - intgerated_match_cost_sq(1:end-(2*ws(r)+1),2*ws(r)+2:end)...
%         - intgerated_match_cost_sq(2*ws(r)+2:end,1:end-(2*ws(r)+1))...
%         + intgerated_match_cost_sq(1:end-(2*ws(r)+1),1:end-(2*ws(r)+1));
%     windowed_match_cost_sq(:,:,r) = windowed_match_cost_sq(:,:,r)/(ws(r)^2);
    windowed_match_cost_C(:,:,r) =  windowed_match_cost_C(:,:,r)/(2*ws(r)+1)^2;
%     windowed_match_cost_var(:,:,r) = windowed_match_cost_sq(:,:,r)-windowed_match_cost_C(:,:,r).^2;
%     windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) +1.5*windowed_match_cost_var(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) +7/(ws(r)-2);
      windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) +lambda_C/(2*ws(r)+1-2);
%     match_cost = match_cost + windowed_match_cost_C(:,:,r).*(size_mask == r+2);
end

    % The sum of cost in the window is the summation of value of bottom
    % right point and upper left point substract the value of bottom left
    % point and upper right point.
    
%     match_cost = match_cost(max_window_radius+1:end-max_window_radius,max_window_radius+1:end-max_window_radius);
   ra1 = max_window_radius+1:size(windowed_match_cost_C,1)-max_window_radius;
   ra2 = max_window_radius+1:size(windowed_match_cost_C,2)-max_window_radius;
    match_cost = min(windowed_match_cost_C(ra1,ra2,:),[],3) ;
    match_cost(:,1:max_window_radius) = Inf;
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
    C1 = C1min;
end
end


