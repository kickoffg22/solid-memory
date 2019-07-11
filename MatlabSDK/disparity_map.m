% function [D,R,T] = disparity_map(scene_path)
scene_path = 'D:\test\Motorcycle';
    [I,ndisp] = input_data(scene_path);
    imshow(I{1})
    window_radius = 6;
    tic();
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2}, 6 , 140);
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});
    imshow([DisparityMap{1}/ndisp,DisparityMap_sparse{1}/ndisp]);
    colormap(gca,jet);
    Refined_DisparityMap = refinement(DisparityMap_sparse{1});
    D = Refined_DisparityMap;
    R = 1;
    T = 1;
    
    toc();
% end
