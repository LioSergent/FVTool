function x = solveLinear(M, RHS, guess, solver_opts)
    switch solver_opts.solver_name
        case 'mldivide'
            x = M\RHS;
        case 'Gauss-Seidel'
            x = gauss_seidel(M, RHS, guess.value, solver_opts);
        case 'minsquarecholesky'
            x = minSquareCholesky(M, RHS);
        case 'tdma'
            x = tdma(M, RHS);
        otherwise
            x = M\RHS;
    end
end
