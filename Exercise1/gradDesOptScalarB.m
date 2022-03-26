function [output1, output2] = gradDesOptScalarB(a, b, c, d, startX, stop, stepsize, timelimit, iterations, restartCount)

fxRecord = [];

for k=1:restartCount

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
      elseif (exist('time0','var') && toc(time0)>timelimit(2))
          disp('Computation time limit has been reached.. Stopping the calcuation')
          break;
      end
 end
 fxRecord = [fxRecord, f(nextguess)];
end

disp('Mean value of f(x) is: ')
disp(round(mean(fxRecord),5))
disp('Standard deviation of f(x) is: ')
disp(round(std(fxRecord),5))

output1 = round(mean(fxRecord),5);
output2 = round(std(fxRecord),5);
end