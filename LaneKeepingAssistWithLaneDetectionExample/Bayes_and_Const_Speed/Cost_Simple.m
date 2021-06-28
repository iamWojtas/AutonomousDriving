if strcmp(get_param('LKATestBenchExample','FastRestart'),'on')
    logsout = ans.logsout;
    tout = ans.tout;
end
kappa = 25;
lateral_deviation = logsout.getElement('lateral_deviation');    % lateral deviation
relative_yaw_angle = logsout.getElement('relative_yaw_angle');  % relative yaw angle
head_derivative = logsout.getElement('head_derivative');        % yaw angle's derivative
lateral_derivative = logsout.getElement('lateral_derivative');  % lateral deviation's derivative
steering_angle = logsout.getElement('steering_angle');          % steering angle
steer_derivative = logsout.getElement('steer_derivative');      % steering angle's derivative
lateral_acceleration = logsout.getElement('lateral_acceleration');      % lateral_acceleration
head_acceleration = logsout.getElement('head_acceleration');      % head_acceleration

x1 = lateral_deviation.Values.Data;
x2 = lateral_derivative.Values.Data;
x3 = relative_yaw_angle.Values.Data;
x4 = head_derivative.Values.Data;
x5 = steering_angle.Values.Data;
du = steer_derivative.Values.Data;

acc = lateral_acceleration.Values.Data;
hacc = head_acceleration.Values.Data;
% state = [x1,x2,x3,x4,x5];

% cost = sum(state.^2 * w_x');
% cost = trace(state * diag(w_x) * state');
% cost = cost + sum(du.^2 .* w_u);

if max(x1) == 0.5 || min(x1) == -0.5
    k = find(abs(x1)==0.5,1);
    tout(k)*numel(tout)/length(x1)
    cost = kappa + kappa/(tout(k)*numel(tout)/length(x1));
else
    cost = x1'*x1;% + acc'*acc + hacc;
end

% if cost > 5
%     cost = 5;
% end


