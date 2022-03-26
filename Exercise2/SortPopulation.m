function pop = SortPopulation(pop)
        
    [~, so] = sort([pop.Cost],"descend");
    pop = pop(so);

end