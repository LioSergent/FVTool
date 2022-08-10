classdef CellVariableTest < matlab.unittest.TestCase
    properties
        x
        m
        cvar
    end

    methods(TestMethodSetup)

        function setup(testCase)
            Nx = 4;
            L = 1;
            ms = createMesh1D(Nx, L);
            testCase.m = ms;
            testCase.cvar = CellVariable(ms, (1:4)');
        end
    end

    methods 
        function verifySame(testCase, a, b)
            testCase.verifyEqual(a,b, 'RelTol', 1e-6);
        end
    end

    methods(Test)
        function test_value(testCase)
            testCase.verifySame(testCase.cvar.value(2), 2);
            testCase.cvar.value = (4:7)';
            testCase.verifySame(testCase.cvar.value(2), 5);
        end
    end

end

