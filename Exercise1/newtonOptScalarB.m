function [output1, output2] = newtonOptScalarB(a, b, c, d, startX, stop, timelimit, numOfIterations, restartCount)

fxRecord = [];

for k = 1:restartCount

if(startX(1) == true)
    nextX = (startX(2) - startX(3)).*rand() + startX(3);
else 
    nextX = 1;
end
disp(nextX)

if(stop(1) == true)
    stopValue = stop(2);
end

if(timelimit(1) == true) 
    time0 = tic;
end

syms x
functionToOptimize = a*x.^3 + b*x.^2 + c*x + d;

   for i = 1:numOfIterations
       firstDiff = subs(diff(functionToOptimize), 'x', nextX);
       secondDiff = subs(diff(diff(functionToOptimize)),'x',nextX);

       nextX = vpa((nextX - firstDiff/secondDiff),10);
       fx = vpa((subs(functionToOptimize,x,nextX)),5);

       if (exist('stopValue','var') && fx > stopValue)
           disp('f(x) Stop value has been reached .. Stopping the calcuation')
        break

       elseif (exist('time0','var') && toc(time0)>timelimit(2)) 
           disp('Computation time limit has been reached.. Stopping the calcuation')
       end
   end
   fxRecord = [fxRecord, fx];
end

disp('Mean value of f(x) is: ')
disp(round(mean(fxRecord),5))
disp('Standard deviation of f(x) is: ')
disp(round(std(fxRecord),5))

output1 = mean(fxRecord);
output2 = std(fxRecord);
end