function plotLKAResults_Compare(scenario,logsout1,logsout2,logsout3)

plotDriverPath = true;
if nargin < 6
    plotDriverPath = false;
end
% Overlay driver path and actual path
figure('Color','white');
%plotLKAResults_Compare(scenario,logsoutPID,logsoutLQR,logsoutMPC_Matlab)
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);

plot(scenario,'Parent',ax1)
ylim([-50 200])

plot(scenario,'Parent',ax2)
xlim([20 145])
ylim([-20 30])

if plotDriverPath
    line(ax1,driverPath(:,1),driverPath(:,2),'Color','blue','LineWidth',1)
    line(ax2,driverPath(:,1),driverPath(:,2),'Color','blue','LineWidth',1)
    ax1.Title = text(0.5,0.5,'Road and driver path');
    ax2.Title = text(0.5,0.5,'Driver asssisted at curvature change');
else
    ax1.Title = text(0.5,0.5,'Road and assisted path');
    ax2.Title = text(0.5,0.5,'Lane keeping assist at curvature change');
end

%legend('PID','LQR','MPC')
p1=line(ax1,logsout1.get('position').Values.Data(:,1),...
     logsout1.get('position').Values.Data(:,2),...
     'Color','red','LineWidth',1);
p1=line(ax2,logsout1.get('position').Values.Data(:,1),...
     logsout1.get('position').Values.Data(:,2),...
     'Color','red','LineWidth',1);
hold on
p2=line(ax1,logsout2.get('position').Values.Data(:,1),...
     logsout2.get('position').Values.Data(:,2),...
     'Color','blue','LineWidth',1);
p2=line(ax2,logsout2.get('position').Values.Data(:,1),...
     logsout2.get('position').Values.Data(:,2),...
     'Color','blue','LineWidth',1);
 
p3=line(ax1,logsout3.get('position').Values.Data(:,1),...
     logsout3.get('position').Values.Data(:,2),...
     'Color','green','LineWidth',1);
p3=line(ax2,logsout3.get('position').Values.Data(:,1),...
     logsout3.get('position').Values.Data(:,2),...
     'Color','green','LineWidth',1);

linehandles = [p1, p2, p3];
cols = cell2mat(get(linehandles, 'color'));
[~, uidx] = unique(cols, 'rows', 'stable');
legend(linehandles(uidx), {'PID','LQR','MPC'})