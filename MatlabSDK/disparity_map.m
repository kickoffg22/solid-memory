function [D,R,T] = disparity_map(scene_path,varargin)
[I,ndisp_calib] = input_data(scene_path);
[ndisp,algorithm,window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF] = parse_inputs(varargin);
ndisp = min(ndisp_input,ndisp_calib);
tic();
if algorithm ==0
    [DisparityMap{1}, DisparityMap{2}] = stereoMatchWindowCensus_adpa(I{1}, I{2}, window_radius,ndisp,beta,gamma);
else
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2} , window_radius,ndisp);
end
toc();
tic();
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});
    Refined_DisparityMap = refinement(DisparityMap_sparse{1},pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF);
toc();
    colormap(gca,jet);
    toc();
    D_full_u = uint8(Refined_DisparityMap);
% p = psnr(D_full_u,GT_)
%  mask = imread(['MiddEval3/training',imgsize,'/',image_names{4},'/mask0nocc.png']);%Modify
%         mask = mask == 255;
%         Refined_DisparityMap(~mask)=0;
%     [PSNR] = calcPSNR(Refined_DisparityMap,GT);
end
