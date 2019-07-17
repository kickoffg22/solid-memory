%{
Readme
--------------------------------------------------------------------------------------
The purpose of this class (Unittests) is to check the properties of our function.
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
--------------------------------------------------------------------------------------
In order to run the unittest, input 
run(Unittests) 
in the command window.
%}
classdef Unittests < matlab.unittest.TestCase
    
    properties
    end
    
    methods(Test)
        function testToolboxes(testCase)  % check if no toolboxes are used in these functions
            testCase.verifyFalse(check_toolboxes('challenge.m'));
            testCase.verifyFalse(check_toolboxes('disparity_map.m'));
            testCase.verifyFalse(check_toolboxes('verify_dmap.m'));
        end
        
        function testVariables(testCase) % check if the necessary values are not empty as well as larger than zero
            challenge;       %% Call the function  
            testCase.verifyNotEmpty(group_number);
            testCase.verifyNotEmpty(members);
            testCase.verifyNotEmpty(mail);
            testCase.verifyNotEmpty(R);
            testCase.verifyNotEmpty(elapsed_time);
            testCase.verifyNotEmpty(D);
            testCase.verifyNotEmpty(T);
            testCase.verifyNotEmpty(p);
           
            testCase.verifyGreaterThan(elapsed_time,0);          
            testCase.verifyGreaterThan(p,0);  
        end
        
         function check_psnr(testCase)  % check if the error of calculated PSNR is small than 5%
             import matlab.unittest.constraints.IsEqualTo;
             import matlab.unittest.constraints.AbsoluteTolerance;
             
             challenge; %% Call the function
             p_cal = p;  % calculated PSNR
             p_opt = psnr(D,GT_u,max(max(D(:),max(GT(:))))); % PSNR from image processing toolbox
             %testCase.forInteractiveUse.verifyThat(double(p_cal), IsEqualTo(p_opt, 'within', AbsoluteTolerance(0.05)));
             testCase.verifyEqual(p_cal,p_opt,'RelTol',0.05);
             % check if the calculated PSNR error small than 5%
        end
    end
end

    function toolboxes_in_use = check_toolboxes(f_name)
    [~,pList] = matlab.codetools.requiredFilesAndProducts(f_name);
    if (size({pList.Name}', 1)>1)
        toolboxes_in_use = ture;
    else
        toolboxes_in_use = false;
    end
    end

    
