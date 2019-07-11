% Usage: C = CT(I)
%
%The census transform (CT) is an image operator that associates to each 
%pixel of a grayscale image a binary string, encoding whether the pixel has
%smaller intensity than each of its neighbours, one for each bit.
%
% Takes as input an image <I>, if I is a rgb image, transform I into a
% greyscale imgae.The defalut window size is 9*7 pixel and encode
% the point into a binary string by comparing the conter point with the pixel in the window.

function C = Adp_CT(I,varargin)
fprintf('Performing Census Tranform.');
fprintf('\n');
tic();
p = inputParser;
default_window_long  = 15;
validationFcn_window_long = @(x) isnumeric(x) && isscalar(x) &&(mod(x,2)==1) && (x > 1);
p.addParameter('window_long',default_window_long,validationFcn_window_long);

default_window_short  = 3;
validationFcn_window_short = @(x) isnumeric(x) && isscalar(x) &&(mod(x,2)==1) && (x > 1);
p.addParameter('window_short',default_window_short,validationFcn_window_short);   

parse(p,varargin{:});
window_long = p.Results.window_long;
window_short = p.Results.window_short;
%% If the given I is RGB, convert I into grescale 
[rows, cols, channels] = size(I);
if channels == 3
        image2 = double(I);
        R=image2(:,:,1);%R Channel
        G=image2(:,:,2);%G Channel
        B=image2(:,:,3);%G Channel
        I = 0.299*R+0.587*G+0.114*B;
end
[Fx, Fy] = sobel(I);
C = zeros(size(I));
wr = [window_short window_long 7; window_long window_short 7];
%%
Single_C = uint64(zeros(rows,cols));
C_layer = {Single_C,Single_C,Single_C};
for r = 1:3
Single_C = uint64(zeros(rows,cols));
shifteded_I = zeros(size(I));
i_max = (wr(1,r)-1)/2;
j_max = (wr(2,r)-1)/2;
power = wr(1,r)*wr(2,r);
%calculate the census transform of the whole image by shifting the image
%from upper left to bottom right and assign a power according to the
%relative position
for i = -i_max:i_max % Vertical shift range
    for j = -j_max:j_max% Horizontal shify range
        shifteded_I(:,:) = 0;
        if i <= 0 && j <= 0 %comparing to upper left
            shifteded_I(1:end+i,1:end+j) = I(1-i:end,1-j:end);
        elseif i <= 0 && j >= 0%comparing to upper right
            shifteded_I(1:end+i,1+j:end) = I(1-i:end,1:end-j);
        elseif i >= 0 && j <= 0%comparing to bottom left
            shifteded_I(1+i:end,1:end+j) = I(1:end-i,1-j:end);
        elseif i >= 0 && j >= 0%comparing to bottom right
            shifteded_I(1+i:end,1+j:end) = I(1:end-i,1:end-j);
        end
        Single_C(I < shifteded_I) = bitset(Single_C(I < shifteded_I),power);
        C_layer{r} = Single_C;
        power = power - 1;
    end
end
C_37 = C_layer{1};
C_73 = C_layer{2};
C_77 = C_layer{3};
C(Fx>Fy) = C_73(Fx>Fy);% Larger griadient in x direction, choose a wiindow with latger vertical size.
C(Fx<Fy) = C_37(Fx<Fy);
C(Fx==Fy) = C_77(Fx==Fy);
end
elapsed = toc();
fprintf('Census Tranform took %.2f s.\n', elapsed);
end