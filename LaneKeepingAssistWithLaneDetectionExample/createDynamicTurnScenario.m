function [scenario,roadCenters,laneSpecification,egoCar] = createDynamicTurnScenario(plotScenario) 
% Create scenario and road specifications
global v r

if nargin < 1
    plotScenario = false;
end


scenario = drivingScenario;
% scenario.StopTime = 80;

% Bayes Opt Training tracks

v
r = v^2/0.4/9.81;

roadCenters = [
    
    3*r   0     0;
%     4*r   0     0;
    5*r   0     0;
    6*r   r     0;
    5*r   2*r   0;
    3*r   1.5*r 0;
    r     2*r   0;
    0     r     0;
    r     0     0;
%     2*r   0     0;
    3*r   0     0
];

% roadCenters = [0 -159.8 0;
%     0 -199.6 0;
%     17.4 -249.1 0;
%     58 -290.1 0;
%     50.1 -349.1 0;
%     101.4 -399.7 0;
%     150.5 -349.1 0;
%     151.2 -289.9 0;
%     100.7 -247.3 0;
%     50.2 -180.2 0;
%     51.3 -98.1 0;
%     88.2 -73.9 0;
%     115.9 -102.4 0;
%     114.4 -185.7 0;
%     139.7 -217.4 0;
%     173.8 -185.7 0;
%     174.6 -85.8 0;
%     85.8 -0.9 0;
%     0.2 -86.6 0;
%     0 -159.8 0];



% Create lanes
laneSpecification = lanespec(1);
road(scenario, roadCenters, 'Lanes', laneSpecification);
waypoints = roadCenters;
% Add ego car
egoCar = vehicle(scenario, ...
    'ClassID', 1);
trajectory(egoCar, waypoints, v);

lb = laneBoundaries(egoCar,'XDistance',linspace(0,500,50000) ,'LocationType','Center', ...
        'AllBoundaries',false);

if plotScenario
    plot(scenario,'Waypoints','on');
    set(gcf,'color','w');
end

% drivingScenarioDesigner(scenario)

% cuvatures = LineCurvature2D(roadCenters(:,1:2));
% asdfa = 1./cuvatures;
% asdfa(asdfa < 10000)