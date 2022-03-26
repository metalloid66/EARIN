function output = newtonOptVector(c, b, A, startX, stop, timelimit, numOfIterations)
[bRows, ~] = size(b);


if(startX(1) == true)
    xVector = (startX(2) - startX(3)).*rand(bRows,1) + startX(3);
else 
    xVector = zeros(bRows,1);
    for i = 1:bRows
        xVector(i) = startX(i+1);
    end
end

if(stop(1) == true)
    stopValue = stop(2);
end

if(timelimit(1) == true) 
    time0 = tic;
end

xVars = sym('x',[bRows 1]);
functionToOptimize = c + (transpose(b)*xVars) + (transpose(xVars)*A*xVars);

grad2 = transpose(A) + A;

    for j=1:numOfIterations

gradSubed = subs((b + A*xVars +  A.'*xVars), xVars,xVector);
xVector = xVector - (inv(grad2) * gradSubed);
gx = subs(functionToOptimize,xVars,xVector);

       if exist('stopValue','var') && gx > stopValue
           disp('g(x) Stop value has been reached .. Stopping the calcuation')
        break
      elseif (exist('time0','var') && toc(time0)>timelimit(2))
           disp('Computation time limit has been reached.. Stopping the calcuation')
        break
       end
    end

output = xVector;
end
