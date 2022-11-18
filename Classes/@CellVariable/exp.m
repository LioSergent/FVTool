function r = exp(p)
    r = p;
    r.ival = exp(p.ival);
    r.left = exp(p.left);
    r.right = exp(p.right);
end
