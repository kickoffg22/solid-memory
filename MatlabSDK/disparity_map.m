function [D, R, T] = disparity_map(scene_path)
    [I0,I1] = input_image(scene_path);
    I0_grey = rgb_to_gray(I0);
    I1_grey = rgb_to_gray(I1);
end