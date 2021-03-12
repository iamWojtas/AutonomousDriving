clc
%clear all
%close all

Ts = 0.1;
g = 9.806;


global UU F Phi2 n_p


lr = 1.2;
lf = 1.6;
ls = 1.9;

cf = 19000; %198000;
cr = 33000; %470000;

m = 1575;
iz = 2875; %10.85 * m;

v0_ego = 13.9;
v = v0_ego;

a11 = 2*(cr + cf)/(m*v);
a12 = -1 + 2*(lr*cr - lf*cf)/(m*v^2);                                      
a21 = 2*(lr*cr - lf*cf)/iz;
a22 = -2*(lr^2*cr - lf^2*cf)/(iz*v);

A = [a11 a12 0 0;...
    a21 a22 0 0;...
    0 1 0 0;...
    v ls v 0];

B1 = [2*cf/(m*v); 2*lf*cf/iz; 0 ;0];
B2 = [0 0 -v 0]';
B = [B1 B2];
C = [0 0 1 0; 0 0 0 1];

D = zeros(2,2);

sys = ss(A,B,C,D);
d_sys = c2d(sys,Ts);

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
x_k = [0 0 0 0]';

% input at time k-1
u_k_1 = 0;

% augmented state at time k
X_k = [x_k; u_k_1];

% % reference state - landing position
x_r = [0 0 0 0]';

% prediction horizon
n_p = 30;

% artificial predicted rhos
rho_p = 1/n_p:1/n_p:1;

% control horizon
n_c = 3;

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

% weighting matrices
w_x = [0 0 1 1 0];
w_x1 = w_x;
for i = 1:n_p-1
    w_x = [w_x w_x1];
end
W_x = diag(w_x);

% w_u = ones(1);
% w_u1 = w_u;
% for i = 1:n_c-1
%     w_u = [w_u w_u1];
% end
W_u = eye(n_c);%diag(w_u);

% % reference trajectory (result of kalman filtering but here without kalman filter - testing purposes)
% R = zeros(60,1);

% optimal input 
% before decoupling from global state 
%du = -inv(Phi' * W_y^2 * Phi + W_du^2) * Phi' * W_y^2 * (F * X_k - R);

% after decoupling from global state 
% UU is introduced to reduce online computations (it is invariant)
UU = -inv(Phi1' * W_x * Phi1 + W_u) * Phi1' * W_x;

du = UU * (F * X_k + Phi2 * rho_p');
% where x_r is TF data from AprilTag - here just x_goal - x_current

du_k = du(1);