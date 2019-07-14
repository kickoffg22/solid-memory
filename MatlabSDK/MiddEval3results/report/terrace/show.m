figure()
imshow([DisparityMap{1}/18,DisparityMap_sparse{1}/18;Refined_DisparityMap_unmask/18,Refined_DisparityMap/18])
colormap(gca,jet)
colorbar
figure()
imshow(DisparityMap_sparse{1}/18)
colormap(gca,jet)
colorbar
figure()
imshow(Refined_DisparityMap/18)
colormap(gca,jet)
colorbar
GT = readpfm('C:\Users\Wang_\Documents\GitHub\solid-memory\MatlabSDK\MiddEval3results\terrace\disp0.pfm');%Modify
imshow(GT/18)
colormap(gca,jet)
colorbar
