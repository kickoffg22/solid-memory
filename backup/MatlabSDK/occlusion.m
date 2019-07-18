function img_new=occlusion(img,r)
%find the 0 part
img_ini=[inf(size(img,1),r) img];
img_ini=[img_ini inf(size(img,1),r)];
k=find(img_ini==0);
img_new=img_ini;
store=inf(size(img,1),2);
for i=1:r   
            img_mimic_right=circshift(img_ini,[0,i]); %right shift
            img_mimic_left=circshift(img_ini,[0,-i]);%left shift
            store=[store img_mimic_right(k) img_mimic_left(k)]
end
img_new(k)=min(store');
img_new(:,1:r) = [];
img_new(:,end-r+1:end)=[];
