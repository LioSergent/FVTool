classdef (InferiorClasses = {?CellVariable, ?CalculableStruct}) CellTable < dynamicprops
    % Data structure to hold several labeled 1D CellVariables that one may want to treat in the
    % same way and make some algebraic calculations on. Primary use case is concentration of
    % several species.
    %
    % Implementation is basically a 3d array where the 3rd dimension is the x dimension of the
    % CellVariables, which lets 2 dimensions for 2D variables, such as binary diffusion
    % coeffecients.
    %
    % Automatic property association, but it is expensive ! 

    properties
        A  % inner array
        field_struct  % ordered list
        domain % mesh of the CellVariables
    end

    properties (Dependent)
        fields
        nxs
        nx
        nf
        T
        fA
        iA
        fT
        left
        right
    end

    methods
        function ct = CellTable(domain, A, field_struct)
            % Assumes first and last elements in 3rd dim are ghost cells
            ct.domain = domain;
            ct.A = A;
            ct.field_struct = field_struct;
        end

        function add_prop(self, name)
            if ~isprop(self, name)
                prop = addprop(self, name);
                prop.Dependent = true;
                prop.GetMethod = @(obj)CellTable.getDynamicProp(obj,name);
                prop.SetMethod = @(obj,val)CellTable.setDynamicProp(obj,name,val);
            end
        end

        function equip_prop(self)
            for idx = 1:numel(self.fields)
                field = self.fields(idx);
                self.add_prop(field);
            end
        end

        function add_field(self, name, cell_variable)
            old_arr = self.A;
            old_field_struct = self.field_struct;
            new_fields = sort([self.fields; name]);
            self.field_struct = struct();
            Nxs = self.domain.dims(1) + 2;
            self.A = zeros(1, numel(new_fields), Nxs); 
            for idx = 1:numel(new_fields)
                field = new_fields(idx);
                self.field_struct.(field) = idx;
                if field == name
                    self.A(1, idx, :) = reshape(cell_variable.value, [1 1 Nxs]); 
                else
                    self.A(1, idx, :) = old_arr(1, old_field_struct.(field), :);
                end
            end
        end

        function f = get.fields(self)
            f = string(fieldnames(self.field_struct));
        end

        function tab = get.T(self)
            % The array put into a table
            tab = table();
            for idx = 1:self.nf
                field = self.fields(idx);
                tab.(field) = reshape(self.A(1, idx, :), [self.nxs 1]);
            end
        end

        function tab = get.fT(self)
            % The array put into a table, without ghost cells but with values at the boundary
            tab = table();
            for idx = 1:self.nf
                field = self.fields(idx);
                tab.(field) = reshape(self.fA(1, idx, :), [self.nxs 1]);
            end
        end

        function cs = get.left(self)
            cs = CalculableStruct.from_vec(reshape(self.A(1,:,1)/2 + self.A(1,:,2)/2, [self.nf 1]),...
                self.field_struct);
        end

        function cs = first_cell(self)
            cs = CalculableStruct.from_vec(reshape(self.A(1,:,2), [self.nf 1]),...
                self.field_struct);
        end

        function cs = get.right(self)
            cs = CalculableStruct.from_vec(...
                reshape(self.A(1,:,end)/2 + self.A(1,:,end-1)/2, [self.nf, 1]), self.field_struct);
        end

        function cs = last_cell(self)
            cs = CalculableStruct.from_vec(reshape(self.A(1,:,end-1), [self.nf 1]),...
                self.field_struct);
        end

        function set.left(self, cs)
            self.A(1,:,1) = 2 * cs.V' - self.A(1,:,2);
        end

        function set.right(self, cs)
            self.A(1,:,end) = 2 * cs.V' - self.A(1,:,end-1);
        end

        function new_struct = ival_struct(self)
            new_struct = struct();
            for idx = 1:self.nf
                field = self.fields(idx);
                new_struct.(field) = reshape(self.A(1, idx, 2:end-1), [self.nx 1]);
            end
        end

        function tab = tab_to_repr(self)
            tab = self.fT;
            row_labels = strings(self.nxs, 1);
            cell_positions = self.domain.fcellcenters();
            row_labels(1) = sprintf("L %0.3g", cell_positions(1));
            for idx = 2:numel(row_labels)-1
                cell_number = idx - 1;
                cell_position = cell_positions(idx);
                row_labels(idx) = sprintf("C%d %0.3g", cell_number, cell_position);
            end
            row_labels(end) = sprintf("R %0.3g", cell_positions(end));
            tab.Properties.RowNames = row_labels;
        end

        function repr(self)
            disp(self.tab_to_repr());
        end

        function res = sum(self)
            % Does horizontal sum
            v = reshape(sum(self.A, 2), [self.domain.dims(1)+2 1]);
            res = CellVariable(self.domain, v);
        end

        function res = cell_sum(self)
            % Sums on the cells
            % Outputs a Calculable struct
            res = CalculableStruct.from_vec(sum(self.iA, 3), self.field_struct);
        end

        function res = icell_sum(self)
            % Sums on the internal cells
            % Outputs a Calculable struct
            res = CalculableStruct.from_vec(sum(self.iA(:,:, 2:end-1), 3), self.field_struct);
        end

        function cv = get_cv(self, name)
            vec = reshape(self.A(1, self.field_struct.(name), :), [self.nxs 1]);
            cv = CellVariable(self.domain, vec);
        end

        function patch_cv(self, name, cv)
            self.A(1, self.field_struct.(name), :) = reshape(cv.value, [1 1 self.nxs]);
        end

        function patch_vec(self, name, vec)
            % Patches the values for one specific attribute
            self.A(1, self.field_struct.(name), :) = reshape(vec, [1 1 self.nxs]);
        end

        function patch_ivec(self, name, vec)
            % Patches the values for one specific attribute
            self.A(1, self.field_struct.(name), 2:end-1) = reshape(vec, [1 1 self.nx]);
        end

        function patch_ct(self, ct)
            self.A = ct.A;
        end

        function n = get.nxs(self)
            n = self.domain.dims(1) + 2;
        end

        function n = get.nx(self)
            n = self.domain.dims(1);
        end

        function n = get.nf(self)
            n = numel(self.fields);
        end

        function new_obj = copy(obj)
            new_obj = CellTable.from_array(obj.domain, obj.A, obj.field_struct);
        end

        function col = to_col_by_var(self)
            % Flattens into one long column, only the inner values
            ivalA = permute(self.A(:,:, 2:end-1), [3 2 1]);
            col = reshape(ivalA, [self.nx * self.nf 1]);
        end

        function newA = get.fA(self)
            % returns a multidimensional array with the inner values and the values at the
            % boundaries
            B = zeros(size(self.A));
            B(:,:,2:end-1) = self.A(:,:,2:end-1);
            B(:,:,1) = self.A(:,:,2);
            B(:,:,end) = self.A(:,:,end-1);
            newA = (self.A + B)/2;
        end

        function newA = get.iA(self)
            % returns a multidimensional array with just the inner values             
            newA = self.A(:,:,2:end-1);
        end

        function set.fA(self, arr)
            self.A = arr;
            % The column has the left and right values, we need the ghost cells values here
            self.A(:,:,1) = 2*arr(:,:,1) - arr(:,:,2);
            self.A(:,:,end) = 2*arr(:,:,end) - arr(:,:,end-1);
        end

        function col = to_col_by_cell(self)
            fvalA = permute(self.fA, [2 3 1]);
            col = reshape(fvalA, [self.nxs * self.nf 1]);
        end

        function normalize(self)
            self.fA = self.fA ./ sum(self.fA, 2);
        end

    end

    methods (Static)

        function ct = from_table(domain, inner_table)
            arguments
                domain MeshStructure
                inner_table table = table()
            end
            fields = string(sort(inner_table.Properties.VariableNames))';
            Nxs = domain.dims(1) + 2;
            A = zeros(1, numel(fields), Nxs); 
            field_struct = struct();

            for idx = 1:numel(fields)
                field = fields(idx);
                field_struct.(field) = idx;
                A(1, idx, :) = reshape(inner_table.(field).value, [1 1 Nxs]); 
            end

            ct = CellTable(domain, A, field_struct);

        end
        function ct = from_array(domain, arr, field_struct)
            % For backwards compatibility
            ct = CellTable(domain, arr, field_struct);
            if isscalar(arr)
                ct.A = arr * ones([1 numel(fieldnames(field_struct)) domain.dims(1) + 2]);
            end
        end

        function ct = from_farray(domain, arr, field_struct)
            % Assumes first and last elements in 3rd dimension are boundary values
            A = arr;
            % The column has the left and right values, we need the ghost cells values here
            A(:,:,1) = 2*arr(:,:,1) - arr(:,:,2);
            A(:,:,end) = 2*arr(:,:,end) - arr(:,:,end-1);
            ct = CellTable.from_array(domain, A, field_struct);
        end

        function ct = from_col_by_cell(domain, col, field_struct)
            nv = numel(fieldnames(field_struct));
            nxs = numel(col) / nv;
            A_fval = reshape(col', [1 nv nxs]);
            ct = CellTable.from_farray(domain, A_fval, field_struct);
        end

        function f = safe_fields(p)
            if class(p) == "struct"
                f = sort(string(fieldnames(p)))';
            else
                f = p.fields;
            end
        end

        function fieldsCompatible(p,q)
            a = CellTable.safe_fields(p);
            b = CellTable.safe_fields(q);
            if (numel(setdiff(a,b)) > 0 || numel(setdiff(b,a)) > 0)
                throw(MException("CellTable:FieldsNotCompatible", "Operations need fields to be the same"));
            end
        end

        function val = getDynamicProp(obj,name)
          idx = obj.field_struct.(name);
          val = createCellVariable(obj.domain, reshape(obj.A(1, idx, 2:end-1), [obj.domain.dims(1) 1]));
        end

        function setDynamicProp(obj,name,val)
            idx = obj.field_struct.(name);
            if class(val) == "CellVariable"
                Nxs = val.domain.dims(1) + 2;
                obj.A(1,idx,:) = reshape(val.value, [1 1 Nxs]);
            else 
                Nxs = numel(val);
                obj.A(1,idx,:) = reshape(val, [1 1 Nxs]);
            end
        end

        function ct = from_calculable_struct(domain, cs)
            nv = numel(cs.fields);
            nxs = domain.dims(1) + 2;
            A = ones(1, nv, nxs);
            for idx = 1:numel(cs.fields) 
                A(1, idx, :) = cs.V(idx);
            end
            ct = CellTable(domain, A, cs.field_struct);

        end

    end

end

