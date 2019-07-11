% IC1 = CT(I{1});
dir_mask1 = diff_map(I{1},0.05,0,1);
dir_mask2 = diff_map(I{1},0.1,0,0);
% dir_mask2 = ~dir_mask1;
s1  = zeros(size(dir_mask1));
s1(dir_mask1) = DisparityMap_8{1}(dir_mask1);
s2  = zeros(size(dir_mask1));
s2(dir_mask2) = DisparityMap_1{1}(dir_mask2);
s =s1+s2;
mask = imread(['MiddEval3/training',imgsize,'/',image_names{4},'/mask0nocc.png']);%Modify
mask = mask == 255;
% imshow(s);
% imshow(s/140);
% colormap(gca,jet)
imshow([DisparityMap_8{1}/140,DisparityMap_1{1}/140;s1/140,s2/140;s/140,GT/140]);
colormap(gca,jet)