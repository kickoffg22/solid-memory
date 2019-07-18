%Read im0.png and im1.png from the specified path and read the given ndisp from calib.txt
function [I,ndisp] = input_data(scene_path)
S0 = dir(fullfile(scene_path,'im0.png')); % pattern to match filenames.
S1 = dir(fullfile(scene_path,'im1.png'));
S2 = dir(fullfile(scene_path,'calib.txt')); % pattern to match filenames.
F0 = fullfile(scene_path,S0(1).name); % fullfil the filenames.
F1 = fullfile(scene_path,S1(1).name);
F2 = fullfile(scene_path,S2(1).name);
fileID = fopen(F2,'r');
C = textscan(fileID,'%*6s %s');%read txt file and ignore the first 6 chars in each row
C1 = C{1,1};
ndisp = str2double(C1{17,1});
I0 = imread(F0);
I1 = imread(F1);
I0 = double(I0)/255;%Convert image into double in range 0-1
I1 = double(I1)/255;
I = {I0,I1};
fclose(fileID);
end