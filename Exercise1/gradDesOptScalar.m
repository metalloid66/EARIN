function outputArg1 = gradDesOptScalar(a, b, c, d, startX, stop, stepsize, timelimit, iterations)

if(startX(1) == true)
    nextguess = (startX(2) - startX(3)).*rand() + startX(3);
else 
    nextguess = 1;
end

if(stop(1) == true)
    stopValue = stop(2);
end

if(timelimit(1) == true) 
    time0 = tic;
end


f = @(x) a*x.^3 + b*x.^2 + c*x + d;
gradf = @(x) [3*a*x.^2 + 2*b*x + c];

 for i=1:iterations
     nextguess = nextguess - stepsize*gradf(nextguess);
       if exist('stopValue','var') && f(nextguess) > stopValue
           disp('f(x) Stop value has been reached .. Stopping the calcuation')
        break
      elseif (exist('time0','var') && toc(time0)> timelimit(2))
           disp('Computation time limit has been reached.. Stopping the calcuation')
        break
       end
 end
outputArg1 = nextguess;

end
