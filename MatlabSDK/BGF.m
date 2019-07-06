function D_full = BGF(D1)
BG = zeros(size(D1,1),1);
D_full = D1;
for k = 1:size(D1,1)
%     T = min(D1(k,(find(D1(k,:) > 0))));
    T = D1(k,(D1(k,:) > 0));
    T = mean(T(1:10));
    if ~isempty(T)
        BG(k) = T;
    end
end
BG = BG*ones(1,size(D1,2));
D_full(D_full==0) = D_full(D_full==0) + BG(D_full==0); 
end
