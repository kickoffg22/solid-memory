% function [D,R,T] = disparity_map(scene_path)
scene_path = 'D:\test\Motorcycle';
[I,ndisp] = input_data(scene_path);
GT = readpfm('D:\test\Motorcycle\disp0.pfm');%Modify
%     window_radius = round(size(I{1}/250));
% ndisp = 90;
% scene_path = 'C:\Users\Wang_\OneDrive\2Semster\Computer Vision\Challenge\MatlabSDK\MiddEval3\trainingH\Motorcycle';
% [I,ndisp] = input_data(scene_path);
% GT = readpfm('C:\Users\Wang_\OneDrive\2Semster\Computer Vision\Challenge\MatlabSDK\MiddEval3\trainingH\Motorcycle\disp0GT.pfm');%Modify
%     window_radius = round(size(I{1}/250));
ndisp = 270;
   window_radius = 12;
    ws = 2:35;
% %     tic();
tic
%    [DisparityMap{1}, DisparityMap{2}] = stereoMatchWindowCensus_adpa(I{1}, I{2}, ws,ndisp,30,2)
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2} , window_radius,ndisp);
toc
tic
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});
%      imshow([DisparityMap{1}/20,DisparityMap_sparse{1}/20]);
%     colormap(gca,jet);
%     Refined_DisparityMap = DisparityMap{1};
%     toc()
%     Refined_DisparityMap = BGF(DisparityMap_sparse{1});
% Refined_DisparityMap_unmask(Refined_DisparityMap_unmask>75) = 0;

    Refined_DisparityMap_unmask = refinement(DisparityMap_sparse{1},0);
    toc
    Refined_DisparityMap = refinement(DisparityMap_sparse{1},1);
%     D = Refined_DisparityMap;
    R = 1;
    T = 1;
%     figure()
%     imshow([Refined_DisparityMap/20,GT/20]);
%    Refined_DisparityMap = Refined_DisparityMap_unmask;
%     Refined_DisparityMap(GT==0) = 0;
%     imshow([DisparityMap{1}/ndisp,DisparityMap_sparse{1}/ndisp;Refined_DisparityMap/ndisp,GT/ndisp]);
figure()

imshow([DisparityMap{1}/ndisp,DisparityMap_sparse{1}/ndisp;Refined_DisparityMap_unmask/ndisp,Refined_DisparityMap/ndisp]);
    colormap(gca,jet);
    toc();
    D_full_u = uint8(Refined_DisparityMap);
    GT_u = uint8(GT);
    p = psnr(D_full_u,GT_u)
% p = psnr(D_full_u,GT_)
%  mask = imread(['MiddEval3/training',imgsize,'/',image_names{4},'/mask0nocc.png']);%Modify
%         mask = mask == 255;
%         Refined_DisparityMap(~mask)=0;
%     [PSNR] = calcPSNR(Refined_DisparityMap,GT);
% end
