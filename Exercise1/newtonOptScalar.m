function output = newtonOptScalar(a, b, c, d, startX, stop, timelimit, numOfIterations)

if(startX(1) == true)
    nextX = (startX(2) - startX(3)).*rand() + startX(3);
else 
    nextX = 1;
end

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
           disp('F(x) Stop value has been reached .. Stopping the calcuation')
        break
       elseif (exist('time0','var') && toc(time0)>timelimit(2))
           disp('Computation time limit has been reached.. Stopping the calcuation')
        break
       end
   end
output = round(nextX,5);
end

