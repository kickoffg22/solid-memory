function naive()
% Import the stereo images.
path = 'C:\Challenge\motorcycle';
[left,right] = input_image(path);
fprintf('Performing basic block matching...\n');
% Start a timer.
tic();
% Convert the images from RGB to grayscale.
left_grey = rgb_to_gray(left);
right_grey = rgb_to_gray(right);

end