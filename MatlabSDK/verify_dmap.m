function p = verify_dmap(D, G)
if isuint8(D)&&isuint8(G)==0
    error('The input matrix should be datatype uint8');
end
G = uint8(G*255/max(G(:)));%Nomolize the input matrix to interval[0,255];
D = uint8(D*255/max(G(:)));
p = calcPSNR(D,G);
end