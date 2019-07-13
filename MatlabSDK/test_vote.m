dms = DisparityMap_sparse{1};
GT = readpfm(['D:\test\playground/disp0.pfm']);%Modify
% dms = D_full;
% dms = DisparityMap{1};
dmf = dms;
% figure()
% imshow(dmf/140)
% colormap(gca,jet)
% dmf = medfilt2(dmf);
% figure()
% imshow(dmf/140)
% colormap(gca,jet)
% for i =1:2
% dmf = major_vote(dmf,3);
% end
% figure()
% imshow(dmf/140)
% colormap(gca,jet)
for i = 1:2
dmf = hole_filling(dmf,1);
end
figure()
imshow(dmf/140);
colormap(gca,jet)
% dmf = Occ_fill(dmf,10,0);

% figure()
% imshow(dmf/140)
% colormap(gca,jet)
% for i =1:2
%     dmf = major_vote(dmf,2);
% end

D_full = BGF(dmf);
% D_full = major_vote(D_full,5);
figure()
imshow([D_full/20,GT/20]);
colormap(gca,jet)
% Error5 = abs(D_full - GT) > 1;
% Error5(~mask) = 0;   
% ErrorRate5 = sum(Error5(:))/sum(mask(:))
D_full_u = uint8(D_full*255/20);
GT_u = uint8(GT*255/20);
p = psnr(D_full_u,GT_u)
% [PSNR] = calcPSNR(D_full,GT)