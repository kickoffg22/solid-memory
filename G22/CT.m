% Usage: C = CT(I)
%
%The census transform (CT) is an image operator that associates to each 
%pixel of a grayscale image a binary string, encoding whether the pixel has
%smaller intensity than each of its neighbours, one for each bit.
%
% Takes as input an image <I>, if I is a rgb image, transform I into a
% greyscale imgae.The defalut window size is 9*7 pixel and encode
% the point into a binary string by comparing the conter point with the pixel in the window.

function C = CT(I,varargin)
fprintf('Performing Census Tranform \n');
p = inputParser;
default_window_length  = 7;
validationFcn_window_length = @(x) isnumeric(x) && isscalar(x) &&(mod(x,2)==1) && (x > 1);
p.addParameter('window_length',default_window_length,validationFcn_window_length);

default_window_width  = 7;
validationFcn_window_width = @(x) isnumeric(x) && isscalar(x) &&(mod(x,2)==1) && (x > 1);
p.addParameter('window_width',default_window_width,validationFcn_window_width);   

parse(p,varargin{:});
window_length = p.Results.window_length;
window_width = p.Results.window_width;
%% If the given I is RGB, convert I into grescale 
[rows, cols, channels] = size(I);
if channels == 3
        image2 = double(I);
        R=image2(:,:,1);%R Channel
        G=image2(:,:,2);%G Channel
        B=image2(:,:,3);%G Channel
        I = 0.299*R+0.587*G+0.114*B;
end
%%
if window_length*window_width>64
    error('The given window size should be smaller than 64');
elseif window_length*window_width>32
    C = uint64(zeros(rows,cols));
else
    C = uint32(zeros(rows,cols));
end
power = window_length*window_width;
shifteded_I = zeros(size(I));
i_max = (window_length-1)/2;
j_max = (window_width-1)/2;
%calculate the census transform of the whole image by shifting the image
%from upper left to bottom right and assign a power according to the
%relative position
for i = -i_max:i_max
    for j = -j_max:j_max
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
        C(I < shifteded_I) = bitset(C(I < shifteded_I),power);
        power = power - 1;
    end
end
end