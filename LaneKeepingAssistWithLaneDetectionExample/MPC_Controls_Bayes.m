%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lateral MPC controller for Bayesian Optimization or constant velocity
% case
% author: Wojciech Stróżecki 2021 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = MPC_Controls_Bayes(in)

    global F Phi2 np nc gains Phi1 UU
    
    % reference goal speed based on the curvature
    curvature = in(1:np);

    % actual speed
    velocity = in(30+2);
    
    % state
    X_k = in(30+3:30+7); % X_k = [x_k u_k]
    psiPrim = curvature.*velocity;

%     % unconstrained control:
%     Du = UU * (F * X_k + Phi2 * psiPrim);
%     du = double(Du(1,1));
%     fu = du + X_k(end); 

    % constrained control:
    
    % gain contains one set of 6 gains
%     % the case for optimal set:
%     gain = gains(vint-7,:);

    % the case for Bayesian Optimization (UU)
    gain = UU;
    fu = MPC_Constrained_Control(Phi1,Phi2,F,np,nc,gain,X_k,psiPrim);
    u = [fu; 1];
    
    
end

