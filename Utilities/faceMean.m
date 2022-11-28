function cv = faceMean(fv)
    inner_arr = (fv.xvalue(1:end-1) + fv.xvalue(2:end)) / 2;
    left_val = fv.xvalue(1);
    right_val = fv.xvalue(end);
    cv = CellVariable.fromFval(fv.domain,[left_val; inner_arr; right_val]);
end
