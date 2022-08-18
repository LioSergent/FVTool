classdef MeshStructure
    %MeshStructure class
    % contains information about the domain and the mesh size

    properties
        dimension
        dims
        cellsize
        cellcenters
        facecenters
        corners
        edges
    end

    methods
        function meshVar = MeshStructure(dimension, dims, cellsize, ...
          cellcenters, facecenters, corners, edges)
            if nargin>0
                meshVar.dimension = dimension;
                meshVar.dims = dims;
                meshVar.cellsize = cellsize;
                meshVar.cellcenters = cellcenters;
                meshVar.facecenters = facecenters;
                meshVar.corners= corners;
                meshVar.edges= edges;
            end
        end

        function n_cell = x2cell_number(self, x)
            % Only works 1D
            if x < 0
                error("Mesh is purely positive")
            end
            path = 0;
            idx = 1;
            while path < x
                % Errors if x is too big
                path = path + self.cellsize(idx);
                idx = idx + 1;
            end
            n_cell = idx - 1;
        end
    end
end
