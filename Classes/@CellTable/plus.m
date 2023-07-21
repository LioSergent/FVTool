function r = plus(p,q)
    if isa(p, 'CellTable')&&isa(q, 'CellTable')
        r = CellTable.from_farray(p.domain, p.fA + q.fA, p.field_struct);
    elseif isa(p, 'CellTable')&&isa(q, 'CellVariable')
        r = CellTable.from_farray(p.domain, p.fA + reshape(q.fval, [1 1 p.domain.dims(1)+2]), ...
        p.field_struct);
    elseif isa(p, 'CellVariable')&&isa(q, 'CellTable')
        r = CellTable.from_array(q.domain, q.fA + reshape(p.fval, [1 1 q.domain.dims(1)+2]), ...
        q.field_struct);
    elseif isa(p, 'CellTable') && isa(q, 'CalculableStruct')
        arr_from_v = repmat(reshape(q.V, [1 numel(q.fields)]), [1 1 p.domain.dims(1)+2]);
        r = CellTable.from_farray(p.domain, p.fA + arr_from_v, p.field_struct);
    elseif isa(q, 'CellTable') && isa(p, 'CalculableStruct')
        arr_from_v = repmat(reshape(p.V, [1 numel(p.fields)]), [1 1 q.domain.dims(1)+2]);
        r = CellTable.from_farray(q.domain, q.fA + arr_from_v, q.field_struct);
    elseif isa(p, 'CellTable')
        r = CellTable.from_farray(p.domain, p.fA + q, p.field_struct);
    else 
        r = CellTable.from_farray(q.domain, q.fA + p, q.field_struct);
    end
end
