
function check_empty(value)
import matlab.unittest.constraints.IsEmpty;
testCase = matlab.unittest.TestCase.forInteractiveUse;
verifyNotEmpty(testCase, value);
end
