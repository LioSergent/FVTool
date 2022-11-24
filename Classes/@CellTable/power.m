function ct = power(p,q)
    ct = CellTable.from_farray(p.domain, p.fA.^q, p.field_struct);
end
