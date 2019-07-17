% input variable
pfad='C:\Users\matth\Desktop\solid-memory-master\MatlabSDK\MiddEval3\trainingH\Motorcycle';
ndisp=370;
algorithm=0;
Window_radius=6;
min_window_radius  = 2;
max_window_radius  = 20;
gamma  = 2;
beta  = 25;
pri_MV  = 2;
pri_MV_r  = 3;
pos_MV  = 2;
pos_MV_r  = 3;
HF  = 3;
HF_r  = 4;
calib  = 2;
BGF  = 1;

% Disparity map
tic;
[D,R,T] = disparity_map(pfad,'ndisp',ndisp,'calib',calib,'algorithm',algorithm,'window_radius',Window_radius,'min_window_radius',min_window_radius,'max_window_radius',max_window_radius,'beta',beta,'gamma',gamma,'pri_MV',pri_MV,'pri_MV_r',pri_MV_r,'pos_MV',pos_MV,'pos_MV_r',pos_MV_r,'HF',HF,'HF_r',HF_r,'BGF',BGF);
time_taken=toc;

% PSNR
path_GT=[pfad,'\disp0GT.pfm'];
if ~exist(path_GT,'file')
    PSNR=('no GT');
else
    GT = readpfm([pfad,'/disp0GT.pfm']);
    GT_u = uint8(GT);
    PSNR = verify_dmap(D,GT_u,max(max(D(:),max(GT(:)))));
end

% Show result
disp('Rotation is ');
disp(R);
disp('Translation is ');
disp(T);
disp('PSNR is ');
disp(PSNR);
disp('Time is ');
disp(time_taken);
D=double(D);
imshow(D/max(D(:))) ;   % /max(D(:))
colormap(gca,jet)
drawnow;