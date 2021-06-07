function u = MPC_Constrained_Control(Phi1,Phi2,F,np,nc,gains,xk,psiPrim)

    w_x = gains(2:6);
    w_x1 = repmat(w_x,1,np);
    W_x = diag(w_x1);
    w_u = gains(7)*ones(nc,1)';
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
    ymin = -0.35;
    ymax = 0.35;

    % QP variables
    C1 = ones(nc,1);
    C2 = tril(ones(nc,nc));
    Eo = 2*(Phi1'*W_x*Phi1 + W_u);
%     invEo = inv(Eo);
    Fo = 2*((F*xk)'*W_x*Phi1 + (Phi2*psiPrim)'*W_x*Phi1)';
    Mo = [-eye(nc);...
        eye(nc);...
        -C2;...
        C2;...
        -Phi1n;...
        Phi1n...
        ];
    gamma = [-dumin*ones(nc,1);...
        dumax*ones(nc,1);...
        -umin*ones(nc,1) + C1*xk(end);...
        umax*ones(nc,1) - C1*xk(end);...
        -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
        ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
        ];
    
    % Iterative constraint violation check
%     lambda = -inv(Mo*invEo*Mo')*(gamma + Mo*invEo*Fo');
%     find(lambda >= 0)





% Solving QP with Active set - will break for more than nc active constraints:
% %     if all(lambda < 0)
%     if det(Mo*(Eo\Mo')) <= 0
%         Du = -invEo*Fo';
%         du = Du(1,1);
%         u = du + xk(end);
%     else
%         lambda = -inv(Mo*invEo*Mo')*(gamma + Mo*invEo*Fo');
%         while ~all(lambda >= 0)
%             act = find(lambda >= 0);
%             gammaact = gamma(act,:);
%             Moact = Mo(act,:);
%             lambda = -inv(Moact*invEo*Moact')*(gammaact + Moact*invEo*Fo');
%         end
%         Du = -invEo*(Fo + Moact*lambda);
%         du = Du(1,1);
%         u = du + xk(end); 
%     end

% Solving QP with Hildreth
    Du = BookHildreth(Eo,Fo,Mo,gamma);
    du = Du(1,1);
    u = du + xk(end);
% Important program features
    fi_ut = 14.5;
end

