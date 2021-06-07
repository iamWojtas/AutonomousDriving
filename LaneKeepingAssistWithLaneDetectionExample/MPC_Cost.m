function cost = MPC_Cost(t_in)

global UU n_p w_u w_x n_c Phi1  v r sqrp Ts gains

tht1 = t_in.theta1;
tht2 = t_in.theta2;
tht3 = t_in.theta3;
tht4 = t_in.theta4;
tht5 = t_in.theta5;
tht6 = t_in.theta6;

kappa1 = 100;
kappa2 = 20;

% tht1 = 400;
% tht3 = 9798;

% w_x_theta = [1000*tht1 10*tht2 7000*tht3 300*tht4 5]; % p=30, c=10
w_x_theta = [tht1 tht2 tht3 tht4 tht5]; % p=30, c=10
w_x1_theta = repmat(w_x_theta,1,n_p);
W_x_theta = diag(w_x1_theta);

w_u = tht6;
W_u = w_u*ones(n_c,1)';

% UU = -inv(Phi1' * W_x_theta * Phi1 + W_u) * Phi1' * W_x_theta;
% UU = gains(int8(v)-7,:);
UU = [ 1 tht1 tht2 tht3 tht4 tht5 tht6];

sim('LKATestBenchExample')

if strcmp(get_param('LKATestBenchExample','FastRestart'),'on')
    logsout = ans.logsout;
    tout = ans.tout;
end

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
% end
% 'max steering acc';
% max(du);

% 
% fh = findobj( 'Type', 'Figure', 'Name', 'Figure 1' );
% frame = getframe(fh); 
% im = frame2im(frame); 
% [imind,cm] = rgb2ind(im,256); 
% 
% if sqrp == 1 
% 	imwrite(imind,cm,'BayesFitting','gif', 'Loopcount',inf); 
% else 
% 	imwrite(imind,cm,'BayesFitting','gif','WriteMode','append'); 
% end 
% 
% sqrp = sqrp + 1
end
