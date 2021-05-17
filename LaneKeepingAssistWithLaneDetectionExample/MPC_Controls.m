function [u] = MPC_Controls(in)

%     global UU F Phi2 n_p Ts philip curva
%     philip = in;
%     if any(isnan(in), 'all')
%         philip = 2137
%         sim('LKATestBenchExample')
%     end
%     curTime = get_param('LKATestBenchExample','SimulationTime') *10;
% %     curvature = in(1:n_p);
%     curTime = cast(curTime ,'uint16');
% 
%     curvature = curva(1 + curTime : curTime + n_p);
%     velocity = in(30+2);
%     X_k = in(30+3:30+7); % X_k = [x_k u_k]
%     
%     
%     psiPrim = curvature.*velocity;
%     
%     du = UU * (F * X_k + Phi2 * psiPrim);
% 
%     
%     u = double(du(1,1));
%     if length(u(1,1)) ~=1
%         u = 2137;
%     end

    global UU F Phi2 np  Ts philip  gains Phi1 v        
    % reference goal speed based on the curvature
    curvature = in(1:np);
    
    % Curvature dependance
    kappa = max(abs(curvature));
    if kappa <= 0.0047
        vref = 29;
    else
        vref = sqrt(0.4*9.81/kappa);
    end
    
    % actual speed
    velocity = in(30+2);
    
    if velocity >= 8
        vint = int8(velocity)
    else
        vint = int8(8)
    end
    
%     gains(vint-7,:)
    modelInit(double(vint));
    computeGain(gains(vint-7,:));
    
    
    % state
    X_k = in(30+3:30+7); % X_k = [x_k u_k]
    
    psiPrim = curvature.*velocity;
    
    du = UU * (F * X_k + Phi2 * psiPrim);


    
    u = double(du(1,1));
    
    if velocity <= 1
        u = 0;    
    elseif length(u(1,1)) ~=1
        u = 2137;
    end
    u = [u; vref];
%     philip = in;
%     if any(isnan(in), 'all')
%         philip = 2137
%         sim('LKATestBenchExample')
%     end

end

