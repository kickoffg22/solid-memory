% path = 'C:\Challenge\motorcycle';
% path = 'D:\test\playground';
% [ndisp,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs()
% a = xxx('abc','ndisp',3)
% [D,R,T] = disparity_map(path);
% [ndisp,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs();
% [I0,I1] = input_image(path);
% I0_grey = rgb_to_gray(I0);
% I1_grey = rgb_to_gray(I1);
% G = readpfm('disp0GT.pfm');
% image(G);
% [D1,D2] = stereoMatchWindowCensus(I0_grey, I1_grey, 5, [30 80])
% imshow(I1_grey)
% merkmale = harris_detektor(I0_grey, 'segment_length', 21, 'k', 0.06, 'do_plot', true);
b=xxx('path',1)
function a = xxx(varargin)
p = inputParser;
p.addRequired('path');

rn = p.Results.path;
a = rn;
end
