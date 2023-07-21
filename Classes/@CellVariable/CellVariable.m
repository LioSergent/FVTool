classdef CellVariable
    %CellVariable class 

    properties
        domain
        fval % cells + boundaries
    end

    properties (Dependent)
        ival % Inner values (just the cells)
        value % Inner values + ghost cells
        left
        right
        ghost_left
        ghost_right
    end

    methods
        function cv = CellVariable(meshVar, cellval, is_fval)
            cv.domain = meshVar;
            if nargin<3
                cv.value = cellval; % does not do any dim check!
            elseif is_fval 
                cv.fval = cellval;
            end
        end

        function self = apply_BC(self, BC)
            self.value = cellBoundary(self.ival, BC);
        end

        function r = get.ival(self)
            % Inner value
            r = self.fval(2:end-1);
        end

        function self = set.ival(self,val)
            % Inner value
            self.fval(2:end-1) = val;
        end

        function r = get.left(self)
            % Value at left boundary
            r = self.fval(1);
        end

        function r = get.right(self)
            % Value at left boundary
            r = self.fval(end);
        end

        function r = get.ghost_left(self)
            r = 2 * self.fval(1) - self.fval(2);
        end

        function r = get.ghost_right(self)
            r = 2 * self.fval(end) - self.fval(end-1);
        end

        function r = get.value(self)
            r = [self.ghost_left; self.ival; self.ghost_right];
        end

        function self = set.value(self, val)
            lb = (val(1) + val(2))/2;
            rb = (val(end-1) + val(end))/2;
            self.fval = [lb; val(2:end-1); rb];
        end

        function self = set.left(self, val)
            self.fval(1) = val;
        end

        function self = set.right(self, val)
            self.fval(end) = val;
        end

    end

    methods (Static)
        function cv = fromFval(domain, fval)
            cv = CellVariable(domain, fval, true);
        end
    end

end
