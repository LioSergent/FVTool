function r = sqrt(p)
    r = p;
    r.ival = sqrt(p.ival);
    r.left = sqrt(p.left);
    r.right = sqrt(p.right);
end
