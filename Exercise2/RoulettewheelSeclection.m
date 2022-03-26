function i = RoulettewheelSeclection(p)

    % p = p/sum(p); dangerous if sum(p) = 0
    
    r = rand*sum(p);
    c = cumsum(p);
    i = find(r <=c, 1, 'first');

end