function M = contractedDiffusion(D, l_1)
% extract data from the mesh structure
Nx = D.domain.dims(1);
DZ = D.domain.cellsize.x;
dz = 0.5*(DZ(1:end-1)+DZ(2:end));

D_in = D.xvalue(2:end-1);
a_W = [0; D_in(1:end) .* l_1.ival(1:end-1) ./ (dz(2:end-1) .* DZ(3:end-1)); 0;0];
a_E = [0;0; D_in(1:end) .* l_1.ival(2:end) ./ (dz(2:end-1) .* DZ(2:end-2));0];
a_P = [0; -D_in(1) * l_1.ival(1) / (dz(2) * DZ(2)); ...
    -D_in(1:end-1) .* l_1.ival(2:end-1) ./ (dz(2:end-2) .* DZ(3:end-2)) - ...
    D_in(2:end) .* l_1.ival(2:end-1) ./ (dz(3:end-1) .* DZ(3:end-2)); ...
    -D_in(end) .* l_1.ival(end) ./ (dz(end-1) .* DZ(end-1)); 0];

M = spdiags([a_W a_P a_E], -1:1, Nx+2, Nx+2);
end
