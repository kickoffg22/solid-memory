% clear variables;
% close all;

% Are you going to use the training or test set?
imgset = 'training';
%imgset = 'test';

% Specify which resolution you are using for the stereo image set (F, H, or Q?)
imgsize = 'H';

if ~exist('MiddEval3results','dir')
    mkdir('MiddEval3results');
end
if ~exist(['MiddEval3results/',imgset,imgsize],'dir')
    mkdir(['MiddEval3results/',imgset,imgsize]);
end

    image_names{4} = 'Motorcycle';

    ndisp = [290, 256, 640, 280, 280, 260, 260, 300, 330, 290, 290, 260, 240, 256, 760];

    I{1} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im0.png']);
    I{2} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im1.png']);
    I{1} = double(I{1})/255;
    I{2} = double(I{2})/255;
[Fx1, Fy1] = sobel(I{1});

imshow([Fx1,Fy1])