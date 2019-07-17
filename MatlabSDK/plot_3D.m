function plot_3D(disparitymap,img_ori)
 Z=disparitymap;
 x=[1:size(disparitymap,1)];
 y=[1:size(disparitymap,2)];
 C0(:,:,1)=img_ori(:,:,1)';
 C0(:,:,2)=img_ori(:,:,2)';
 C0(:,:,3)=img_ori(:,:,3)';
 [X,Y]=meshgrid(x,y);
 s=surf(X,Y,Z',C0);
 s.EdgeColor = 'none';
 view(82.4,86.77);
end
