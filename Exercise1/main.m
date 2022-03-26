% Manual mode

%%%% User Guide %%%%
% To use a function, uncomment the relevant line and change the parameters
% According to the parameter list instruction given to each function. Each
% function is provided with sample data, which the user can change.

% param 1,2,3,4: a,b,c,d
% param 5: starting x value. provide true and two values to the array if you want to
% give a range of values to draw from. provide false and a single value
% if you want to specify the initial x value
% param 6: f(x) stop value. provide true and a value to stop the
% calculation when f(x) is bigger than a desired value. Provide false
% otherwise
% param 7: timelimit(in seconds). provide true if you want to set a calculation time
% limit. Provide false otherwise
% param 8: numOfIterations. Maximum number of iterations.

% newtonOptScalar(2, 3, 1, 1, [true; 1; 5], [false; 0.203], [true; 15], 10000000)


% param 1,2,3: c, b, A
% param 4: starting x value. As above, only here we pass a vector
% param 5, 6, 7: stop value, timelimit(in seconds), numOfIterations. All same as above

% newtonOptVector(0, [5; -2], [1 1; 0 1], [true, [1, 100]], [false; -13], [true; 12], 10000000)


% param 1,2,3,4: a,b,c,d
% param 5,6: starting x value (scalar), stop value. Same as above
% param 7: Step size for the gradient descent method
% param 8,9: timelimit(in seconds), numOfIterations. same as above

% gradDesOptScalar(2, 3, 1, 1, [true; 1; 5], [true; 0.9038], 0.001, [true; 12], 300000)


% param 1,2,3: c,b,A
% param 4,5: starting x value (scalar), stop value. Same as above
% param 6: Step size for the gradient descent method
% param 7,8: timelimit(in seconds), numOfIterations. same as above


% gradDesOptVector(0, [5; -2], [1 1; 0 1], [true; [1; 100]], [true; -11], 0.001, [true; 30], 10000000)




% Batch/Restart mode
% All function parameters are the same as their manual counterparts with
% the addition of one extra parameter at the end to specify how many times
% should the program (the optimization function) be rerun

%newtonOptScalarB(2, 3, 1, 1, [true; 1; 100], [false; 0.90377], [false; 23], 10, 3);
%newtonOptVectorB(0, [5; -2], [1 1; 0 1], [true, [1, 100]], [true; -13], [false; 22], 5, 3)
%gradDesOptScalarB(2, 3, 1, 1, [true; 1; 100], [false; 0.9038], 0.001, [false; 50], 100, 3);
%gradDesOptVectorB(0, [5; -2], [1 1; 0 1], [true; [1; 100]], [false; -11], 0.001, [false; 23], 100,3)
