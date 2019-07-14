function [PSNR] = calcPSNR(im1,im2)
PSNR = 10*log10(255^2/calcMSE(im1,im2));
end

%% Calulate mean square error
function [MSE] = calcMSE(im1,im2)
[height, width, cdim] = size(im1);
MSE = sum((im1(:)- im2(:)).^2)/(height*width*cdim);
end