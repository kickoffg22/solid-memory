function p = verify_dmap(D, G,varargin)
if isuint8(D)&&isuint8(G)==0
    error('The input matrix should be of datatype uint8');
end
p = inputParser;%Input parser for  
default_calib  = 2;
validationFcn_calib = @(x) isnumeric(x) && isscalar(x) &&isinteger(x);
p.addParameter('calib',default_calib,validationFcn_calib);
calib = p.Results.calib;

G = uint8(G*calib*255/max(G(:)));%Nomolize the input matrix to interval[0,255];
D = uint8(D*255/max(G(:)));
p = calcPSNR(D,G);
end