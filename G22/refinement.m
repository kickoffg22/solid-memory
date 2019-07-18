%% This function is used to refine a sparse disparity map. The 
% function firstly perform a majority vote to remove small outliers in the
% map and use a hole filling function to fill the small holes in the
% original map and refine the edges, Majorty vote is performed
% again to try to remove outliers. Finally, function BGF is used to fill
% the missing background which are still invalid.
function R_DM  = refinement(DM,pri_MV,pri_MV_r,pos_MV,pos_MV_r,HF,HF_r,F_BG)
R_DM = DM;
for i =1:pri_MV %Times of interation 
R_DM = major_vote(DM,pri_MV_r);%Radius of hole majority vote window
end

for i = 1:HF%Times of hole filling 
R_DM = hole_filling_m(R_DM,HF_r,HF_r);%Radius of hole filling window
end
for i =1:pos_MV
    R_DM = major_vote(R_DM,pos_MV_r);
end
if F_BG ==1
R_DM = BGF(R_DM);
end
end
