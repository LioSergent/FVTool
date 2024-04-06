function r = rdivide(p,q)
    stc = [class(p), '-', class(q)];
    switch stc 
        case 'CellTable-CellTable'
            r = CellTable.from_farray(p.domain, p.fA ./ q.fA, p.field_struct);
        case 'CellTable-CellVariable'
            r = CellTable.from_farray(p.domain, p.fA ./ permute(q.fval, [3 2 1]), p.field_struct);
        case 'CellVariable-CellTable'
            r = CellTable.from_array(q.domain, q.fA ./ permute(p.fval, [3 2 1], q.field_struct));
        case 'CellTable-CalculableStruct'
            r = CellTable.from_farray(p.domain, p.fA ./ q.V', p.field_struct);
        case 'CalculableStruct-CellTable'
            r = CellTable.from_farray(q.domain, p.V' ./ q.fA, p.field_struct);
        case 'CellTable-double'
            r = CellTable.from_farray(p.domain, p.fA ./ q, p.field_struct);
        otherwise 
            r = CellTable.from_farray(q.domain, p ./ q.fA, q.field_struct);
    end
end
