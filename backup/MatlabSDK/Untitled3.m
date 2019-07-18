% a = magic(3);
% b = magic(4);
% c = magic(3);
% a==8
% D1 = diag([1 1 1 1 1 1 1 1]);
D1 = magic(7);
D1(1,4)=0;
D1(6,3)=0;
% tic
% D1 = DisparityMap_sparse{1};
% cross_radius =1;
% ind = (D1==0);
% ind = find(D1==0);
% [y,x] = ind2sub(size(D1),ind);
% length(y)
% D1_expend= zeros(size(D1,1)+2*cross_radius,size(D1,2)+2*cross_radius);
% D1_expend = D1_expend(cross_radius+1:end-cross_radius,cross_radius+1:end-cross_radius)+D1;
toc
tic
% for i=1:length(y)
%     i
%     mask = zeros(size(D1));
%     mask(max(1,y(i)-cross_radius):min(y(i)+cross_radius,end),max(1,x(i)-cross_radius):min(x(i)+cross_radius,end)) = 1;
%     mask_D1 = mask.*D1;
%     d2 = max(mask_D1(:));
%     if d2 ==0
%         D1(y(i),x(i)) = 0;
%     else
%         d_threshold = d2/7;% empirical penalty of 1/7.
%         d1 = min(mask_D1(:));
%         if d1 * d2 < d_threshold^2
%             d_opt = d2;
%         else
%             d_opt = d1;
%         end   
%         D1(y,x) = d_opt;
%     end
% end
toc
% maskind = maskind(cross_radius+1:end-cross_radius,cross_radius+1:end-cross_radius);
% function mask_D = cross_mask(y,x,cross_radius,D)
% mask = zeros(size(D));
% mask(max(1,y-cross_radius):min(y+cross_radius,end),max(1,x-cross_radius):min(x+cross_radius,end)) = 1;
% mask_D = mask.*D;
% end
mask = hole_fill(D1,3)
function D_fill = hole_fill(D1,cross_radius)
ind = D1==0;
D_fill = D1;
shifteded_D1 = zeros(size(ind));
max_cross = zeros(size(ind));
min_cross = zeros(size(ind));
for i = -cross_radius:cross_radius
         shifteded_D1(:,:) = 0;
        if i <= 0 
            shifteded_D1(1:end+i,1:end) = D1(1-i:end,1:end);
        elseif i > 0 
            shifteded_D1(1+i:end,1:end) = D1(1:end-i,1:end);
        end       
        max_cross = max(shifteded_D1,max_cross);
        d_threshold = max_cross/7;
        min_cross = min(shifteded_D1,D1);
        min_cross(shifteded_D1<d_threshold) = max_cross(shifteded_D1<d_threshold);
end
for i = -cross_radius:cross_radius
         shifteded_D1(:,:) = 0;
        if i <= 0 
            shifteded_D1(1:end,1:end+i) = D1(1:end,1-i:end);
        elseif i > 0 
            shifteded_D1(1:end,1+i:end) = D1(1:end,1:end-i);
        end       
        max_cross = max(shifteded_D1,max_cross);
        d_threshold = max_cross/7;
        min_cross = min(shifteded_D1,D1);
        min_cross(shifteded_D1<d_threshold) = max_cross(shifteded_D1<d_threshold);
end
d2 = max_cross(ind);
d1 = min_cross(ind);
d_j = d1.*d2;
D_threshold = (d2/7).^2;% empirical penalty of 1/7.
d_opt = d1;
d_opt(d_j<D_threshold) = d2(d_j<D_threshold);
D_fill(ind) = d_opt;
end

% mask = maskind>0;
% mask_D = mask.*D1;
% end
% maskind.*D1;
% D1(ind)
% D1 = hole_filling(D1,cross_radius)
% A = zeros(3,3,3);
% A(:,:,1) = a;
% A(:,:,2) = b;
% A(:,:,3) = c;
