function [D1,D2,C1] = stereoMatchWindowCensus_joint_adp(I1, I2, ws, ndisp,beta,gamma)
%Image allignment
[~,cols,~] = size(I1);
[rows,cols2,~] = size(I2);
if cols > cols2
    I2(:,end+1:cols,:) = 0;
elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
end
%% Matrix defination
max_window_radius = max(ws(:));
C1min = Inf(rows,cols);% Matrix of minimum cost
C2min = Inf(rows,cols);
D1 = zeros(rows,cols);% Matrix of disparity of minimum cost
D2 = zeros(rows,cols);
max_d = min(ndisp,cols-max(ws(:)));
n=0;
max_window_radius = max(ws(:));
%% Census Transform
IC1 = CT(I1);
IC2 = CT(I2);
%% Window matching along the epipolarline
for d = 1:max_d
    if n==20
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
   match_cost_bit_AD = zeros(rows + 2*max_window_radius,cols - d + 2*max_window_radius);
    for k=1:64
        match_cost_bit = match_cost_bit + double(bitget(match_cost_bit_bin,k));%Converting Hamming distance in to decimal number.
    end
    match_cost_bit_AD(1+max_window_radius:end-max_window_radius,1+max_window_radius:end-max_window_radius) = abs(I1(:,range1)-I2(:,range2));

%% Aggregation
% Calculate the match cost in the given window by means of intgeral image
    intgerated_match_cost = zeros(size(match_cost_bit,1)+1,size(match_cost_bit,2)+1);
    intgerated_match_cost(2:end, 2:end) = cumsum(cumsum(match_cost_bit,1),2);%Computing intergral image.
    intgerated_match_cost_AD = zeros(size(match_cost_bit_AD,1)+1,size(match_cost_bit_AD,2)+1);
    intgerated_match_cost_AD(2:end, 2:end) = cumsum(cumsum(match_cost_bit_AD,1),2);
windowed_match_cost_C = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
windowed_match_cost_AD = zeros(size(match_cost_bit,1),size(match_cost_bit,2),length(ws));
% The sum of cost in the window is the summation of value of bottom
% right point and upper left point substract the value of bottom left
% point and upper right point.
for r = 1:length(ws)
    windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = intgerated_match_cost(2*ws(r)+2:end,2*ws(r)+2:end)...
        - intgerated_match_cost(1:end-(2*ws(r)+1),2*ws(r)+2:end)...
        - intgerated_match_cost(2*ws(r)+2:end,1:end-(2*ws(r)+1))...
        + intgerated_match_cost(1:end-(2*ws(r)+1),1:end-(2*ws(r)+1));
    windowed_match_cost_C(:,:,r) =  windowed_match_cost_C(:,:,r)/(2*ws(r)+1)^2;
   windowed_match_cost_AD(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = intgerated_match_cost_AD(2*ws(r)+2:end,2*ws(r)+2:end)...
        - intgerated_match_cost_AD(1:end-(2*ws(r)+1),2*ws(r)+2:end)...
        - intgerated_match_cost_AD(2*ws(r)+2:end,1:end-(2*ws(r)+1))...
        + intgerated_match_cost_AD(1:end-(2*ws(r)+1),1:end-(2*ws(r)+1));
    windowed_match_cost_AD = windowed_match_cost_AD(:,:,r)/(2*ws(r)+1)^2;
    expcost_C = 1-exp(-2*(windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r)/max(windowed_match_cost_C(:))));
    windowed_match_cost_C(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = 
    windowed_match_cost_AD(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r) = 1- exp(-2*(windowed_match_cost_AD(ws(r)+1:end-ws(r),ws(r)+1:end-ws(r),r)/max(windowed_match_cost_AD(:))));% +beta/(2*ws(r)+1-gamma);% Matching cost is the sum of hamming distance add a penalty for small window.
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
    fprintf('\n');
    C1 = C1min;
end
end


