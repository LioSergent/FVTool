classdef CellVariable
    %CellVariable class 

    properties
        domain
        value
    end

    methods
        function cv = CellVariable(meshVar, cellval)
            if nargin>0
                cv.domain = meshVar;
                if size(cellval) == meshVar.dims
                    cv.value = cellval;
                elseif isscalar(cellval)
                    cv.value = cellval .* ones(meshVar.dims);
                else 
                    error("Wrong value for CellVariable");
                end
            end
        end
    end
end
