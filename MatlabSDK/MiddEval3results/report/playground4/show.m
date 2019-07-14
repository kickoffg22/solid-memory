figure()
imshow([DisparityMap{1}/20,DisparityMap_sparse{1}/20;Refined_DisparityMap_unmasked/20,Refined_DisparityMap/20])
colormap(gca,jet)
colorbar
figure()
imshow(DisparityMap_sparse{1}/20)
colormap(gca,jet)
colorbar
figure()
imshow(Refined_DisparityMap/20)
colormap(gca,jet)
colorbar
GT = readpfm('C:\Users\Wang_\OneDrive\2Semster\Computer Vision\Challenge\playground\playground\disp0.pfm');%Modify
imshow(GT/20)
colormap(gca,jet)
colorbar
