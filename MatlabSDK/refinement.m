%% This function is used to refine a sparse disparity map. The 
% function firstly perform a majority vote to remove small outliers in the
% map and use a hole filling function to fill the small holes in the
% original map and refine the edges, Majorty vote is performed
% again to try to remove outliers. Finally, function BGF is used to fill
% the missing background which are still invalid.
function R_DM  = refinement(DM)
for i =1:2
R_DM = major_vote(DM,3);
end
for i = 1:3
R_DM = hole_filling(R_DM,2);
end
for i =1:2
    R_DM = major_vote(R_DM,3);
end
R_DM = BGF(R_DM);
end
