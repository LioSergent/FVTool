function ct = power(p,q)
    ct = CellTable.from_array(p.domain, p.A.^q, p.field_struct);
end
