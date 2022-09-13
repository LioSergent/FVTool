function r = uminus(p)
    r = CellTable.from_array(p.domain, -p.A, p.field_struct);
end
    
