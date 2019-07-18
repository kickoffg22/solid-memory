function D_fill = Occ_fill(D1,ndisp,direction)
D1  = D1
ind = D1==0;%Find invalid points in the given disparity map
D_fill = D1;
shifteded_D1 = zeros(size(ind));
max_cross = zeros(size(ind));
min_cross = zeros(size(ind));
if direction == 1
    search_range = -ndisp:-1;% In the left disparity map,occusion can only on the leftside 
else
    search_range = 1:ndisp;
end
for i = search_range 
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
%if d1*d2 > D_threshold, which means the background pixel is valid, the
%smaller value(background value) will be assigned, otherwise the point will
%keep invalid for the final back gound filling
d_opt = zeros(size(d1));
d_opt(d_j<D_threshold) = d2(d_j<D_threshold);
D_fill(ind) = d_opt;
end