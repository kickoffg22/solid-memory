function I_vote = major_vote_cross(I,r)
tic()
I_exp = zeros(size(I,1)+r,size(I,2)+r);
[rows,cols] = size(I_exp);
range1 = 1+r:rows;
range2 = r+1:cols;
I_exp(range1,range2) = I;
stack = zeros(size(I,1),size(I,2),4*r+1);
counter=1;
shifteded_I = zeros(size(I));
j=0;
for i = -r:r
        shifteded_I(:,:) = 0;
        if i <= 0 
            shifteded_I(1:end+i,1:end+j) = I(1-i:end,1-j:end);
        elseif i <= 0
            shifteded_I(1:end+i,1:end) = I(1-i:end,1:end);
        elseif i >= 0 
            shifteded_I(1+i:end,1:end+j) = I(1:end-i,1:end);
        elseif i >= 0 
            shifteded_I(1+i:end,1:end) = I(1:end-i,1:end-j);
        end
        stack(:,:,counter) = shifteded_I;
        counter = counter + 1;
end
i=0;
for j = [-r:-1,1:r]
        shifteded_I(:,:) = 0;
        if i <= 0 && j <= 0 %comparing to upper left
            shifteded_I(1:end+i,1:end+j) = I(1-i:end,1-j:end);
        elseif i <= 0 && j >= 0%comparing to upper right
            shifteded_I(1:end+i,1+j:end) = I(1-i:end,1:end-j);
        elseif i >= 0 && j <= 0%comparing to bottom left
            shifteded_I(1+i:end,1:end+j) = I(1:end-i,1-j:end);
        elseif i >= 0 && j >= 0%comparing to bottom right
            shifteded_I(1+i:end,1+j:end) = I(1:end-i,1:end-j);
        end
        stack(:,:,counter) = shifteded_I;
        counter = counter + 1;
 end
% I_sort = sort(I_exp,3);
I_vote = mode(stack(:,:,:),3);
toc();
end