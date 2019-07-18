function [T,R]=TR(scene_path)
    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    %% Bilder laden
    file0 = fullfile(scene_path,'im0.png');
    Image1 = imread(file0);
    file1 = fullfile(scene_path,'im1.png');
    IGray1 = rgb_to_gray(Image1);
    Image2 =imread(file1);
    IGray2 = rgb_to_gray(Image2);
    
    file_K = fullfile(scene_path, 'calib.txt');
    fileID = fopen(file_K);
    K = textscan(fileID,'%*cam0=[ %f%f%f %*c%f%f%f %*c%f%f%f',1);
    fclose(fileID);
    K = cell2mat(K); 
    K = reshape(K,[3,3]);
    K = K';
    K = K/1000;
    
    %% Harris-Merkmale berechnen
    Merkmale1 = harris_detektor(IGray1,'segment_length',15,'k',0.05,'min_dist',20,'N',5,'do_plot',false);
    Merkmale2 = harris_detektor(IGray2,'segment_length',15,'k',0.05,'min_dist',20,'N',5,'do_plot',false);

    %% Korrespondenzschaetzung
    Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr',0.95,'do_plot',false);

    %% Berechne die Essentielle Matrix
    %load('K.mat');
    E = achtpunktalgorithmus(Korrespondenzen,K);
    % disp(E);
    
    %%
    [U,S,V] = svd(E);
    U = U * [1 0 0; 0 1 0; 0 0 -1];
    V = V * [1 0 0; 0 1 0; 0 0 -1]; %
    R_zp = [0 -1  0;
           1  0  0;
           0  0  1];
    R_zm = [ 0  1  0;
           -1  0  0;
            0  0  1];   
       
    R1 = U*R_zp'*V';
    R2 = U*R_zm'*V';
    
    T1_hat = U*R_zp*S*U';
    T1 = [T1_hat(3,2);
          T1_hat(1,3);
          T1_hat(2,1)];
    T2_hat = U*R_zm*S*U';
    T2 = [T2_hat(3,2);
          T2_hat(1,3);
          T2_hat(2,1)];
%%
[T, R] = rekonstruktion(T1, T2, R1, R2, Korrespondenzen, K);
T = abs(T);
if(det(R)<0)
     R = abs(R);
end
end
