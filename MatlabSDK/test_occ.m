GT = readpfm(['MiddEval3/training',imgsize,'/',image_names{4},'/disp0GT.pfm']);%Modify
d = DisparityMap_sparse{1};
o = hole_filling(d,3);
df = Occ_fill(DisparityMap_sparse{1},40,0);
D_full = BGF(o);
% Error5(~mask) = 0;  
% GT(~mask) = 0; 
p = psnr(D_full, round(GT),1)
% Erroro = abs(o - GT) > bad;
Errordf = abs(D_full - GT) > bad;
[PSNR] = calcPSNR(D_full,GT)
 
figure
imshow([DisparityMap_sparse{1}/140,o/140;D_full/140,GT/140]);
colormap(gca,jet)
ErrorRatedf = sum(Errordf(:))/sum(mask(:))
