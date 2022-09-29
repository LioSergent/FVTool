classdef CellVariable
    %CellVariable class 

    properties
        domain
        value % Inner values + ghost cells
    end

    properties (Dependent)
        ival % Inner values (just the cells)
        fval % Inner values + left and right
        left
        right
    end

    methods
        function cv = CellVariable(meshVar, cellval)
            if nargin>0
                cv.domain = meshVar;
                cv.value = cellval; % does not do any dim check!
            end
        end

        function self = apply_BC(self, BC)
            self.value = cellBoundary(self.ival, BC);
        end

        function r = get.ival(self)
            % Inner value
            r = self.value(2:end-1);
        end

        function self = set.ival(self,val)
            % Inner value
            self.value(2:end-1) = val;
        end

        function r = get.fval(self)
            r = [self.left; self.ival; self.right];
        end

        function r = get.left(self)
            % Value at left boundary
            r = (self.value(1) + self.value(2))/2;
        end

        function r = get.right(self)
            % Value at left boundary
            r = (self.value(end) + self.value(end-1))/2;
        end
    end

    methods (Static)
        function cv = fromFval(domain, fval)
            left_ghost = 2 * fval(1) - fval(2); 
            right_ghost = 2 * fval(end) - fval(end-1);
            cv = CellVariable(domain, [left_ghost; fval(2:end-1); right_ghost]);
        end
    end

end
