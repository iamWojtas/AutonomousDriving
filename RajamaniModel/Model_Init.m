%% init Rajamani
% open_system('LKATestBenchExample')
clc
% clear all
% close all

Ts = 0.05;
g = 9.806;

lr = 1.1;
lf = 1.58;
ls = 0;

cf = 80000; 
cr = 80000; 

m = 1573;
iz = 2873; 

v0_ego = 13.9;
v = v0_ego;

%% init LKA

lr = 1.2;
lf = 1.6;
ls = 0;

cf = 19000; 
cr = 33000; 

m = 1575;
iz = 2875; 

v0_ego = 13.9;
v = v0_ego;

%% State space with state variables: y = lateral position, psi = global yaw angle 
% 
% a22 = -2*(cr + cf)/(m*v);
% a24 = -v-2*(lf*cf - lr*cr)/(m*v);                                      
% a42 = -2*(lf*cf - lr*cr)/(iz*v);
% a44 = -2*(lr^2*cr + lf^2*cf)/(iz*v);
% 
% 
% A = [0 1 0 0;
%     0 a22 0 a24;
%     0 0 0 1;
%     0 a42 0 a44];
% 
% B = [0; 2*cf/m; 0; 2*lf*cf/iz];
% 
% % this is uncontrollable, so lets check stabilizability
% % Reformulating the system to controllability form:
% 
% Ac = [a22 a24 0 0;
%     a42 a44 0 0;
%     1 0 0 0;
%     0 1 0 0];
% Bc = [2*cf/m; 2*lf*cf/iz; 0 ; 0];
% 
% % zero eigenvalues for the uncontrollable poles - idk

%% State space with state variables: e1 = lateral deviation, e2 = heading error

a22 = -2*(cr + cf)/(m*v);
a23 = 2*(cr + cf)/m;
a24 = -2*(lf*cf - lr*cr)/(m*v);                                      
a42 = -2*(lf*cf - lr*cr)/(iz*v);
a43 = 2*(lf*cf - lr*cr)/iz;
a44 = -2*(lr^2*cr + lf^2*cf)/(iz*v);


Ac = [0 1 0 0;
    0 a22 a23 a24;
    0 0 0 1;
    0 a42 a43 a44];

B1c = [0; 2*cf/m; 0; 2*lf*cf/iz];

b2 = -2*(lf*cf - lr*cr)/(m*v) - v; % a24 -v
b4 = -2*(lr^2*cr + lf^2*cf)/(iz*v); % a44
B2c = [0;  b2; 0; b4];

Bc = [B1c B2c];
Cc = eye(4);
Dc = zeros(4,2);


c_sys = ss(Ac,Bc,Cc,Dc);
%% LQR controller


rank(ctrb(Ac,B1c))
kp = [-5-3i -5+3i -7 -10];
K = acker(Ac,B1c,kp)

%% MPC

global UU F Phi2 n_p v


d_sys = c2d(c_sys,Ts,'');

A = d_sys.A;
B = d_sys.B;
B1 = B(:,1);
B2 = B(:,2);
C = d_sys.C;
D = d_sys.D;


% augmented matrices
AA = [A B1 ; zeros(1,4) 1];
BB1 = [B1 ; 1];
BB2 = [B2 ; 0];

% state at time k
x_k = [1 0 0 0]';

% input at time k-1
u_k_1 = 0;

% augmented state at time k
X_k = [x_k; u_k_1];

% prediction horizon
n_p =30;

% control horizon
n_c = 10;

% F matrix 
F = AA;
for i = 2:n_p
    F = [F; AA^i];
end

% Phi1 matrix
Phi1 = BB1;
for i = 1:n_p-1
    Phi1 = [Phi1; AA^i*BB1];
end
for i = 1:n_c-1
    a = [zeros(i*5 , 1) ; Phi1(1:(5*(n_p - i)) , 1)];
    Phi1 = [Phi1 a];
end

% Phi2 matrix
Phi2 = BB2;
for i = 1:n_p-1
    Phi2 = [Phi2; AA^i*BB2];
end
for i = 1:n_p-1
    a = [zeros(i*5 , 1) ; Phi2(1:(5*(n_p - i)) , 1)];
    Phi2 = [Phi2 a];
end

%% weights

% weighting matrices

% w_x = [0.2 0.5 1 100 1]; % p=10, c~=4
% w_x = [60 50 1000 2000 500]; % p=30, c=5
% w_x = [1000 1000 7000 30000 5]; % p=30, c=10
% w_x = [2 5 10 400 0]; % Ts = 0.2 p=30, c=10
w_x = [20 5 10 400 0]; % Ts = 0.05 p=30, c=10

w_x1 = w_x;
for i = 1:n_p-1
    w_x = [w_x w_x1];
%     w_x = w_x.*1.1;   
end
W_x = diag(w_x);

w_u = 1;
w_u1 = w_u;
for i = 1:n_c-1
    w_u = [w_u w_u1];
%     w_u = w_u.*2;
end
W_u = diag(w_u);


% W_u = diag([1:n_c].*1000);%diag(w_u);
% W_u = eye(n_c);

UU = -inv(Phi1' * W_x * Phi1 + W_u) * Phi1' * W_x;

MPC_Control([1:n_p+7]')


% sim('Simulation')
% PlotSim
sim('LKATestBenchExample')
plotLKAPerformance(logsout)
hold on
% plotLKAResults(scenario,logsout)
% plotLKAPerformance(logsout)

% link to directory of LKA
% C:\Users\Stage\Documents\MATLAB\Examples\R2020b\autonomous_control\LaneKeepingAssistWithLaneDetectionExample