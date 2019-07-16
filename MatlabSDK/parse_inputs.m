function [ndisp,algorithm,window_radius,min_window_radius,max_window_radius,beta,gamma,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,BGF,calib] = parse_inputs(varargin)
default_ndisp  = 370;
default_algorithm  = 0;
default_window_radius  = 6;
default_min_window_radius  = 2;
default_max_window_radius  = 20;
default_gamma  = 2;
default_beta  = 25;
default_pri_MV  = 2;
default_pri_MV_r  = 3;
default_pos_MV  = 2;
default_pos_MV_r  = 3;
default_HF  = 3;
default_HF_r  = 4;
default_calib  = 1;
default_BGF  = 1;

p = inputParser;

addRequired(p,'path');

validationFcn_ndisp = @(x) isnumeric(x) && isscalar(x) ;
p.addParameter('ndisp',default_ndisp,validationFcn_ndisp);


validationFcn_algorithm = @(x) islogic(x);
p.addParameter('algorithm',default_algorithm,validationFcn_algorithm); 

validationFcn_window_radius = @(x) isnumeric(x)&& x>0;
p.addParameter('window_radius',default_window_radius,validationFcn_window_radius); 

validationFcn_window_radius = @(x) isnumeric(x)&& x>0;
p.addParameter('min_window_radius',default_min_window_radius,validationFcn_window_radius); 

validationFcn_window_radius = @(x) isnumeric(x)&& x>0;
p.addParameter('max_window_radius',default_max_window_radius,validationFcn_window_radius); 

validationFcn_gamma = @(x) isnumeric(x) && isscalar(x);
p.addParameter('gamma',default_gamma,validationFcn_gamma);   

validationFcn_beta = @(x) isnumeric(x);
p.addParameter('beta',default_beta,validationFcn_beta); 

validationFcn_pri_MV = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('pri_MV',default_pri_MV,validationFcn_pri_MV); 

validationFcn_pri_MV_r = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('pri_MV_r',default_pri_MV_r,validationFcn_pri_MV_r); 

validationFcn_pos_MV = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('pos_MV',default_pos_MV,validationFcn_pos_MV); 

validationFcn_pos_MV_r = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('pos_MV_r',default_pos_MV_r,validationFcn_pos_MV_r); 

validationFcn_HF = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('HF',default_HF,validationFcn_HF); 

validationFcn_HF_r = @(x) isnumeric(x) && isscalar(x) && x>0;
p.addParameter('HF_r',default_HF_r,validationFcn_HF_r); 


validationFcn_calib = @(x) isnumeric(x) && isscalar(x);
p.addParameter('calib',default_calib,validationFcn_calib);

validationFcn_BGF = @(x) islogic(x);
p.addParameter('BGF',default_BGF,validationFcn_BGF); 
parse(p,varargin{:});


ndisp = p.Results.ndisp;%Maximum disparity range
algorithm = p.Results.algorithm;%Algorithm chosen,0 indicates fixed window match with joint cost function,1 indicates 
window_radius = p.Results.window_radius;
min_window_radius = p.Results.min_window_radius;
max_window_radius = p.Results.max_window_radius;
gamma = p.Results.gamma;
beta = p.Results.beta;
pri_MV = p.Results.pri_MV;
pri_MV_r = p.Results.pri_MV_r;
pos_MV = p.Results.pos_MV;
pos_MV_r = p.Results.pos_MV_r;
HF_r = p.Results.HF_r;
HF = p.Results.HF;
BGF = p.Results.BGF;
calib = p.Results.calib;
end