function r = log(p)
    r = p;
    r.ival = log(p.ival);
    r.left = log(p.left);
    r.right = log(p.right);
end
