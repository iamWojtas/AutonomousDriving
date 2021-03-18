function out = unicycle(in)
% Input: velocities of the robot platform [v_x; omega]
% Output: velocities in the global frame [x'; y'; theta']

    th = in(3);
    u = [in(4) ; in(5)];
    
    dq = [cos(th) 0; sin(th) 0; 0 1]*u;
    
    out = dq;
return;