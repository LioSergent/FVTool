function r = rdivide(p,q)
    if isa(p, 'CalculableStruct')&&isa(q, 'CalculableStruct')
        r = CalculableStruct(p.V ./ q.V, p.field_struct);
    elseif isa(p, 'CalculableStruct')&&isa(q, 'CellVariable')
        arr_from_cs = repmat(reshape(p.V, [1 numel(p.fields)]), [1 1 q.domain.dims(1)+2]);
        arr_from_cv = reshape(q.fval, [1 1 q.domain.dims(1)+2]);
        r = CellTable.from_farray(q.domain, arr_from_cs ./ arr_from_cv, p.field_struct);
    elseif isa(p, 'CellVariable')&&isa(q, 'CalculableStruct')
        arr_from_cs = repmat(reshape(q.V, [1 numel(q.fields)]), [1 1 p.domain.dims(1)+2]);
        arr_from_cv = reshape(p.fval, [1 1 p.domain.dims(1)+2]);
        r = CellTable.from_farray(p.domain, arr_from_cv ./ arr_from_cs, q.field_struct);
    elseif isa(p, 'CalculableStruct')
        r = CalculableStruct(p.V ./ q, p.field_struct);
    else 
        r = CalculableStruct(p ./ q.V, q.field_struct);
    end
end
