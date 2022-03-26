function out = RunGA(problem, params)

    % Problem
    CostFunc = problem.CostFunc;
    [nVar, ~] = size(params.b);

    % Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    
    pC = params.pC; % percentage of offspring to parents.. usually 1 (nC = nPop)
    nC = round(pC*nPop/2)*2; % number of offspring (we need it to be an even number)
    mu = params.mu; % mutation percentage

    % Template for Empty Individuals
    empty_individual.Position = [];
    empty_individual.Cost = []; %objective value / cost value

    % Best solution ever found
    bestsol.Cost = -inf; %initialize with worst cost.

    % Initialization
    pop = repmat(empty_individual, nPop, 1);

    for i = 1:nPop

        % Generate random solution
        pop(i).Position = randi([-1024,1024], 1, nVar)';

        % Evaluate solution
        pop(i).Cost = CostFunc(params.A, params.b, params.c, pop(i).Position);

        % Compare with best solution ever found
        if pop(i).Cost > bestsol.Cost
            bestsol = pop(i);
        end
    end

    % Best Cost of iterations
    bestcost = nan(MaxIt, 1); %best to initialize unknowns with nan

    % Main Loop

    for it = 1:MaxIt

        % Selection Probabilities 
        c = [pop.Cost];
        avgc = mean(c);
        if avgc ~=0
            c = c/avgc;
        end
        probs = exp(-beta*c);

        % Initialize offsprings population
        popc = repmat(empty_individual, nC/2, 2); % divide into 2 to simulate crossover

        % Crossover
        for k = 1:nC/2 % the number of crossovers we will perform
            % create 2 individuals (offspring) at every iteration of the
            % loop

            % Select paretns
            p1 = pop(RoulettewheelSeclection(probs));
            p2 = pop(RoulettewheelSeclection(probs));
            %p1 = RoulettewheelSeclection(pop);
            %p2 = RoulettewheelSeclection(pop);

            % Perform Crossover
            [popc(k, 1).Position, popc(k, 2).Position] = ...
                SinglePointCrossover(p1.Position, p2.Position);

        end

        % Convert popc to single-column matrix
        popc = popc(:); % : converts any matrix to a single-column matrix
        
        % Mutation
        for l = 1:nC

            % Perform Muattion
            popc(l).Position = Mutate(popc(l).Position, mu);

            % Evaluate
            popc(l).Cost = CostFunc(params.A, params.b, params.c, (popc(l).Position));
    
            % Compare with best solution ever found
            if popc(l).Cost > bestsol.Cost
                bestsol = popc(l);
            end

        end

        % Merge Populations
        pop = [pop; popc];

        % Sort population
        pop = SortPopulation(pop);

        % Remove Extra Individuals
        pop = pop(1: nPop);

        % Update best cost of iteration
        bestcost(it) = bestsol.Cost;

        % Display Iteration information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);

    end

    % Results
    out.pop = pop;
    out.bestsol = bestsol;
    out.bestcost = bestcost;
end
