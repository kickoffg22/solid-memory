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

    image_names{4} = 'Motorcycle';

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
          DisparityRange = [1,round(ndisp(4)/2)];
    else
        DisparityRange = [1,round(ndisp(im_num))];
    end
    %% test
    I1 = I{1};
    c1 = censusTransform9x7(I1);
    imshow(c1)
    %% censusTranformation
function C = censusTransform9x7(I)

[rows, cols, channels] = size(I);
if channels == 3
    I = rgb2gray(I);
end

C = uint64(zeros(rows,cols));
pow = 63;
Ishifted = zeros(size(I));
for rs = -4:4
    for cs = -3:3
        Ishifted(:,:) = 0;
        if rs <= 0 && cs <= 0
            Ishifted(1:end+rs,1:end+cs) = I(1-rs:end,1-cs:end);
        elseif rs <= 0 && cs >= 0
            Ishifted(1:end+rs,1+cs:end) = I(1-rs:end,1:end-cs);
        elseif rs >= 0 && cs <= 0
            Ishifted(1+rs:end,1:end+cs) = I(1:end-rs,1-cs:end);
        elseif rs >= 0 && cs >= 0
            Ishifted(1+rs:end,1+cs:end) = I(1:end-rs,1:end-cs);
        end
        C(I < Ishifted) = bitset(C(I < Ishifted),pow);
        pow = pow - 1;
    end
end

end