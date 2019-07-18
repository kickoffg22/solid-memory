clear variables;
close all;

% Are you going to use the training or test set?
imgset = 'training';

% Specify which resolution you are using for the stereo image set (F, H, or Q?)
imgsize = 'H';

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