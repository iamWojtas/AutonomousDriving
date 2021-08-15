% function plotLKAPerformance_Combined(logsout1,logsout2,logsout3,prrt)
% % A helper function for plotting the results of the LKA demo.
% %
% %   This is a helper function for example purposes and may be removed or
% %   modified in the future.
% %
% % The function assumes that the demo outputs the Simulink log, logsout,
% % containing the following elements: lateral_deviation, relative_yaw_angle,
% % abd steering_angle.
% 
% % Copyright 2017 The MathWorks, Inc.
% 
% %plotLKAPerformance_Combined(logsoutPID,logsoutLQR,logsoutMPC_Matlab)
% 
% %% Get the data from simulation
% lateral_deviation1 = logsout1.getElement('lateral_deviation');    % lateral deviation
% relative_yaw_angle1 = logsout1.getElement('relative_yaw_angle');  % relative yaw angle
% steering_angle1 = logsout1.getElement('steering_angle');          % steering angle
% 
% lateral_deviation2 = logsout2.getElement('lateral_deviation');    % lateral deviation
% relative_yaw_angle2 = logsout2.getElement('relative_yaw_angle');  % relative yaw angle
% steering_angle2 = logsout2.getElement('steering_angle');          % steering angle
% 
% lateral_deviation3 = logsout3.getElement('lateral_deviation');    % lateral deviation
% relative_yaw_angle3 = logsout3.getElement('relative_yaw_angle');  % relative yaw angle
% steering_angle3 = logsout3.getElement('steering_angle');          % steering angle
% 
% %% Plot the results
% figure('Name','Controller Performance','position',[100 100 720 600],'Color','white');
% % lateral deviation
% subplot(3,1,1);
% plot(lateral_deviation1.Values.time,lateral_deviation1.Values.Data,'r','LineWidth',2);
% hold on
% plot(lateral_deviation2.Values.time,lateral_deviation2.Values.Data,'g','LineWidth',2);
% grid on;
% legend({'Adaptive MPC','MPC'},'location','NorthEast');
% title('Lateral deviation')
% xlabel('time (sec)')
% ylabel('lateral deviation (m)')
% % relative yaw angle
% subplot(3,1,2);
% plot(relative_yaw_angle1.Values.time,relative_yaw_angle1.Values.Data,'r','LineWidth',2);
% hold on
% plot(relative_yaw_angle2.Values.time,relative_yaw_angle2.Values.Data,'g','LineWidth',2);
% grid on;
% legend({'Adaptive MPC','MPC'},'location','NorthEast');
% title('Relative yaw angle')
% xlabel('time (sec)')
% ylabel('relative yaw angle (rad)')
% % steering angle
% subplot(3,1,3);
% plot(steering_angle1.Values.time,steering_angle1.Values.Data,'r','LineWidth',2);
% hold on
% plot(steering_angle2.Values.time,steering_angle2.Values.Data,'g','LineWidth',2);
% grid on;
% legend({'Adaptive MPC','MPC'},'location','NorthEast');
% title('Steering angle')
% xlabel('time (sec)')
% ylabel('steering angle (rad)')
% 
% 












function plotLKAPerformance_Combined(texts,logsout1,logsout2,logsout3)
% A helper function for plotting the results of the LKA demo.
%
%   This is a helper function for example purposes and may be removed or
%   modified in the future.
%
% The function assumes that the demo outputs the Simulink log, logsout,
% containing the following elements: lateral_deviation, relative_yaw_angle,
% abd steering_angle.

% Copyright 2017 The MathWorks, Inc.

%plotLKAPerformance_Combined(logsoutPID,logsoutLQR,logsoutMPC_Matlab)

%% Get the data from simulation
lateral_deviation1 = logsout1.getElement('lateral_deviation');    % lateral deviation
relative_yaw_angle1 = logsout1.getElement('relative_yaw_angle');  % relative yaw angle
steering_angle1 = logsout1.getElement('steering_angle');          % steering angle
execution_time1 = logsout1.getElement('execution_time');          % execution time

lateral_deviation2 = logsout2.getElement('lateral_deviation');    % lateral deviation
relative_yaw_angle2 = logsout2.getElement('relative_yaw_angle');  % relative yaw angle
steering_angle2 = logsout2.getElement('steering_angle');          % steering angle
execution_time2 = logsout2.getElement('execution_time');          % execution time

if nargin > 3
    lateral_deviation3 = logsout3.getElement('lateral_deviation');    % lateral deviation
    relative_yaw_angle3 = logsout3.getElement('relative_yaw_angle');  % relative yaw angle
    steering_angle3 = logsout3.getElement('steering_angle');          % steering angle
    execution_time3 = logsout3.getElement('execution_time');          % execution time
end
%% Plot the results
figure('Name','Controller Performance','position',[100 100 720 600],'Color','white');
% lateral deviation
subplot(4,1,1);
plot(lateral_deviation1.Values.time,lateral_deviation1.Values.Data,'r','LineWidth',2);
hold on
plot(lateral_deviation2.Values.time,lateral_deviation2.Values.Data,'g','LineWidth',2);
if nargin > 3
    plot(lateral_deviation3.Values.time,lateral_deviation3.Values.Data,'b','LineWidth',2);
end
grid on;
legend(texts,'location','NorthEast');
title('Lateral deviation')
xlabel('time (sec)')
ylabel('lateral deviation (m)')
% relative yaw angle
subplot(4,1,2);
plot(relative_yaw_angle1.Values.time,relative_yaw_angle1.Values.Data,'r','LineWidth',2);
hold on
plot(relative_yaw_angle2.Values.time,relative_yaw_angle2.Values.Data,'g','LineWidth',2);
if nargin > 3
    plot(relative_yaw_angle3.Values.time,relative_yaw_angle3.Values.Data,'b','LineWidth',2);
end
grid on;
legend(texts,'location','NorthEast');
title('Relative yaw angle')
xlabel('time (sec)')
ylabel('relative yaw angle (rad)')
% steering angle
subplot(4,1,3);
plot(steering_angle1.Values.time,steering_angle1.Values.Data,'r','LineWidth',2);
hold on
plot(steering_angle2.Values.time,steering_angle2.Values.Data,'g','LineWidth',2);

if nargin > 3
    plot(steering_angle3.Values.time,steering_angle3.Values.Data,'b','LineWidth',2);
end
grid on;
legend(texts,'location','NorthEast');
title('Steering angle')
xlabel('time (sec)')
ylabel('steering angle (rad)')


% execution time
et1 = execution_time1.Values.Data(2:end);
et2 = execution_time2.Values.Data(2:end);
t = execution_time1.Values.time(2:end);

subplot(4,1,4);
plot(t,et1,'r','LineWidth',2);
hold on
plot(t,et2,'g','LineWidth',2);

if nargin > 3
    et3 = execution_time3.Values.Data(2:end);
    plot(t,et3,'b','LineWidth',2);
end

grid on;
legend(texts,'location','NorthEast');
title('Execution time')
xlabel('time (sec)')
ylabel('execution time (s)')






