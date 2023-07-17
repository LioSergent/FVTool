function [M, RHS] = transientTermTD(phi_old, dt, alpha, concentration)
% function [M, RHS] = transientTerm(MeshStructure, h, dt, phi)
% Matrix of coefficients and the RHS vector for a transient term
% alfa \partial_t \phi
% Uses a contraction to take into account concentration effects
% concentration must be a CellVariable of old volume on new volume for each cell
%
%
% SYNOPSIS:
%   [M, RHS] = transientTerm(phi_old, dt)
%   [M, RHS] = transientTerm(phi_old, dt, alfa)
%
% PARAMETERS:
%   phi_old: Cell Variable
%   dt:      time step
%   alfa:    Cell Variable
% RETURNS:
%
%
% EXAMPLE:
%
% SEE ALSO:
%
%
%
%

Nx = phi_old.domain.dims(1);
G = 1:Nx+2;
alfa = alpha.ival;
concentration = concentration.ival;

row_index = reshape(G(2:Nx+1),Nx,1); % main diagonal (only internal cells)
AP_diag = reshape(alfa/dt,Nx,1);
M = sparse(row_index, row_index, AP_diag, Nx+2, Nx+2);

% define the RHS Vector
RHS = zeros(Nx+2,1);

% assign the values of the RHS vector
RHS(row_index) = reshape(alfa .* concentration .* phi_old.value(2:Nx+1)/dt,Nx,1);
end
