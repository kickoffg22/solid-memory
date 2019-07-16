% path = 'C:\Challenge\motorcycle';
path = 'D:\test\playground';
  GT = readpfm(['D:\test\playground\disp0.pfm']);%Modify
  D = disparity_map(path)
%   GT = uint8(GT);
% [I,ndisp_calib] = input_data(path);%Read im0.png and im1.png from the specified path and read the given ndisp from calib.txt
% ndisp = 20;
%     [DisparityMap{1}, DisparityMap{2}] = Census_WM_adp(I{1}, I{2}, 3,ndisp,30,2);
%     [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});%consistency check
%     Refined_DisparityMap = refinement(DisparityMap_sparse{1},2,3,2,3,3,4,0);%Refinement
%     D = uint8(Refined_DisparityMap);% The map is divided by a calibration in
%     Dd = double(D);
%     imshow(Dd/20);
%     colormap(gca,jet);
% [ndisp,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs()
% a = xxx('abc','ndisp',3)
% [ndisp,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs();
% [I0,I1] = input_image(path);
% I0_grey = rgb_to_gray(I0);
% I1_grey = rgb_to_gray(I1);
% G = readpfm('disp0GT.pfm');
% image(G);
% [D1,D2] = stereoMatchWindowCensus(I0_grey, I1_grey, 5, [30 80])
% imshow(I1_grey)
% merkmale = harris_detektor(I0_grey, 'segment_length', 21, 'k', 0.06, 'do_plot', true);
