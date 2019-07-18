function [Fx, Fy] = sobel(input_image)
[~, ~, channels] = size(input_image);
if channels == 3
        image2 = double(input_image);
        R=image2(:,:,1);%R Channel
        G=image2(:,:,2);%G Channel
        B=image2(:,:,3);%G Channel
        input_image = 0.299*R+0.587*G+0.114*B;
end
    % In dieser Funktion soll das Sobel-Filter implementiert werden, welches
    % ein Graustufenbild einliest und den Bildgradienten in x- sowie in
    % y-Richtung zurueckgibt.
    Sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
    Sobel_y = Sobel_x';
    Fx = conv2(input_image,Sobel_x,'same');
    Fy = conv2(input_image,Sobel_y,'same');   
end