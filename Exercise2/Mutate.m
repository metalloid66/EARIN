function y = Mutate(x, mu)

    % Binary conversion 
    binX = dec2bin(x)-'0';
    [rows, cols] = size(binX);

    % Mutation
    for i=1:rows*cols
        if (rand() <= mu)
            binX(i) = 1 - binX(i);
        end
    end

    out = [];
    % Decimal conversion
    for i = 1:rows
        out(i) = BinToDec(num2str(binX(i,:)));
    end
    y = out';
end

    %flag = (rand(size(x)) < mu); % has 1s as elements with probability of mu

    %y = x;
    %y(flag) = 1 - x(flag); %y(flag) called logical indexing .. wherever the flag has true value
                           % then it will be = 1 - x(flag) in the same
                           % position