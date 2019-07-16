function [D,R,T] = disparity_map(scene_path,varargin)
%% Disparity map computation
[ndisp_input,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs(varargin);

[I,ndisp_calib] = input_data(scene_path);%Read im0.png and im1.png from the specified path and read the given ndisp from calib.txt
ndisp = min(ndisp_input,ndisp_calib);
r_range = min_window_radius:max_window_radius;
if algorithm ==0 % This function performs adaptive window match by means of Census transform.
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_adp(I{1}, I{2}, window_radius,ndisp,beta,gamma);
else %This function performs window match with a joint cost function.
    [DisparityMap{1}, DisparityMap{2}] = Census_WM_joint(I{1}, I{2} ,r_range ,ndisp);
end
    [DisparityMap_sparse{1}, DisparityMap_sparse{2}] = Consis_check(DisparityMap{1}, DisparityMap{2});%consistency check
    Refined_DisparityMap = refinement(DisparityMap_sparse{1},pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF);%Refinement
    D = uint8(Refined_DisparityMap/calib);% The map is divided by a calibration index to prevent overflow.
%% T,R calculation

    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    %% Bilder laden
    Image1 = I{1};
    IGray1 = rgb_to_gray(Image1);
    Image2 = I{2};
    IGray2 = rgb_to_gray(Image2);

    %% Harris-Merkmale berechnen
    Merkmale1 = harris_detektor(IGray1,'segment_length',15,'k',0.05,'min_dist',20,'N',5,'do_plot',false);
    Merkmale2 = harris_detektor(IGray2,'segment_length',15,'k',0.05,'min_dist',20,'N',5,'do_plot',false);
    %% Korrespondenzschaetzung
    Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr',0.95,'do_plot',false);
    %% Berechne die Essentielle Matrix
    E = achtpunktalgorithmus(Korrespondenzen);
    %%
    [U,S,V] = svd(E);
    U = U * [1 0 0; 0 1 0; 0 0 -1];
    V = V * [1 0 0; 0 1 0; 0 0 -1]; %don't know why should i do this?
    R_zp = [0 -1  0;
           1  0  0;
           0  0  1];

    R = U*R_zp'*V';
    T_hat = U*R_zp*S*U';
    T = [T_hat(3,2);
          T_hat(1,3);
          T_hat(2,1)];

end
