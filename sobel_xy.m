function [Fx, Fy] = sobel_xy(input_image)
    % In dieser Funktion soll das Sobel-Filter implementiert werden, welches
    % ein Graustufenbild einliest und den Bildgradienten in x- sowie in
    % y-Richtung zurueckgibt.
    Sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
    Sobel_y = Sobel_x';
    Fx = conv2(input_image,Sobel_x,'same');
    Fy = conv2(input_image,Sobel_y,'same');   
end