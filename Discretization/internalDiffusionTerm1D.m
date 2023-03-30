function M = internalDiffusionTerm1D(D)
% This function uses the central difference scheme to discretize a 1D
% diffusion term in the form \grad . (D \grad \phi) where u is a face vactor but where the boundary
% are not diffusing (limits of the domain)
% It also returns the x and y parts of the matrix of coefficient.
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

% extract data from the mesh structure
Nx = D.domain.dims(1);
G = (1:Nx+2)';
DX = D.domain.cellsize.x;
dx = 0.5*(DX(1:end-1)+DX(2:end));

% define the vectors to store the sparse matrix data
iix = zeros(3*(Nx+2),1);
jjx = zeros(3*(Nx+2),1);
sx = zeros(3*(Nx+2),1);

Dx = D.xvalue;

% reassign the east, west, north, and south velocity vectors for the
% code readability
De = Dx(2:Nx+1)./(dx(2:Nx+1).*DX(2:Nx+1));
Dw = Dx(1:Nx)./(dx(1:Nx).*DX(2:Nx+1));

% calculate the coefficients for the internal cells
AE = [De(1:end-1);0];
AW = [0; Dw(2:end)];
APx = -(AE+AW);

% build the sparse matrix based on the numbering system
rowx_index = reshape(G(2:Nx+1),Nx,1); % main diagonal x
iix(1:3*Nx) = repmat(rowx_index,3,1);
jjx(1:3*Nx) = [reshape(G(1:Nx),Nx,1); reshape(G(2:Nx+1),Nx,1); reshape(G(3:Nx+2),Nx,1)];
sx(1:3*Nx) = [AW; APx; AE];

% build the sparse matrix
kx = 3*Nx;
M = sparse(iix(1:kx), jjx(1:kx), sx(1:kx), Nx+2, Nx+2);
