function [u] = MPC_Control(in)

    global UU F Phi2 n_p 
    
    curvature = in(1:n_p);
    velo = in(n_p+2);
    X_k = in(n_p+3:n_p+7); % X_k = [x_k u_k]
    
    
    psiPrim = curvature.*velo;
    
    du = UU * (F * X_k + Phi2 * psiPrim);
    
    u = du(1);
end

