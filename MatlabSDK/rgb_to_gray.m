function gray_image = rgb_to_gray(input_image)
    % Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
    % das Bild bereits in Graustufen vorliegt, soll es direkt zurueckgegeben werden.
    imgsize = size(input_image);
    if numel(imgsize) < 3
        gray_image = input_image;
    else
        image2 = double(input_image);
        R=image2(:,:,1);%R Channel
        G=image2(:,:,2);%G Channel
        B=image2(:,:,3);%B Channel   
        gray_image = 0.299*R+0.587*G+0.114*B;
%         gray_image = uint8(gray_image);
    end
end