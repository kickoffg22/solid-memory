function m = diff_map(I,thresh,cross_radius,dir)
[Fx,Fy] = sobel(I);
x = zeros(size(Fx));
y = zeros(size(Fy));
if dir>0
x(abs(Fx)<thresh) = 1;
y(abs(Fy)<thresh) = 1;
else
x(abs(Fx)>=thresh) = 1;
y(abs(Fy)>=thresh) = 1;
end
m = x|y;
shifteded_m = zeros(size(m));
for i = -cross_radius:cross_radius %Shift the image in vertical direction
         shifteded_m(:,:) = 0;
        if i <= 0 
            shifteded_m(1:end+i,1:end) = m(1-i:end,1:end);
        elseif i > 0 
            shifteded_m(1+i:end,1:end) = m(1:end-i,1:end);
        end
        m = m+shifteded_m;
end
for i = -cross_radius:cross_radius%Shift the image in horizontal direction
         shifteded_m(:,:) = 0;
        if i <= 0 
            shifteded_m(1:end,1:end+i) = m(1:end,1-i:end);
        elseif i > 0 
            shifteded_m(1:end,1+i:end) = m(1:end,1:end-i);
        end       
        m = m+shifteded_m;
end
m = m>0;
end