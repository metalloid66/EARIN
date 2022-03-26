function outputArg1 = gradDesOptVector(c, b, A, startX, stop, stepsize, timelimit, iterations)
[bRows, ~] = size(b);

if(startX(1) == true)
    nextguess = (startX(2) - startX(3)).*rand(bRows,1) + startX(3);
else 
    nextguess = zeros(bRows,1);
    for i = 1:bRows
        nextguess(i) = startX(i+1);
    end
end

if(stop(1) == true)
    stopValue = stop(2);
end

if(timelimit(1) == true) 
    time0 = tic;
end

gx = @(x) c + (transpose(b)*x) + (transpose(x)*A*x);
gradf = @(x) b +  A*x +  A.'*x;


disp(timelimit(2))
for i=1:iterations
 nextguess = nextguess - stepsize*gradf(nextguess);
    if (exist('stopValue','var') && gx(nextguess) > stopValue)
        disp('g(x) Stop value has been reached .. Stopping the calcuation')
        break
    elseif  exist('time0','var') && toc(time0)>timelimit(2)
        disp('Computation time limit has been reached.. Stopping the calcuation')
        break
    end

end
outputArg1 = nextguess;

