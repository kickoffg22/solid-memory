% clear variables;
% close all;

% Are you going to use the training or test set?
imgset = 'training';
%imgset = 'test';

% Specify which resolution you are using for the stereo image set (F, H, or Q?)
%imgsize = 'Q';
imgsize = 'H';
%imgsize = 'F';

% What are you calling your method?
methodname = 'ABCD';

if ~exist('MiddEval3results','dir')
    mkdir('MiddEval3results');
end
if ~exist(['MiddEval3results/',imgset,imgsize],'dir')
    mkdir(['MiddEval3results/',imgset,imgsize]);
end

%     image_names{1} = 'Adirondack';
%     image_names{2} = 'ArtL';
%     image_names{3} = 'Jadeplant';
    image_names{4} = 'Motorcycle';
%     image_names{5} = 'MotorcycleE';
%     image_names{6} = 'Piano';
%     image_names{7} = 'PianoL';
%     image_names{8} = 'Pipes';
%     image_names{9} = 'Playroom';
%     image_names{10} = 'Playtable';
%     image_names{11} = 'PlaytableP';
%     image_names{12} = 'Recycle';
%     image_names{13} = 'Shelves';
%     image_names{14} = 'Teddy';
%     image_names{15} = 'Vintage';
    ndisp = [290, 256, 640, 280, 280, 260, 260, 300, 330, 290, 290, 260, 240, 256, 760];

% ErrorRate = zeros(1,15);
% for im_num = 1:15
%     I{1} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{im_num},'/im0.png']);
%     I{2} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{im_num},'/im1.png']);
    I{1} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im0.png']);
    I{2} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im1.png']);
    I{1} = double(I{1})/255;
    I{2} = double(I{2})/255;
    
    % Adjust the range of disparities to the chosen resolution
    if imgsize == 'Q'
        DisparityRange = [1,round(ndisp(im_num)/4)];
    elseif imgsize == 'H'
%         DisparityRange = [1,round(ndisp(im_num)/2)];
          DisparityRange = round(ndisp(4)/2);%%mod
    else
        DisparityRange = [1,round(ndisp(im_num))];
    end
    
    tic;
    %--------------- Insert your stereo matching routine here ------------%
%   path = 'C:\Challenge\motorcycle';
     GT = readpfm(['MiddEval3/training',imgsize,'/',image_names{4},'/disp0GT.pfm']);%Modify
     window_radius = 9;
     [DisparityMap_9{1}, DisparityMap_9{2}] = stereoMatchWindowCensus_adp(I{1}, I{2}, window_radius, DisparityRange,4500,100);
     [DisparityMap_sparse_9{1}, DisparityMap_sparse_9{2}] = Consis_check(DisparityMap_9{1}, DisparityMap_9{2});
     DisparityMap_sparse_fill_9 = DisparityMap_sparse_9{1};
     for i =1:3
     DisparityMap_sparse_fill_9 = hole_filling(DisparityMap_sparse_fill_9,2);
     end
%      DM9 = DisparityMap_9{1};
%      DisparityMap_sparse_full = DisparityMap_sparse_fill_9;
%      DisparityMap_sparse_full(DisparityMap_sparse_full==0)= DM9((DisparityMap_sparse_full==0));
     D_full = BGF(DisparityMap_sparse_fill_9);
%      [PSNR] = calcPSNR(D_full,GT)
%%
     window_radius = 1;
     [DisparityMap_1{1}, DisparityMap_1{2}] = stereoMatchWindowCensus_adp(I{1}, I{2}, window_radius, DisparityRange,4500,100);
     [DisparityMap_sparse_1{1}, DisparityMap_sparse_1{2}] = Consis_check(DisparityMap_1{1}, DisparityMap_1{2});
     DisparityMap_sparse_fill_1 = DisparityMap_sparse_1{1};
     for i =1:3
     DisparityMap_sparse_fill_1 = hole_filling(DisparityMap_sparse_fill_1,2);
     end
%      DM1 = DisparityMap_1{1};
%      DisparityMap_sparse_full_1 = DisparityMap_sparse_fill_1;
%      DisparityMap_sparse_full_1(DisparityMap_sparse_full_1==0)= DM1((DisparityMap_sparse_full_1==0));
     D_full_1 = BGF(DisparityMap_sparse_fill_1);
%%
DisparityMap = DisparityMap_sparse_1{1};
DisparityMap_sparse = DisparityMap_sparse_fill_9(DisparityMap_sparse_fill_1&DisparityMap_sparse_fill_9);
DisparityMap_sparse_fill =   DisparityMap_sparse;
for i =1:3
     DisparityMap_sparse_fill = hole_filling(DisparityMap_sparse_fill,2);
