function u = MPC_NN(Phi1,Phi2,F,np,nc,gain,xk,psiPrim,vint)

    global v nc

    %     global Hnn zetaP zetaM pnn eyenn pupa
    w_x = gain(2:6);
    w_x1 = repmat(w_x,1,np);
    W_x = diag(w_x1);
    w_u = gain(7)*ones(nc,1)';
    W_u = diag(w_u);

    % constraints on x1 only require transformation og F, Phi1 and Phi2 m-x
    Phi1n = Phi1(1:length(w_x):end,:);
    Phi2n = Phi2(1:length(w_x):end,:);
    Fn = F(1:length(w_x):end,:);

    % constraints values
    umin = -0.5;
    umax = 0.5;
    dumin = -0.1;
    dumax = 0.1;
    ymin = -0.45;
    ymax = 0.45;
    
    %% NN
        
    tEnd = 1e-7;

    numbConstr = 3*nc + 2*np;
    gammann = 1000000000000000;
    bigNumber = 10000000000000000;
    singleConstraint = [1 bigNumber*ones(1,nc-1)]';

    xiM = ones(nc,1)*dumin.*singleConstraint;
    xiP = ones(nc,1)*dumax.*singleConstraint;

    C1 = ones(nc,1);
    C2 = tril(ones(nc,nc));
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
%         options = simset('SrcWorkspace','current');
%         sim('modelname',[],options)

    %% NN solving
    tspan = linspace(0,.0000000000001);%tEnd/10);
    d0 = .1*(rand(numbConstr,1)-0.5);

    odefun = @(t,y)first_order(t,y,Hnn,eyenn,zetaP,zetaM,pnn,gammann);

    xoverFcn = @(T, Y) MyEventFunction(T, Y);
    options = odeset('Events',xoverFcn);
    du = 10;
    counter =0;
    while du > dumax || du < dumin
        tic
        z = ode15s(odefun,tspan,d0,options);
        d = z.y;
        du = d(1,end);
        
        counter = counter + 1;
        if counter > 1
            disp('asda111');
            du = 0;
        end
    end
%     hold off
%     plot(1:length(d),d(1:nc,:));   
%     disp(d(1,end));
    u = du + xk(end);
        %% simulink solving
%         sampleTime = 0.1;
%         logsss = sim('LVI_PDNN_for_QP2', 'SrcWorkspace', 'current','timeout',10);
%         Du = logsss.logsout.getElement('du');
%         du = Du.Values.Data(1,:,end);
%         u = du + xk(end);



%% data collection for NN validation
    if vint == 15
        cokolwwiek = 2137;
    end
%% Important program features
    fi_ut = 14.5;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dDdt = first_order(~,d,Hnn,eyenn,zetaP,zetaM,pnn,gammann)
    dDdt = zeros(length(Hnn),1);
    dDdt(1:length(Hnn),1) = (gammann*(eyenn+Hnn') * (P(d-(Hnn*d+pnn),zetaP,zetaM) - d));

end

function out = P(d,dp,dm)

    o1 =  min(d,dp);
    out = max(o1,dm);

end

function [VALUE, ISTERMINAL, DIRECTION] = MyEventFunction(T, Y)

    TimeOut = .05;
    VALUE = toc-TimeOut;
    ISTERMINAL = 1;
    DIRECTION = 0;
end
