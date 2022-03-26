clc;
clear;
close all;

%% Problem Definition

%CostFunc = @QuadMatFunc;
problem.CostFunc = @(A,b,c,x) QuadMatFunc(A,b,c,x);

%% GA Parameters
params.A = [-1 -1; 0 -1];
params.b = [-2; 2];
params.c = 0;

params.MaxIt = 100;
params.nPop = 100;

params.beta = 1; % RoulettewheelSelection beta
params.pC = 1; % Ratio of offspring to parents
params.mu = 0.0; % mutation percentage


%% Run GA

out = RunGA(problem, params);

%% Results

