% path = 'C:\Challenge\motorcycle';
path = 'D:\test\Motorcycle';
[D,R,T] = disparity_map(path);
% [I0,I1] = input_image(path);
% I0_grey = rgb_to_gray(I0);
% I1_grey = rgb_to_gray(I1);
% G = readpfm('disp0GT.pfm');
% image(G);
% [D1,D2] = stereoMatchWindowCensus(I0_grey, I1_grey, 5, [30 80])
% imshow(I1_grey)
% merkmale = harris_detektor(I0_grey, 'segment_length', 21, 'k', 0.06, 'do_plot', true);