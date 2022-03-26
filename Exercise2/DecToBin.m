function [pa1, pa2] = DecToBin(Dec)

m = 1;
parents = dec2bin(Dec);
[rows, cols] = size(parents);
parent1 = repmat(' ', rows/2, cols);
parent2 = repmat(' ', rows/2, cols);

% Seperate the two parents
    for i = 1:rows/2
        for j = 1:cols
            parent1(i,j) = parents(i,j);
        end
    end

    for k = (rows/2 + 1):rows
        for l = 1:cols
            parent2(m,l) = parents(k,l);
        end
        m = m + 1;
    end
  pa1 = parent1;
  pa2 = parent2;
 
end 