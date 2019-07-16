function [PSNR] = calcPSNR(varargin)
p = inputParser;
addRequired(p,'im1');
addRequired(p,'im2');
addOptional(p,'peak',255); 
parse(p,varargin{:});
pv = p.Results.peak;
im1 = p.Results.im1;
im2 = p.Results.im2;
PSNR = 10*log10(pv^2/calcMSE(im1,im2));
end

%% Calulate mean square error
function [MSE] = calcMSE(im1,im2)
[height, width, cdim] = size(im1);
MSE = sum((im1(:)- im2(:)).^2)/(height*width*cdim);
end