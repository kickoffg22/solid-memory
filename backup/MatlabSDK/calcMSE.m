function [MSE] = calcMSE(im1,im2)
%CALCMSE Summary of this function goes here
%   Detailed explanation goes here
[height, width, cdim] = size(im1);
MSE = sum((im1(:)- im2(:)).^2)/(height*width*cdim);
end

