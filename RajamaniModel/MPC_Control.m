function [u] = MPC_Control(in)

    global UU F Phi2 n_p 
    
    rho_p = in(1:n_p);
    X_k = in(n_p+1:n_p+5); % X_k = [x_k u_k]
    
    du = UU * (F * X_k + Phi2 * rho_p);
    
    
    u = du(1);
end

