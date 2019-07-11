function [T1, R1, T2, R2, U, V]=TR_aus_E(E)
    % Diese Funktion berechnet die moeglichen Werte fuer T und R
    % aus der Essentiellen Matrix
    %% Bilder laden
    Image1 = imread('szeneL.png');
    IGray1 = rgb_to_gray(Image1);
    Image2 =imread('szeneR.png');
    IGray2 = rgb_to_gray(Image2);

    %% Harris-Merkmale berechnen
    Merkmale1 = harris_detektor(IGray1,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);
    Merkmale2 = harris_detektor(IGray2,'segment_length',9,'k',0.05,'min_dist',40,'N',50,'do_plot',false);

    %% Korrespondenzschätzung
    Korrespondenzen = punkt_korrespondenzen(IGray1,IGray2,Merkmale1,Merkmale2,'window_length',25,'min_corr',0.9,'do_plot',false);

    %% Berechne die Essentielle Matrix
    %load('K.mat');
    E = achtpunktalgorithmus(Korrespondenzen);
    % disp(E);
    
    %%
    [U,S,V] = svd(E);
    U = U * [1 0 0; 0 1 0; 0 0 -1];
    V = V * [1 0 0; 0 1 0; 0 0 -1]; %don't know why should i do this?
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
end
