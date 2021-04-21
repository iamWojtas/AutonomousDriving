clc

theta1 = optimizableVariable('theta1',[100,1000]);
theta2 = optimizableVariable('theta2',[1,300]);
theta3 = optimizableVariable('theta3',[2000,3000]);
theta4 = optimizableVariable('theta4',[3000,4000]);
% theta5 = optimizableVariable('theta5',[1,100]);
% theta6 = optimizableVariable('theta6',[1,100]);

% x = [theta2, theta4];
x = [theta1, theta2, theta3, theta4];
fun = @MPC_Cost;

results = bayesopt(fun,x);

%Compute controller gains based on the minimum point
computeGain(results.XAtMinObjective.Variables);

%Simulate the best fit
simStopTime = 36*13.9/v-3;
sim('LKATestBenchExample');

%Plot the results of the best fit
plotLKAPerformance(logsout)

