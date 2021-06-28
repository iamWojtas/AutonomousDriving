global v egoCar hAxes scenario1 r

begin = 9;
step = 1;
finish = 35;
open_system('LKATestBenchExample');
for i = begin:step:finish
    v = i;
    save_system('LKATestBenchExample');
    close_system('LKATestBenchExample');
    [scenario1,roadCenters,laneSpecification,egoCar] = createDynamicTurnScenario;
    open_system('LKATestBenchExample');
    mdlWks = get_param('LKATestBenchExample','ModelWorkspace');
    mdlWks.DataSource = 'MATLAB Code';
    reload(mdlWks);
    BayesOpt;
end      