scenario = drivingScenario('SampleTime',0.1','StopTime',60);

R = 50;

angs = [0:10:180]';
roadcenters1 = R*[cosd(angs) sind(angs) zeros(size(angs))];
roadwidth = 5;
% road(scenario,roadcenters1,roadwidth);

roadcenters2 = [R -100 0; R -20 0];
% road(scenario,roadcenters2,roadwidth);

angs = [-180:10:0]';
roadcenters3 = R*[cosd(angs) sind(angs) zeros(size(angs))];
roadcenters3 = roadcenters3 + [0 -100 0];
% road(scenario,roadcenters3,roadwidth);

roadcenters4 = [-R 0 0; -R -100 0];
roadwidth = 5;
% road(scenario,roadcenters4,roadwidth);

roadcenters = [roadcenters1;roadcenters4;roadcenters3;roadcenters2];
roadCenters = ...
    [  0  40  49  50 100  50  49 40 -40 -49 -50 -100  -50  -49  -40    0
     -50 -50 -50 -50   0  50  50 50  50  50  50    0  -50  -50  -50  -50
       0   0 .45 .45 .45 .45 .45  0   0 .45 .45  .45  .45  .45    0    0]';

road(scenario,roadCenters,roadwidth);


export(scenario,'OpenDRIVE','scenario03.xodr')
plot(scenario,'Centerline','on','RoadCenters','on');
title('Scenario');









