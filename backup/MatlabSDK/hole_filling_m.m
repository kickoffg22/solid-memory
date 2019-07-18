function D_fill = hole_filling_m(D1,cross_radius1,cross_radius2)
ind = D1==0;%Find holes in the given disparity map
D_fill = D1;
shifteded_D1 = zeros(size(ind));
max_cross = zeros(size(ind));
min_cross = Inf(size(ind));
for i = -cross_radius1:cross_radius1 %Shift the image in vertical direction
         shifteded_D1(:,:) = 0;
        if i <= 0 
            shifteded_D1(1:end+i,1:end) = D1(1-i:end,1:end);
        elseif i > 0 
            shifteded_D1(1+i:end,1:end) = D1(1:end-i,1:end);
        end
        max_cross = max(shifteded_D1,max_cross);%find the maximum disparity in vertical direction
        d_threshold = max_cross/7;%Set a threshold to avoid the invalid points with empirical penalty of 1/7.
        pre_min_cross = min_cross;
        min_cross = min(shifteded_D1,min_cross);%find the minimun disparity in vertical direction,which is larger than the threshold
        min_cross(min_cross<d_threshold) = pre_min_cross(min_cross<d_threshold);
end
for i = -cross_radius2:cross_radius2%Shift the image in horizontal direction
         shifteded_D1(:,:) = 0;
        if i <= 0 
            shifteded_D1(1:end,1:end+i) = D1(1:end,1-i:end);
        elseif i > 0 
            shifteded_D1(1:end,1+i:end) = D1(1:end,1:end-i);
        end       
        max_cross = max(shifteded_D1,max_cross);%find the maximum disparity in vertical direction
        d_threshold = max_cross/7;%Set a threshold to avoid the invalid points with empirical penalty of 1/7.
        pre_min_cross = min_cross;
        min_cross = min(shifteded_D1,min_cross);%find the minimun disparity in vertical direction,which is larger than the threshold
        min_cross(shifteded_D1<d_threshold) = pre_min_cross(shifteded_D1<d_threshold);
end
d2 = max_cross(ind);
d1 = min_cross(ind);
d_j = d1.*d2;
D_threshold = (d2/7).^2;
%if d1*d2 > D_threshold, which means the background pixel is valid, the smaller value will be assigned, other
d_opt = d1;
d_opt(d_j<D_threshold) = d2(d_j<D_threshold);
D_fill(ind) = d_opt;
end