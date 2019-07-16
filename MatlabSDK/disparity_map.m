function [D,R,T] = disparity_map(scene_path,varargin)
%% Disparity map computation
f0 = waitbar(0,'Please wait...');
pause(1)
[ndisp_input,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs(varargin);
waitbar(.05,f0,'Importing data');
[I,ndisp_calib] = input_data(scene_path);%Read im0.png and im1.png from the specified path and read the given ndisp from calib.txt
ndisp = min(ndisp_input,ndisp_calib);
r_range = min_window_radius:max_window_radius;
close(f0);
if algorithm ==0 % This function performs adaptive window match by means of Census transform.
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_adp(I{1}, I{2}, window_radius,ndisp,beta,gamma);
else %This function performs window match with a joint cost function.
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2} ,r_range ,ndisp);
end
    f2 = waitbar(0.8,'Performing refinement');
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});%consistency check
    Refined_DisparityMap = refinement(DisparityMap_sparse{1},pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF);%Refinement
    D = uint8(Refined_DisparityMap/calib);% The map is divided by a calibration index to prevent overflow.
%% T,R calculation
    waitbar(0.9,f2,'Calculating T,R');
[T,R]=TR(scene_path);
waitbar(1,f2,'Finishing');

close(f2)
end
