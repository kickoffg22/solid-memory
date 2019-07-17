%% Computer Vision Challenge 2019

% Group number:
group_number = 'G22';

% Group members:
% members = {'Max Mustermann', 'Johannes Daten'};
members = {'Shuo Ma','Cong Wang','Fengyi Wang','Chengjie Yuan','Wenjian Zhao'};

% Email-Address (from Moodle!):
% mail = {'ga99abc@tum.de', 'daten.hannes@tum.de'};
mail = {'matthew.ma@tum.de','ge57qom@mytum.de','ge25cer@mytum.de','jerrycj622.yuan@tum.de','ge73pih@mytum.de'};

%% Start timer here
tic;

%% Disparity Map
% Specify path to scene folder containing img0 img1 and calib
scene_path = 'C\test\Motorcycle';
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
% 
% Calculate disparity map and Euclidean motion
[D,R,T] = disparity_map(scene_path,'ndisp',ndisp,'calib',calib,'algorithm',algorithm,'window_radius',Window_radius,'min_window_radius',min_window_radius,'max_window_radius',max_window_radius,'beta',beta,'gamma',gamma,'pri_MV',pri_MV,'pri_MV_r',pri_MV_r,'pos_MV',pos_MV,'pos_MV_r',pos_MV_r,'HF',HF,'HF_r',HF_r,'BGF',BGF);

%% Validation
% Specify path to ground truth disparity map
% gt_path = 'paht\to\ground\truth'
path_GT=[scene_path,'\disp0GT.pfm'];
if ~exist(path_GT,'file')
    p=('no GT');
else
    GT = readpfm([scene_path,'/disp0GT.pfm']);
    GT_u = uint8(GT);
    p = verify_dmap(D,GT_u,max(max(D(:),max(GT(:)))));
end

%% Stop timer here
elapsed_time = toc;


%% Print Results
% R, T, p, elapsed_time
disp('Rotation is ');
disp(R);
disp('Translation is ');
disp(T);
disp('PSNR is ');
disp(p);
disp('Time is ');
disp(elapsed_time);


%% Display Disparity
D_mask = D;
D_mask(GT_u==0)=0;
D_mask=double(D_mask);
imshow([D_mask/max(D_mask(:)),GT/max(GT(:))]) ; 
colormap(gca,jet)
drawnow;


