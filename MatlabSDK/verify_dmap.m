function p = verify_dmap(D, G,varargin)
if isinteger(D)&&isinteger(G)==0
    error('The input matrix should be of datatype isinteger');
end
if max(D(:))>255|| min(G(:))<0|| min(D(:))<0
    error('The input matrix should be of datatype uint8');
end
p = inputParser;%Input parser for  
default_calib  = 1;
validationFcn_calib = @(x) isnumeric(x) && isscalar(x);
p.addParameter('calib',default_calib,validationFcn_calib);
calib = p.Results.calib;
D = uint8(D*calib);
p = calcPSNR(D,G);
end