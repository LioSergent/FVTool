function r = plus(p,q)
    if isa(p, 'CalculableStruct')&&isa(q, 'CalculableStruct')
        r = CalculableStruct.from_vec(p.V + q.V, p.field_struct);
    elseif isa(p, 'CalculableStruct')
        r = CalculableStruct(from_vec(p.V + q, p.field_struct));
    else 
        r = CalculableStruct(from_vec(q.V + p, q.field_struct));
    end
end
