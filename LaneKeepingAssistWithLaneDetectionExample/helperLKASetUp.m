% Set up Script for the Lane Keeping Assist (LKA) Example
%
% This script initializes the LKA example model. It loads necessary control
% constants and sets up the buses required for the referenced model
%
%   This is a helper script for example purposes and may be removed or
%   modified in the future.

%   Copyright 2017-2018 The MathWorks, Inc.

%% General Model Parameters
Ts = 0.1;               % Simulation sample time                (s)

%% Ego Car Parameters
% Dynamics modeling parameters
m       = 1575;     % Total mass of vehicle                          (kg)
Iz      = 2875;     % Yaw moment of inertia of vehicle               (m*N*s^2)
lf      = 1.2;      % Longitudinal distance from c.g. to front tires (m)
lr      = 1.6;      % Longitudinal distance from c.g. to rear tires  (m)
Cf      = 19000;    % Cornering stiffness of front tires             (N/rad)
Cr      = 33000;    % Cornering stiffness of rear tires              (N/rad)

%% Controller parameter
PredictionHorizon = 30; % Number of steps for preview    (N/A)

%% Bus Creation
% Create buses for lane sensor and lane sensor boundaries
createLaneSensorBuses
% Create the bus of actors from the scenario reader
modelName = 'LKATestBenchExample';
wasModelLoaded = bdIsLoaded(modelName);
if ~wasModelLoaded
    load_system(modelName)
end
% load the bus for scenario reader
blk=find_system(modelName,'System','driving.scenario.internal.ScenarioReader');
s = get_param(blk{1},'PortHandles');
get(s.Outport(1),'SignalHierarchy');

%% Create scenario and road specifications
% [scenario,roadCenters,laneSpecification] = createDoubleCurveScenario;
[scenario1,roadCenters,laneSpecification] = createDynamicTurnScenario;
% You can use Driving Scenario Designer to explore the scenario
% drivingScenarioDesigner(scenario)
% drivingScenarioDesigner('LKATestBenchScenario')

%% Generate data for Simulink simulation  
[driverPath,x0_ego,y0_ego,v0_ego,yaw0_ego,simStopTime] = ...
    createDriverPath(scenario1,6);
% initial pose for variable speed trajectory
% x0_ego = 0;
% y0_ego = -160;
% yaw0_ego = -90;



%% Load Gains BayesOpt - variable speed testing
% To perform this test, compile this code cell and rewrite the maximum
% curvature and maximum speed into MPC_Controls and change the simulink
% scheme so that Matlab Interpreted Function block is the control, and not
% the MATLAB Function. Additionally, change the configuration of speed
% control - change the manual switches in Vehicle and Environment subsystem
gains = readtable('gainsTable.csv');
global gains v_max
gains = table2array(gains);

v_max = 35;
mar_curv = 0.4*9.81/(v_max^2)