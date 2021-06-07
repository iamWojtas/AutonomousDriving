clc

global v r gains

v = 10;

save_system('LKATestBenchExample');
close_system('LKATestBenchExample');
[scenario1,roadCenters,laneSpecification,egoCar] = createDynamicTurnScenario;
simStopTime = 18*r/v;

% computeGain(gains(int8(v)-7,:));
% computeGain([1410.5  4.7689 	6491.7	24801	966.95	188.41]);

open_system('LKATestBenchExample');
mdlWks = get_param('LKATestBenchExample','ModelWorkspace');
mdlWks.DataSource = 'MATLAB Code';
reload(mdlWks);
sim('LKATestBenchExample')
plotLKAPerformance(logsout)