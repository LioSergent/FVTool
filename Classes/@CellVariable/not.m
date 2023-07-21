function r = not(p)
%UMINUS: this function applies a unary minus to the x, y, and z fvals of the structures that I use in
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

r=p;
r.fval = ~p.fval;
