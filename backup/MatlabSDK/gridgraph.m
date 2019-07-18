% function G = gridgraph(window_radius)
GT = readpfm(['MiddEval3/training',imgsize,'/',image_names{4},'/disp0GT.pfm']);%Modify
% clear variables;
% close all;
window_radius = 9;
window_length = window_radius*2 + 1;
beta = 1;
d = 3;
A_length  = window_length^2;%number of cols/rows for adjacency
A = zeros(A_length);
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
nx = 2683-1482;
ny = 64;
w = 4;
DisparityRange = [1,140];
% ErrorRate = zeros(1,15);
% for im_num = 1:15
%     I{1} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{im_num},'/im0.png']);
%     I{2} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{im_num},'/im1.png']);
    I{1} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im0.png']);
    I{2} = imread(['MiddEval3/',imgset,imgsize,'/',image_names{4},'/im1.png']);
    I{1} = double(I{1});%/255
    I{2} = double(I{2});%/255
    
    I1=I{1};
    I2=I{2};
    
    [~,cols,~] = size(I1);
    [rows,cols2,~] = size(I2);
    if cols > cols2
    I2(:,end+1:cols,:) = 0;
    elseif cols2 > cols
    cols = cols2;
    I1(:,end+1:cols2,:) = 0;
    end
    %pixel p of the reference image and a pixel q of the match view.
%     p = I1(1:window_length,1:window_length,:);    
%     q = I2(1:window_length,1+d:d+window_length,:);
    M1min = inf(rows,cols);
    M2min = inf(rows,cols);
    D1 = single(zeros(rows,cols));
    D2 = single(zeros(rows,cols));
    
%     for i = 1+window_radius:(rows-window_radius)
     for i = ny-w:ny+w
        fprintf('Computing cost volume...(disparity = %04d)', i);
        tic()
%         for j = 1+window_radius:(cols-window_radius-DisparityRange(2)) 
        for j = nx-w:nx+w
            M = inf(1,numel(d)); 
            for d = DisparityRange(1):DisparityRange(2)                
                p = I1(i-window_radius:i+window_radius,j-window_radius:j+window_radius,:);
                q = I2(i-window_radius:i+window_radius,j+d-window_radius:j+d+window_radius,:);               
                m = geo_cost(p,q,10000);
                M(1,d) =m;            
            end          
            [~,min_d] = min(M);
            D1(i,j) = min_d;
        end
        toc()
     end
%      er = 1 - nnz(abs(GT(ny-w:ny+w,nx-w:nx+w) - D1(ny-w:ny+w,nx-w:nx+w))<1)/(2*w+1)^2
     
function m = geo_cost(p,q,beta)
window_length = size(p,1);
A_length = window_length^2;
A = zeros(A_length);
ps = reshape(p,[size(p,1)*size(p,2),[],3]);%stacked p, each row indicates a point
qs = reshape(q,[size(q,1)*size(q,2),[],3]);%stacked p, each row indicates a point
%create a grapg with spatially neighbouring points in 8-connectivity, whose
%edge weight is the color difference between the neighbouring points.
for i = 1:A_length
    for j = 1:A_length
        if (j==i+1 && mod(i,window_length)~=0)|| j==i+window_length ||j==i+window_length+1 && mod(i,window_length)~=0||(j==i+window_length-1&&mod(i,window_length)~=1)      
            A(i,j) = sum((ps(i,:) - qs(j,:)).^2);% determines the color difference between two connected point
        elseif i==j
            A(i,j) = 0;
        end
    end
end
A = A+A';%adjacency must be symmetric
G = graph(A);
d = distances(G,(A_length+1)/2);%1*numel(A) row vector,distance from the window center to each point
%aggregated matching costs for a pixel c at disparity d
f = sum((p - q).^2,3);% determines the color difference between the corresponding pixel in two windows 
fs = reshape(f,1,[]);
w = exp(-d/beta);%support weight
m = sum(fs.*w);%match cost
end

% plot(G,'EdgeLabel',G.Edges.Weight)

% end