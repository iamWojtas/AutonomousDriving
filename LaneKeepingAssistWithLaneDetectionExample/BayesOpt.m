clc

global v egoCar hAxes scenario1 r 

% v = 8;
Model_Init;
% Creating a track for a given speed
% save_system('LKATestBenchExample');
% close_system('LKATestBenchExample');
[scenario1,roadCenters,laneSpecification,egoCar] = createDynamicTurnScenario;
% open_system('LKATestBenchExample');

x0_ego = 3*r;
yaw0_ego = 0;
simStopTime = 18*r/v;

theta1 = optimizableVariable('theta1',[0,5000]);
theta2 = optimizableVariable('theta2',[0,400]);
theta3 = optimizableVariable('theta3',[0,50000]);
theta4 = optimizableVariable('theta4',[0,30000]);
theta5 = optimizableVariable('theta5',[1,1000]);
theta6 = optimizableVariable('theta6',[1,1000]);


% x = [theta2, theta4];
% x = [theta1, theta2, theta3, theta4];
x = [theta1, theta2, theta3, theta4, theta5, theta6];

% theta1.Optimize = false;
% theta3.Optimize = false;

fun = @MPC_Cost;

results = bayesopt(fun,x,'MaxObjectiveEvaluations',50);
% 
% %Compute controller gains based on the minimum observed point
% computeGain(results.XAtMinObjective.Variables);

%Compute controller gains based on the minimum estimated point
computeGain([0 results.XAtMinObjective.Variables]);


% Saving to CSV file
asdf = results.XAtMinObjective.Variables;
objective = results.MinObjective;
dlmwrite('Interpolation.csv',[objective v asdf],'-append');

%Simulate the best fit
% simStopTime = 2*simStopTime;
% sim('LKATestBenchExample');
% simStopTime = 1/2*simStopTime;

%Plot the results of the best fit
% plotLKAPerformance(logsout)

