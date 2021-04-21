function [outputArg1,outputArg2] = computeGain(in)

    global UU Phi1 n_p
    
    w_x = [in, 1];
    w_x1 = repmat(w_x,1,n_p);
    W_x = diag(w_x1);

    W_u = ones(10,1)';

    UU = -inv(Phi1' * W_x * Phi1 + W_u) * Phi1' * W_x;


end

