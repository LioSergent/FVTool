function r = times(p,q)
%TIMES this function multiplies the x, y, and z values of the structures that I use in
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
    r.fval = p.fval .* q.fval;
elseif isa(p, 'CellVariable')
    r=p;
    r.fval = p.fval.*q;
else
    r=q;
    r.fval = p.*q.fval;
end
