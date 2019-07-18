function I_vote = major_vote(I,r)
I_exp = zeros(size(I,1)+r,size(I,2)+r);
[rows,cols] = size(I_exp);
stack = zeros(size(I,1),size(I,2),(2*r+1)^2);
counter=1;
shifteded_I = zeros(size(I));
for i = -r:r
    for j = -r:r
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
end
% I_sort = sort(I_exp,3);
I_vote = mode(stack(:,:,:),3);
end