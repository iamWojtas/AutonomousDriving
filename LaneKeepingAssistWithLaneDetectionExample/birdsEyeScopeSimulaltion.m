[scenario,roadCenters,laneSpecification,car] = createDynamicTurnScenario(false);

% bep = birdsEyePlot('XLim',[-40 40],'YLim',[-30 30]);
olPlotter = outlinePlotter(bep);
lblPlotter = laneBoundaryPlotter(bep,'Color','r','LineStyle','-');
lbrPlotter = laneBoundaryPlotter(bep,'Color','g','LineStyle','-');
rbsEdgePlotter = laneBoundaryPlotter(bep);
legend('off');

chasePlot(car)  
while advance(scenario)
%     rbs = roadBoundaries(car);
%     [position,yaw,length,width,originOffset,color] = targetOutlines(car);
%     lb = laneBoundaries(car,'XDistance',0:5:30,'LocationType','Center', ...
%         'AllBoundaries',false);
%     plotLaneBoundary(rbsEdgePlotter,rbs)
%     plotLaneBoundary(lblPlotter,{lb(1).Coordinates})
%     plotLaneBoundary(lbrPlotter,{lb(2).Coordinates})
%     plotOutline(olPlotter,position,yaw,length,width, ...
%         'OriginOffset',originOffset,'Color',color)
%     chasePlot(car)
    drawnow limitrate;
end