function RHS = internalExplicitDiffusion(D, var_motrice)
    m = var_motrice.domain;
    grads = gradientTerm(var_motrice);
    dz = m.cellsize.x(2:end-1);
    Jw = [0; D.xvalue(2:end-1) .* grads.xvalue(2:end-1)];
    Je = [D.xvalue(2:end-1) .* grads.xvalue(2:end-1); 0];
    RHS = (Jw - Je)./ dz;
    RHS = [0; RHS; 0];
end
