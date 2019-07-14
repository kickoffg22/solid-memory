function [ndisp,algorithm,window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,HF,HF_r] = parse_inputs(varargin)
fprintf('Performing Census Tranform \n');
p = inputParser;
default_ndisp  = 370;
validationFcn_ndisp = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('ndisp',default_ndisp,validationFcn_ndisp);

default_algorithm  = 0;
validationFcn_algorithm = @(x) islogic(x);
p.addParameter('algorithm',default_algorithm,validationFcn_algorithm); 

default_window_radius  = 6;
validationFcn_window_radius = @(x) isnumeric(x)&& x>0 &&isinteger(x);
p.addParameter('window_radius',default_window_radius,validationFcn_window_radius); 

default_gamma  = 2;
validationFcn_gamma = @(x) isnumeric(x) && isscalar(x);
p.addParameter('gamma',default_gamma,validationFcn_gamma);   

default_beta  = 25;
validationFcn_beta = @(x) isnumeric(x);
p.addParameter('beta',default_beta,validationFcn_beta); 

default_pri_MV  = 2;
validationFcn_pri_MV = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('pri_MV',default_pri_MV,validationFcn_pri_MV); 

default_pri_MV_r  = 3;
validationFcn_pri_MV_r = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('pri_MV_r',default_pri_MV_r,validationFcn_pri_MV_r); 

default_pos_MV  = 2;
validationFcn_pos_MV = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('pos_MV',default_pos_MV,validationFcn_pos_MV); 

default_pos_MV_r  = 3;
validationFcn_pos_MV_r = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('pos_MV_r',default_pos_MV_r,validationFcn_pos_MV_r); 

default_HF  = 3;
validationFcn_HF = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('HF',default_HF,validationFcn_HF); 

default_HF_r  = 4;
validationFcn_HF_r = @(x) isnumeric(x) && isscalar(x) && x>0 &&isinteger(x);
p.addParameter('HF_r',default_HF_r,validationFcn_HF_r); 

parse(p,varargin{:});
ndisp = p.Results.ndisp;%Maximum disparity range
algorithm = p.Results.algorithm;%Algorithm chosen,0 indicates fixed window match with joint cost function,1 indicates 
window_radius = p.Results.window_radius;
gamma = p.Results.gamma;
beta = p.Results.beta;
pri_MV = p.Results.pri_MV;
pri_MV_r = p.Results.pri_MV_r;
pos_MV = p.Results.pos_MV;
HF_r = p.Results.HF_r;
HF = p.Results.HF;

if isvector(window_radius)&&algorithm==1
error('The input of fixed window radius must be a scalar.')
end
end