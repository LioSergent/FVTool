function r = times(p,q)
    if isa(p, 'CellTable')&&isa(q, 'CellTable')
        r = CellTable.from_array(p.domain, p.A .* q.A, p.field_struct);
        r.left = p.left .* q.left;
        r.right = p.right .* q.right;
    elseif isa(p, 'CellTable')&&isa(q, 'CellVariable')
        r = CellTable.from_array(p.domain, p.A .* reshape(q.value, [1 1 p.domain.dims(1)+2]), ...
        p.field_struct);
        r.left = p.left .* q.left;
        r.right = p.right .* q.right;
    elseif isa(p, 'CellVariable')&&isa(q, 'CellTable')
        r = CellTable.from_array(q.domain, q.A .* reshape(p.value, [1 1 q.domain.dims(1)+2]), ...
        q.field_struct);
        r.left = p.left .* q.left;
        r.right = p.right .* q.right;
    elseif isa(p, 'CellTable') && isa(q, 'CalculableStruct')
        arr_from_v = repmat(reshape(q.V, [1 numel(q.fields)]), [1 1 p.domain.dims(1)+2]);
        r = CellTable.from_array(p.domain, p.A .* arr_from_v, p.field_struct);
        r.left = p.left .* q;
        r.right = p.right .* q;
    elseif isa(p, 'CalculableStruct') && isa(q, 'CellTable')
        r = q .* p;
    elseif isa(p, 'CellTable')
        r = CellTable.from_array(p.domain, p.A .* q, p.field_struct);
    else
        r = CellTable.from_array(q.domain, q.A .* p, q.field_struct);
    end
end
