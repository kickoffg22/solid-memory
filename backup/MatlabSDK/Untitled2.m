% D1 = magic(3);
% D1 = dec2bin(D1);
% cumsum(D1(1,:))
% D = nnz(D1(:,1))
% D2 = magic(3);
% D2(1,1) = D2(1,1)-1;
% Consistent1(:) = abs(D1(:) - D2(:)) > 0.5;
% ~Consistent1
% D3 = D2(~~Consistent1)
% Consistent1(:) = abs(D1(:) - D2(ind)) < thresh;
% D1out(~Consistent1) = 0;
D_full = BGF(DisparityMap_sparse_fill);
Error5 = abs(D_full - GT) > 1;
Error5(~mask) = 0;   
ErrorRate5 = sum(Error5(:))/sum(mask(:));
imshow([D_full/140 DisparityMap_sparse_fill/140])
colormap(gca,jet)