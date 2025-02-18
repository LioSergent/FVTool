function r = rdivide(p,q)
%RDIVIDE this function divides the x, y, and z values of the structures that I use in
% the FVtool.
%
% SYNOPSIS:
%
%
% PARAMETERS:
%
%
% RETURNS:
%
%
% EXAMPLE:
%
% SEE ALSO:
%

% Copyright (c) 2012-2016 Ali Akbar Eftekhari
% See the license file

if (isa(p, 'CellVariable')&&isa(q, 'CellVariable'))
    r=p;
    r.ival = p.ival ./ q.ival;
    r.left = p.left ./ q.left;
    r.right = p.right ./ q.right;
elseif isa(p, 'CellVariable')
    r=p;
    r.ival = p.ival./q;
    r.left = p.left ./ q;
    r.right = p.right ./ q;
else
    r=q;
    r.ival = p./q.ival;
    r.left = p./q.left;
    r.right = p./q.right;
end
