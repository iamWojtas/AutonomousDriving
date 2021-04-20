clc

theta1 = optimizableVariable('theta1',[0.5,5]);
theta2 = optimizableVariable('theta2',[50,200]);
theta3 = optimizableVariable('theta3',[0.5,5]);
theta4 = optimizableVariable('theta4',[50,300]);
% theta5 = optimizableVariable('theta5',[1,100]);
% theta6 = optimizableVariable('theta6',[1,100]);

x = [theta1, theta2, theta3, theta4];
fun = @MPC_Cost;
results = bayesopt(fun,x);