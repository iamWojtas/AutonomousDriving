%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference longitudinal velocity generator and lateral MPC controller 
% author: Wojciech Stróżecki 2021 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u] = MPC_Controls(in)

    global F Phi2 np nc gains Phi1 v    
    
    % reference goal speed based on the curvature
    curvature = in(1:np);
    
    % Curvature dependance
    kappa = max(abs(curvature));
    if kappa <= 0.0032
        vref = 35;
    else
        vref = sqrt(0.4*9.81/kappa);
    end
    
    % actual speed
    velocity = in(30+2);
    
    if velocity >= 9
        vint = int8(velocity)
    else
        vint = int8(9)
    end
    
    % NN speed 
%     vint = int8(v);
    
    % state extrac
    X_k = in(30+3:30+7); % X_k = [x_k u_k]
    psiPrim = curvature.*velocity;

    % adjusting the vehicle dynamical model to the current speed: F Phi1 Phi2
    modelInit(double(vint));
    gain = gains(vint-7,:);
    gain = gains(20-7,:);
    
    if vint == 15
        cokolwiek = 420;
    end
    % constrained control:
    fu = MPC_Constrained_Control(Phi1,Phi2,F,np,nc,gain,X_k,psiPrim,vint);


    
%     % unconstrained control: UU computation 
%     computeGain(gains(vint-7,:));
%     Du = UU * (F * X_k + Phi2 * psiPrim);
%     du = double(Du(1,1));
%     fu = du + X_k(end); 
    
    % model singularity avoidance
    if velocity <= 1
        fu = 0;    
    elseif length(fu(1,1)) ~=1
        fu = 2137;
    end
    
    u = [fu; vref];


end

