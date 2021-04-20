function cost = MPC_Cost(t_in)

global UU n_p w_u w_x n_c Phi1

tht1 = t_in.theta1;
tht2 = t_in.theta2;
tht3 = t_in.theta3;
tht4 = t_in.theta4;
% theta5 = t_in.theta5;
% theta6 = t_in.theta6;


w_x_theta = [1000*tht1 10*tht2 7000*tht3 300*tht4 5]; % p=30, c=10
w_x1_theta = repmat(w_x_theta,1,n_p);
W_x_theta = diag(w_x1_theta);

w_u = 1;
W_u = ones(n_c,1)';

UU = -inv(Phi1' * W_x_theta * Phi1 + W_u) * Phi1' * W_x_theta;

sim('LKATestBenchExample')

lateral_deviation = logsout.getElement('lateral_deviation');    % lateral deviation
relative_yaw_angle = logsout.getElement('relative_yaw_angle');  % relative yaw angle
head_derivative = logsout.getElement('head_derivative');        % yaw angle's derivative
lateral_derivative = logsout.getElement('lateral_derivative');  % lateral deviation's derivative
steering_angle = logsout.getElement('steering_angle');          % steering angle
steer_derivative = logsout.getElement('steer_derivative');      % steering angle's derivative

x1 = lateral_deviation.Values.Data;
x2 = lateral_derivative.Values.Data;
x3 = relative_yaw_angle.Values.Data;
x4 = head_derivative.Values.Data;
x5 = steering_angle.Values.Data;
du = steer_derivative.Values.Data;     

% state = [x1,x2,x3,x4,x5];

% cost = sum(state.^2 * w_x');
% cost = trace(state * diag(w_x) * state');
% cost = cost + sum(du.^2 .* w_u);

cost = x1'*x1;

end
