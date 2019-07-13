%% Consistency check
function [spr_D1,spr_D2] = Consis_check(D1, D2,varargin)
fprintf('Performing Consistency check');
p = inputParser;
default_threshold  = 1;
validationFcn_threshold = @(x) isnumeric(x) && isscalar(x) && (x > 0);
p.addParameter('threshold',default_threshold,validationFcn_threshold); 

parse(p,varargin{:});
threshold = p.Results.threshold;

spr_D1 = D1;
spr_D2 = D2;
D1 = round(D1);
D2 = round(D2);

Consistent1 = zeros(size(D1));
Consistent2 = zeros(size(D2));

[I, J] = ind2sub(size(D1),1:numel(D1));
ind = sub2ind(size(D1),I(:),max(J(:)-D1(:),1));
Consistent1(:) = abs(D1(:) - D2(ind)) < threshold;
ind = sub2ind(size(D1),I(:),min(J(:)+D2(:),size(D1,2)));
Consistent2(:) = abs(D1(ind) - D2(:)) < threshold;
spr_D1(~Consistent1) = 0;
spr_D2(~Consistent2) = 0;