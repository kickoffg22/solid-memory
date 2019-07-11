function [I0,I1] = input_image(scene_path)
S0 = dir(fullfile(scene_path,'im0.png')); % pattern to match filenames.
S1 = dir(fullfile(scene_path,'im1.png')); % pattern to match filenames.
F0 = fullfile(scene_path,S0(1).name);
F1 = fullfile(scene_path,S1(1).name);
I0 = imread(F0);
I1 = imread(F1);
end