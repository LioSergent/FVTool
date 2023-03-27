function phi = solvePDE(MS, M, RHS, guess, solver_opts)
% SOLVEPDE solves the linear system M x \phi = RHS and returns the value of
% \phi reshaped based on the structure of the MeshStructure variable. The
% default solver is the matlab '\' linear solver and will be in most cases the
% best solver to use as it adapts to the type of matrix. In some cases others
% solvers can be explicitly used to inspect/debug numerical difficulties. 
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

% Written by Ali A. Eftekhari
% See the license file
%

arguments
    MS MeshStructure
    M double
    RHS double
    guess CellVariable = createCellVariable(MS, 1)
    solver_opts LSolverOpts = LSolverOpts()
end

x = solveLinear(M, RHS, guess, solver_opts);

n = MS.dimension;
N = MS.dims;

if (n>=2)
    phival = reshape(x, N+2);
else
    phival = reshape(x, [N(1)+2 1]);
end

phi=CellVariable(MS, phival);

end
