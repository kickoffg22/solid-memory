G22
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Instruction of ‘start_gui.fig’

In this dialog box, you can enter the address of the folder where the images are located. 
Importantly, please name the two images as im0 and im1 in advance, the format is png.
In addition, if there is Groundtruth, please name it disp0.pfm and put it in the same file with im0.png and im1.png.
You can also adjust each parameter in input panel.
Start the program by 'Start' button.  After the result is displayed, you can clear the output result by 'Clear' button.
Afterwards, you can klick '3D-plot' button to view the 3D plot of the figure.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function 'disparity_map'
Example: [D,R,T] = disparity_map('C:\Motorcycle') or [D,R,T] = disparity_map('C:\Motorcycle','ndisp',30, 'algotithm',1)
This function has input parser which has a folder path as required input and 15 other optional parameters which will influence the performance. 
The output of the function is the disparity map D, rotation matrix R and translation vector T.
The function will read 'im0.png' and 'im1.png' from the given folder and ndisp from 'calib.txt' and performing disparity map calculation.
It has 2 optional algorithms which can be selected with parameter 'algorithm'.
The output of D will be divided by a nomorlization factor 'calib'(default:1) to prevent overflow.
Input list:
'ndisp': positive integer, used to set the maximum disparity range manually, the minimum of the input ndisp and the value read from the 'calib.txt' will be used.
'algorithm': logic, used to select algorithm, default value:0. With 0, window matching with adaptive window size will be performed. With 1, a window matching with fixed window size and joint matching cost will be performed.
'window_radius': positive integer, default value:6. Radius of aggregation window size in fixed window matching. (Only matters when algorithm = 1)
'min_window_radius', 'max_window_radius': Radius range of aggregation window size in adaptive window matching.Positive integer, default value: 2,20.  (Only matters when algorithm = 0)
'beta','gamma': positive, penalty coefficient for small window size in adaptive window matching, the larger these values are, the larger the penalty, gamma should be smaller than 2* window +1. (Only matters when algorithm¡¯ = 1)
'pri_MV', 'pri_MV_r', 'pos_MV', 'pos_MV_r', 'HF', 'HF_r': Refinement factors,positive integers, default value:2,3,3,4,2,3.  Determine the number of iteration and radius of window in majority vote before and after hole filling and number of iteration and radius of window in hole filling.
'BGF': logic, default value:1. Determine whether the background filling will be performed.
'calib': positive, default value:1, a normalization factor used to prevent overflow in disparity map output.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Function 'verify_dmap'
Example: p = verify_dmap(D, G),p = verify_dmap(D, G,30)
This function calculates the psnr value of the two input matrices which must be of uint8 type in [0,255]. The output value is the psnr value.
Input list:
D: uint8 matrix of disparity map;
G: uint8 matrix of ground truth;
peak: peak value of the input image, default value:255. For disparity maps with the largerst disparity much smaller than 255, this input is necessary to get a right PSNR value. 
--------------------------------------------------------------------------------------

Unittest
The purpose of this class (Unittest) is to check the properties of our function.
It is composed of three parts: 

1.testToolboxes
To check if there are no toolboxes used in our three functions: 
'challenge.m',' disparity_map.m', 'verify_dmap.m'.

2. testVariables
a) To check if these variables in challenge.m are not empty: 
group_member, members, mail
b) To check if these variables in challenge.m are larger than zero:
elapsed_time, D, R, T, p

3. check_psnr
To check the difference between the calculated PSNR (got from function varify_dmap) 
and the actual PSNR (got from image processing toolbox) are smaller than 5%.

In order to run the unittest, input 
run(Unittests) 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
