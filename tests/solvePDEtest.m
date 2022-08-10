classdef solvePDEtest < matlab.unittest.TestCase

    methods(Test)

        function test_no_guess(testCase)
            M = [1 2; 3 4];
            RHS = [2; 2];
            m = createMesh1D(2, 1);
            cv = solvePDE(m, M, RHS); 
            testCase.verifyEqual(cv.value, [-2; 2]);
        end
    end

end