end
D_occ = Occ_fill();
    %---------------------------------------------------------------------%
    time_taken = toc;
    imshow([DisparityMap/DisparityRange,DisparityMap_sparse/DisparityRange;DisparityMap_sparse_fill/DisparityRange,D_occ/DisparityRange;(DisparityMap_sparse_-GT)/DisparityRange,GT/DisparityRange]);
    
    colormap(gca,jet)
    drawnow;
    % This assumes that inconsistent disparities are given a value <= 0
%     DisparityMap_sparse{1}(DisparityMap_sparse{1} <= 0) = Inf; % Necessary for .pfm format
%     DisparityMap_sparse{2}(DisparityMap_sparse{2} <= 0) = Inf; % Necessary for .pfm format
    
    % If possible, compute the error rate
    if strcmp(imgset,'training')
%         GT = readpfm(['MiddEval3/training',imgsize,'/',image_names{im_num},'/disp0GT.pfm']);
%         mask = imread(['MiddEval3/training',imgsize,'/',image_names{im_num},'/mask0nocc.png']);
%         GT = readpfm(['MiddEval3/training',imgsize,'/',image_names{4},'/disp0GT.pfm']);%Modify
        mask = imread(['MiddEval3/training',imgsize,'/',image_names{4},'/mask0nocc.png']);%Modify
        mask = mask == 255;
        bad = 1;
        Error = abs(DisparityMap_1{1} - GT) > bad;
        Error(~mask) = 0;
        Error2 = abs(DisparityMap_sparse_9{1} - GT) > bad;
        Error2(~mask) = 0;
        Error3 = abs(DisparityMap_sparse_fill_9 - GT) > bad;
        Error3(~mask) = 0;
        Error4 = abs(DisparityMap_sparse_full - GT) > bad;
        Error4(~mask) = 0;       
        Error5 = abs(D_full - GT) > bad;
        Error5(~mask) = 0;   
        Error6 = abs(D_occ - GT) > bad;
        Error6(~mask) = 0; 
%         ErrorRate(im_num) = sum(Error(:))/sum(mask(:));
        ErrorRate = sum(Error(:))/sum(mask(:))%Original map
%         ErrorRate2 = sum(Error2(:))/sum(mask(:))%sparse map
        ErrorRate3 = sum(Error3(:))/sum(mask(:))%hole filled map
        ErrorRate4 = sum(Error4(:))/sum(mask(:))%hole filled map filled with original map
        ErrorRate5 = sum(Error5(:))/sum(mask(:))%hole filled map filled with back ground filling
        ErrorRate6 = sum(Error6(:))/sum(mask(:))
%         fprintf('%s = %f\n', image_names{im_num}, ErrorRate(im_num));
          fprintf('%s = %f\n', image_names{4}, ErrorRate);
    end
    
    % Output disparity maps and timing results for Middlebury evaluation
%     if ~exist(['MiddEval3results/',imgset,imgsize,'/',image_names{im_num}],'dir')
%         mkdir(['MiddEval3results/',imgset,imgsize,'/',image_names{im_num}]);
    if ~exist(['MiddEval3results/',imgset,imgsize,'/',image_names{4}],'dir')
        mkdir(['MiddEval3results/',imgset,imgsize,'/',image_names{4}]);
    end
%     pfmwrite(single(DisparityMap{1}), ['MiddEval3results/',imgset,imgsize,'/',image_names{im_num},'/disp0',methodname,'.pfm']);
%     pfmwrite(single(DisparityMap_sparse{1}), ['MiddEval3results/',imgset,imgsize,'/',image_names{im_num},'/disp0',methodname,'_s.pfm']);
    pfmwrite(single(DisparityMap_1{1}), ['MiddEval3results/',imgset,imgsize,'/',image_names{4},'/disp0',methodname,'.pfm']);
    pfmwrite(single(DisparityMap_sparse_9{1}), ['MiddEval3results/',imgset,imgsize,'/',image_names{4},'/disp0',methodname,'_s.pfm']);
%     fid = fopen(['MiddEval3results/',imgset,imgsize,'/',image_names{im_num},'/time',methodname,'.txt'],'w');
    fid = fopen(['MiddEval3results/',imgset,imgsize,'/',image_names{4},'/time',methodname,'.txt'],'w');
    fprintf(fid,'%f',time_taken);
    fclose(fid);
% end
% Display compute time.
elapsed = toc();
fprintf('Calculating disparity map took %.2f min.\n', elapsed / 60.0);
% if strcmp(imgset,'training')
%     ErrorRateMean = (sum(ErrorRate([1,2,3,4,5,6,8,11,12,14])) + 0.5*sum(ErrorRate([7,9,10,13,15])))/12.5;
%     fprintf('Overall = %f\n', ErrorRateMean);
% end