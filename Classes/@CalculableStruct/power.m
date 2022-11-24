function cs = power(p,q)
    cs = CalculableStruct.from_vec(p.V.^q, p.field_struct);
end
