%% constant input data:
v = 14;
vint = v;
modelInit(v);
global Phi1 Phi2 F nc np gains v

gain = gains(v-7,:);

w_x = gain(2:6);
w_x1 = repmat(w_x,1,np);
W_x = diag(w_x1);
w_u = gain(7)*ones(nc,1)';
W_u = diag(w_u);

Phi1n = Phi1(1:length(w_x):end,:);
Phi2n = Phi2(1:length(w_x):end,:);
Fn = F(1:length(w_x):end,:);

C1 = ones(nc,1);
C2 = tril(ones(nc,nc));

% all experiments for constant speed of 20m/s

% All Constraints 
DuOptAll = [0.0007   -0.0359   -0.0006    0.0005    0.0000   -0.0001   -0.0001   -0.0002   -0.0036    0.0046]';
DuOptSing = [0.0007   -0.0359   -0.0006    0.0005    0.0000   -0.0001   -0.0001   -0.0002   -0.0036    0.0046]';
xk = [-0.2304   -0.0253    0.0260    0.0025    0.0764]';
psiPrim = [0.1798    0.1810    0.1822    0.1834    0.1846    0.1858    0.1870    0.1882    0.1894    0.1906    0.1918    0.1930    0.1942    0.1954    0.1966    0.1978    0.1990    0.2002    0.2014    0.2026    0.2038    0.2049    0.2061    0.2073    0.2085    0.2097    0.2109    0.2121    0.2133    0.2145]';
psiPrim = psiPrim(1:np);

n = length(xk);

% constraints values
umin = -0.5;
umax = 0.5;
dumin = -0.1;
dumax = 0.1;
ymin = -0.45;
ymax = 0.45;

bigNumber = 100000;
singleConstraintNc = [1 bigNumber*ones(1,nc-1)]';
singleConstraintNp = [1 bigNumber*ones(1,np-1)]';


%% NN
numbConstr = 3*nc + 2*np;
gammann = .01000;
tEnd = 1e-2;
sampleTime = tEnd/1000000;


xiM = ones(nc,1)*dumin.*singleConstraintNc;
xiP = ones(nc,1)*dumax.*singleConstraintNc;

% QP variables
Wnn = 2*(Phi1'*W_x*Phi1 + W_u);
qnn = 2*((F*xk)'*W_x*Phi1 + (Phi2*psiPrim)'*W_x*Phi1)';
Ann = [-C2;...
    C2;...
    -Phi1n;...
    Phi1n...
    ];

bnn = [-umin*ones(nc,1) + C1*xk(end);...
    umax*ones(nc,1) - C1*xk(end);...
    -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
    ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
    ];

Hnn = [Wnn  -Ann'; Ann zeros(length(Ann),length(Ann'))];
eyenn = eye(length(Hnn));
pnn = [qnn; -bnn]; 
zetaP = [xiP; bigNumber*ones(length(Ann),1)];   
zetaM = [xiM; bigNumber*zeros(length(Ann),1)];


%% Hildreth

% Eo = 2*(Phi1'*W_x*Phi1 + W_u);
% invEo = inv(Eo);
% Fo = 2*((F*xk)'*W_x*Phi1 + (Phi2*psiPrim)'*W_x*Phi1)';
% 
% 
% % All constraints imposed (only the first state in all cases): 
% Mo = [-eye(nc);...
%     eye(nc);...
%     -C2;...
%     C2;...
%     -Phi1n;...
%     Phi1n...
%     ];
% gamma = [-dumin*ones(nc,1);...
%     dumax*ones(nc,1);...
%     -umin*ones(nc,1) + C1*xk(end);...
%     umax*ones(nc,1) - C1*xk(end);...
%     -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
%     ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
%     ];
% % Du = BookHildreth(Eo,Fo,Mo,gamma,vint);
% 
% % Single constraint on control and its rate: 
% 
% gammaSingleConstraint = [-dumin*ones(nc,1).*singleConstraintNc;...
%     dumax*ones(nc,1).*singleConstraintNc;...
%     (-umin*ones(nc,1) + C1*xk(end)).*singleConstraintNc;...
%     (umax*ones(nc,1) - C1*xk(end)).*singleConstraintNc;...
%     -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
%     ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
%     ];
% Du = BookHildreth(Eo,Fo,Mo,gammaSingleConstraint,vint);


% Single constraint on x1, control and rate: 
% 
% gammaSingleConstraintAll = [-dumin*ones(nc,1).*singleConstraintNc;...
%     dumax*ones(nc,1).*singleConstraintNc;...
%     (-umin*ones(nc,1) + C1*xk(end)).*singleConstraintNc;...
%     (umax*ones(nc,1) - C1*xk(end)).*singleConstraintNc;...
%     (-ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim).*singleConstraintNp;...
%     (ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim).*singleConstraintNp...
%     ];
% Du = BookHildreth(Eo,Fo,Mo,gammaSingleConstraintAll,vint);


%% Solving the ODE maybee
% P(d,dp,dm)
clc
tspan = linspace(0,10);%tEnd/10);
d0 = 0.1*(rand(numbConstr,1)-0.5);
tic

odefun = @(t,y)first_order(t,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann);
efun = @(t,y)odeevent(t,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann);
options = odeset('Events',efun);

z = ode15s(odefun,tspan,d0,options);
% z = ode15s(@(t,d)first_order(t,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann),t,d0,opts);

toc
time = z.x;
d = z.y;
% 
plot(time,d(1:nc,:));

%%%%%% steady state condidtioin
function [x,isterm,dir] = odeevent(~,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann)
    dy = first_order([],d,Hnn,eyenn,zetaP,zetaM,pnn,gammann);
    x = norm(dy) - 1e-5;
    isterm = 1;
    dir = 0;  %or -1, doesn't matter
end
%%%%%%

function dDdt = first_order(~,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann)
    dDdt = zeros(length(Hnn),1);
    dDdt(1:length(Hnn),1) = (gammann*(eyenn+Hnn') * (P(d-(Hnn*d+pnn),zetaP,zetaM) - d));

end

function out = P(d,dp,dm)

    o1 =  min(d,dp);
    out = max(o1,dm);
    
end

