function out = CreateNnMatrices(in)

    global F Phi2 np nc gains Phi1 
    
    % reference goal speed based on the curvature
    curvature = in(1:np);

    % actual speed
    velocity = in(30+2);
    
    if velocity >= 9
        vint = int8(velocity);
    else
        vint = int8(9);
    end
    
    % state
    X_k = in(30+3:30+7); % X_k = [x_k u_k]
    psiPrim = curvature.*velocity;
    gain = gains(vint-7,:);
    
    % controller's gains 
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
    ymin = -0.25;
    ymax = 0.25;

    % create NN matrices
    numbConstr = 3*nc + 2*np;
    gammann = 10000;
    bigNumber = 100000;
    singleConstraint = [1 bigNumber*ones(1,nc-1)]';

    xiM = ones(nc,1)*dumin;%.*singleConstraint;
    xiP = ones(nc,1)*dumax;%.*singleConstraint;

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
    
    out = [Hnn, eyenn, zetaP, zetaM, pnn];
    
    
end

