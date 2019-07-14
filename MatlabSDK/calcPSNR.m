function [PSNR] = calcPSNR(im1,im2)
%CALCPSNR Summary of this function goes here
%   Detailed explanation goes here
PSNR = 10*log10(255^2/calcMSE(im1,im2));
end