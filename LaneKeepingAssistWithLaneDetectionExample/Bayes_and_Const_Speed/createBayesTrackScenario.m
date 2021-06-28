function [scenario,roadCenters,laneSpecification,egoCar] = createBayesTrackScenario(plotScenario) 
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