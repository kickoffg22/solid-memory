classdef test_cong < matlab.unittest.TestCase
    properties
   
    end
    
    methods(Test)
        function testToolboxes(testCase)
            testCase.verifyFalse(check_toolboxes('challenge.m'));
            testCase.verifyFalse(check_toolboxes('disparity_map.m'));
            testCase.verifyFalse(check_toolboxes('verify_dmap.m'));
        end
        
        function testVariables(testCase)
            challenge;       %% Call the function  
            testCase.verifyNotEmpty(group_number);
            testCase.verifyNotEmpty(members);
            testCase.verifyNotEmpty(mail);
            testCase.verifyGreaterThan(elapsed_time,0);
            testCase.verifyGreaterThan(D,0);
            testCase.verifyGreaterThan(R,0);
            testCase.verifyGreaterThan(T,0);
            testCase.verifyGreaterThan(p,0);  
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

    