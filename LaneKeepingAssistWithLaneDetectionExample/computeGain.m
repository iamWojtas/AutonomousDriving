function [outputArg1,outputArg2] = computeGain(in)

    global UU Phi1 np
    
    w_x = in(2:6);
    w_x1 = repmat(w_x,1,np);
    W_x = diag(w_x1);

    W_u = in(7)*ones(10,1)';

    UU = -inv(Phi1' * W_x * Phi1 + W_u) * Phi1' * W_x;


end

