classdef FaceVariable
% FaceVariable class
    properties
        domain
        xvalue
        yvalue
        zvalue
    end

    properties (Dependent)
        right
        left
    end

    methods
        function fv = FaceVariable(meshVar, facevalX, facevalY, facevalZ)
            if nargin>0
                fv.domain = meshVar;
                fv.xvalue = facevalX;
                fv.yvalue = facevalY;
                fv.zvalue = facevalZ;
            end
        end

        function val = get.right(self)
            val = self.xvalue(end);
        end

        function val = get.left(self)
            val = self.xvalue(1);
        end

    end

end
