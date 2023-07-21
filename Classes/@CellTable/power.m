function ct = power(p,q)
    ct = CellTable(p.domain, p.fA.^q, p.field_struct);
end
