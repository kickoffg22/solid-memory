function [D,R,T] = disparity_map(scene_path,varargin)
[ndisp_input,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs(varargin);

[I,ndisp_calib] = input_data(scene_path);%Read im0.png and im1.png from the specified path and read the given ndisp from calib.txt
ndisp = min(ndisp_input,ndisp_calib);
r_range = min_window_radius:max_window_radius;
if algorithm ==0
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_adp(I{1}, I{2}, window_radius,ndisp,beta,gamma);
else
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2} ,r_range ,ndisp);
end
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});%consistency check
    Refined_DisparityMap = refinement(DisparityMap_sparse{1},pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF);%Refinement
    D = uint8(Refined_DisparityMap/calib);% The map is divided by a calibration index to prevent overflow.
%% Add T,R calculation here
R = 1;
T = 1;
end
