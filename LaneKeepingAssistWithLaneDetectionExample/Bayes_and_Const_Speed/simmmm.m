

tic 
sim('LKA_for_Bayes')
% sim('LVI_PDNN_for_QP2', 'SrcWorkspace', 'current','timeout',10);
elapTime = toc;

disp('Elapsed time')
disp(elapTime)
disp('Time per sample')
disp((elapTime-simStopTime)/(simStopTime*10))
disp('Cost:')

%%%%%%%%%%%%%%%%%%%%%%%%
% cost computing

kappa1 = 100;
kappa2 = 20;

lateral_deviation = logsout.getElement('lateral_deviation');    % lateral deviation
relative_yaw_angle = logsout.getElement('relative_yaw_angle');  % relative yaw angle
head_derivative = logsout.getElement('head_derivative');        % yaw angle's derivative
lateral_derivative = logsout.getElement('lateral_derivative');  % lateral deviation's derivative
steering_angle = logsout.getElement('steering_angle');          % steering angle
% steer_derivative = logsout.getElement('steer_derivative');      % steering angle's derivative
lateral_acceleration = logsout.getElement('lateral_acceleration');      % lateral_acceleration
head_acceleration = logsout.getElement('head_acceleration');      % head_acceleration

x1 = lateral_deviation.Values.Data;
x2 = lateral_derivative.Values.Data;
x3 = relative_yaw_angle.Values.Data;
x4 = head_derivative.Values.Data;
x5 = steering_angle.Values.Data;
% du = steer_derivative.Values.Data;

acc = lateral_acceleration.Values.Data;
acc = acc(acc<90&acc>-90);

hacc = head_acceleration.Values.Data;
hacc = hacc(hacc<8&hacc>-8);
% state = [x1,x2,x3,x4,x5];

% plotLKAPerformance(logsout)

% cost = sum(state.^2 * w_x');
% cost = trace(state * diag(w_x) * state');
% cost = cost + sum(du.^2 .* w_u);
cost = 0;
% 
if max(x1) == 0.5 || min(x1) == -0.5
%     'wyszuem o';
    texit = find(x1 == max(x1),1) * Ts;
%     'kosztowauo mn to';
%     kappa1/(texit+0.000001);
    cost = kappa2 + kappa1/(texit+0.000001);
    cost = cost + numel(x1(abs(x1) == 0.5))/3; %punishin each sample on 0.5 
% else
end

cost = cost + x1'*x1; % lateral deviation
cost = cost + x2'*x2; % lateral velocity
cost = cost + acc'*acc/300; % lateral acceleration
cost = cost + hacc'*hacc/100; % heading acceleration
cost = cost + x4'*x4; % heading angle


disp(cost)