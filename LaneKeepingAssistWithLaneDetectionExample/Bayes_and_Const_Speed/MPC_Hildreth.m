function u = MPC_Hildreth(Phi1,Phi2,F,np,nc,gain,xk,psiPrim,vint)
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
%% Hildreths
%     if vint < 20

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

        singleConstraint = [1 100000*ones(1,nc-1)]';
        gammaSingleConstraint = [-dumin*ones(nc,1).*singleConstraint;...
            dumax*ones(nc,1).*singleConstraint;...
            (-umin*ones(nc,1) + C1*xk(end)).*singleConstraint;...
            (umax*ones(nc,1) - C1*xk(end)).*singleConstraint;...
            -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
            ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
            ];

    %% Solving QP with Hildreth

        Du = BookHildreth(Eo,Fo,Mo,gamma,vint);
        du = Du(1,1);

        u = du + xk(end);
%     end
    
    %% NN
%     if vint == 20
%         
%         tEnd = 1e-7;
%         
%         numbConstr = 3*nc + 2*np;
%         gammann = 10000;
%         bigNumber = 100000;
%         singleConstraint = [1 bigNumber*ones(1,nc-1)]';
%         
%         xiM = ones(nc,1)*dumin;%.*singleConstraint;
%         xiP = ones(nc,1)*dumax;%.*singleConstraint;
%         
%         C1 = ones(nc,1);
%         C2 = tril(ones(nc,nc));
%         Wnn = 2*(Phi1'*W_x*Phi1 + W_u);
%         qnn = 2*((F*xk)'*W_x*Phi1 + (Phi2*psiPrim)'*W_x*Phi1)';
%         Ann = [-C2;...
%             C2;...
%             -Phi1n;...
%             Phi1n...
%             ];
%         bnn = [-umin*ones(nc,1) + C1*xk(end);...
%             umax*ones(nc,1) - C1*xk(end);...
%             -ymin*ones(np,1) + Fn*xk + Phi2n*psiPrim;...
%             ymax*ones(np,1) - Fn*xk - Phi2n*psiPrim...
%             ];
%         Hnn = [Wnn  -Ann'; Ann zeros(length(Ann),length(Ann'))];
%         eyenn = eye(length(Hnn));
%         pnn = [qnn; -bnn]; 
%         zetaP = [xiP; bigNumber*ones(length(Ann),1)];   
%         zetaM = [xiM; bigNumber*zeros(length(Ann),1)];
% %         options = simset('SrcWorkspace','current');
% %         sim('modelname',[],options)
%         
%         logsss = sim('LVI_PDNN_for_QP2', 'SrcWorkspace', 'current','timeout',10);
%         Du = logsss.logsout.getElement('du');
%         du = Du.Values.Data(1,:,end);
%         u = du + xk(end);
%     end
% % u = 0;	

%% data collection for NN validation
%     if vint == 15
%         cokolwwiek = 2137;
%     end
%% Important program features
    fi_ut = 14.5;
end

