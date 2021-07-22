% %% paper examples
Wnn = [22 -2 6; -2 2 0; 6 0 2];
Ann = [-1 1 0; 3 0 1];
Jnn = [2 2 1];

dnn = 0;
bnn = [-1;4];
qnn = [-4 0 0]';

xiP = [6;6;6];
xiM = -[6;6;6];

gammann = 1000;
numbConstr = 6;
%% my simulation:) input constants
v = 20;
modelInit(v);
global Phi1 Phi2 F nc np gains

gain = gains(v-7,:);

w_x = gains(2:6);
w_x1 = repmat(w_x,1,np);
W_x = diag(w_x1);
w_u = gains(7)*ones(nc,1)';
W_u = diag(w_u);

Phi1n = Phi1(1:length(w_x):end,:);
Phi2n = Phi2(1:length(w_x):end,:);
Fn = F(1:length(w_x):end,:);

% all experiments for constant speed of 20m/s

%Du for all constraints 150 iterations
duOpt = [0.0059    0.1000    0.1000   -0.0098   -0.0542    0.0055    0.0061 -0.0313   -0.0138    0.1000]';
xk = [0.4172    0.4707   -0.0673   -0.0902   -0.1989]';
psiPrim = [-0.3729 -0.3500 -0.3272 -0.3043 -0.2815 -0.2586 -0.2358 -0.2129 -0.1901 -0.1672 -0.1444 -0.1215 -0.0987 -0.0758 -0.0530 -0.0301 -0.0073 0.0156 0.0384 0.0613 0.0841 0.1070 0.1298 0.1527 0.1755 0.1984 0.2212 0.2441 0.2669 0.2898]';

n = length(xk);

% constraints values
umin = -0.5;
umax = 0.5;
dumin = -0.1;
dumax = 0.1;
ymin = -0.45;
ymax = 0.45;


%% 

singleConstraintNc = [1 bigNumber*ones(1,nc-1)]';
xiM = ones(nc,1)*dumin;%.*singleConstraintNc;
xiP = ones(nc,1)*dumax;%.*singleConstraintNc;

% QP variables
C1 = ones(nc,1);
C2 = tril(ones(nc,nc));
Wnn = 2*(Phi1'*W_x*Phi1 + W_u);
qnn = 2*((F*xk)'*W_x*Phi1 + (Phi2*psiPrim)'*W_x*Phi1)';
Ann = [-C2;...
    C2;...
    -Phi1n;...
    Phi1n...
    ];

% % bnn for x1 constrained only
numbConstr = 3*nc + 2*np;

bnn = [-umin*ones(nc,1) + C1*xk(end);...
    umax*ones(nc,1) - C1*xk(end);...
    -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
    ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
    ];

gammann = 10000;
bigNumber = 100000;


%% variables for simplified simulink

tEnd = 0.00001;
Hnn = [Wnn  -Ann'; Ann zeros(length(Ann),length(Ann'))];
eyenn = eye(length(Hnn));
pnn = [qnn; -bnn]; 
zetaP = [xiP; bigNumber*ones(length(Ann),1)];   
zetaM = [xiM; bigNumber*zeros(length(Ann),1)];


%% variables for simplified simulink paper examples
% bigNumber = 10000;
tEnd = 0.1;
Hnn = [Wnn -Jnn' Ann'; Jnn zeros(1,length([-Jnn' Ann'])); -Ann zeros(2,length([-Jnn' Ann']))];
eyenn = eye(length(Hnn));
pnn = [qnn; -dnn; bnn];
zetaP = [xiP; bigNumber*ones(1,1); bigNumber*ones(2,1)];
zetaM = [xiM; -bigNumber*ones(1,1); zeros(2,1)];
%% simulation 

tic
% l ogsss = sim('LVI_PDNN_for_QP');
toc

%%

% 
% du(1)
% du(2)
% du(3)
% du(4)
% du(5)
% du(6)
% du(7)
% du(8)
% du(9)
% du(10)

