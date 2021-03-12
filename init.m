clc

global cr cf lr lf m v iz ls 

% model data used in matlab example LKA model
% open_system('LKATestBenchExample')

lr = 1.2;
lf = 1.6;
ls = 1.9;

cf = 19000; %198000;
cr = 33000; %470000;

m = 1575;
iz = 2875; %10.85 * m;

v = 13.9;

a11 = 2*(cr + cf)/(m*v);
a12 = -1 + 2*(lr*cr - lf*cf)/(m*v^2);                                      
a21 = 2*(lr*cr - lf*cf)/iz;
a22 = -2*(lr^2*cr - lf^2*cf)/(iz*v);

% A = [a11 a12 0 0;...
%     a21 a22 0 0;...
%     0 1 0 0;...
%     v ls v 0];

A = [a11 a12 0 0;...
    a21 a22 0 0;...
    0 1 0 0;...
    v ls v 0];


B = [2*cf/(m*v) 0; 2*lf*cf/iz 0; 0 -v ;0  0];

C = [0 0 1 0; 0 0 0 1];

D = zeros(2,2);

sys = ss(A,B,C,D);
% R = eye(2);
% Q = diag([1,1,5,5]);
% [Kd,S,e] = lqrd(A,B,Q,R,Ts) 
% d_sys = c2d(sys,Ts);
% 
% A = d_sys.A;
% B = d_sys.B;
% C = d_sys.C;
% D = d_sys.D;


kp = -[0,0,0.045,0.085]; % ls = 1.9
K = place(A,B,kp);

kl = kp.*120;
L = place(A',C',kl);

K
L

% plotting birdseye:
% plotLKAResults(scenario,logsout,driverPath)
% plotLKAPerformance(logsout)

