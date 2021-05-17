function out = modelInit(vdouble)

    global Ts F Phi1 Phi2 np nc   

    lr = 1.2;
    lf = 1.6;
    ls = 0;

    Cf = 19000; 
    Cr = 33000; 

    m = 1575;
    Iz = 2875; 

    cr = Cr;
    cf = Cf;
    iz = Iz;

    a22 = -2*(cr + cf)/(m*vdouble);
    a23 = 2*(cr + cf)/m;
    a24 = -2*(lf*cf - lr*cr)/(m*vdouble);                                      
    a42 = -2*(lf*cf - lr*cr)/(iz*vdouble);
    a43 = 2*(lf*cf - lr*cr)/iz;
    a44 = -2*(lr^2*cr + lf^2*cf)/(iz*vdouble);


    Ac = [0 1 0 0;
        0 a22 a23 a24;
        0 0 0 1;
        0 a42 a43 a44];

    B1c = [0; 2*cf/m; 0; 2*lf*cf/iz];

    b2 = -2*(lf*cf - lr*cr)/(m*vdouble) -     vdouble; % a24 -vdouble
    b4 = -2*(lr^2*cr + lf^2*cf)/(iz*vdouble); % a44
    B2c = [0;  b2; 0; b4];

    Bc = [B1c B2c];
    Cc = eye(4);
    Dc = zeros(4,2);


    c_sys = ss(Ac,Bc,Cc,Dc);

    d_sys = c2d(c_sys,Ts,'');

    A = d_sys.A;
    B = d_sys.B;
    B1 = B(:,1);
    B2 = B(:,2);
    C = d_sys.C;
    D = d_sys.D;


    % augmented matrices
    AA = [A B1 ; zeros(1,4) 1];
    BB1 = [B1 ; 1];
    BB2 = [B2 ; 0];

    % state at time k
    x_k = [0 0 0 0]';

    % input at time k-1
    u_k_1 = 0;

    % augmented state at time k
    X_k = [x_k; u_k_1];

    % prediction horizon
    
%     np = 30;
%     % control horizon
%     nc = 10;

    % 
    % AA = magic(2);
    % BB1 = [1;0];
    % BB2 = [1;0];


    % tic
    % % F matrix 
    % F = AA;
    % for i = 2:n_p
    %     F = [F; AA^i];
    % end
    % disp(toc)

    % tic
    F = powerConcat(AA,np);
    % disp(toc)



    % Phi1 matrix

    % tic
    % Phi1 = BB1;
    % for i = 1:n_p-1
    %     Phi1 = [Phi1; AA^i*BB1];
    % end
    % for i = 1:n_c-1
    %     aa = [zeros(i*size(AA,1) , 1) ; Phi1(1:(size(AA,1)*(n_p - i)) , 1)];
    %     Phi1 = [Phi1 aa];
    % end
    % 
    % % Phi2 matrix
    % Phi2 = BB2;
    % for i = 1:n_p-1
    %     Phi2 = [Phi2; AA^i*BB2];
    % end
    % for i = 1:n_p-1
    %     aa = [zeros(i*size(AA,1) , 1) ; Phi2(1:(size(AA,1)*(n_p - i)) , 1)];
    %     Phi2 = [Phi2 aa];
    % end




    % disp(toc)
    % disp('tera nowosc:')
    % tic
    Phi1 = powerConcat(AA,np,BB1,nc);
    Phi2 = powerConcat(AA,np,BB2,np);
    % disp(toc)
    % 
    % % error in computatino
    % sum(sum(abs(Phi1-Phi11)))
    % sum(sum(abs(Phi2-Phi21)))
end



function F = powerConcat(M,p,N,c)

    if nargin == 2
        F = zeros([size(M,1)*p,size(M,2)]);

        for i = 1:p
            F(size(M,2)*(i-1)+1 : size(M,2)*i     ,:) = M^i;
        end
    elseif nargin == 4
        
        F = zeros([size(M,1)*p,  size(N,2)*c]);
        F(1:size(N,1),1:size(N,2)) = N;
        for i = 2:p
            F(size(M,2)*(i-1)+1 : size(M,2)*i,  1:size(N,2)) = M^(i-1)*N;
        end
 
        for i = 1:c-1
            F(size(M,2)*i+1 :   end   , size(N,2)*i+1  : size(N,2)*(i+1)) =...
            F(1 : size(M,2)*(p-i)   , 1:size(N,2));
        end        
    end
end


