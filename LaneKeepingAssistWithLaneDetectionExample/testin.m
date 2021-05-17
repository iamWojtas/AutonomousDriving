
% M = 2*ones(3,5);
% p = 2;
% % Or call your function:
% F = powerConcat(M,p)
% assert(isequal(powerConcat(M,p),F))
% % 
% % 
% function F = powerConcat(M,p)
%     power = repelem(1:p,size(M,1),size(M,2));
%     M = repmat(M,1,p);
%     F = M.^power
% end
clc
p = 30;
c = 10;
M = magic(5);
N = [1:5]';
% F = zeros([size(a),p])

F = powerConcat(M,p,N,p)

function F = powerConcat(M,p,N,c)

    if nargin == 2
        F = zeros([size(M,1)*p,size(M,2)]);

        for i = 1:p
            F(size(M,2)*(i-1)+1 : size(M,2)*i     ,:) = M^i;
        end
    elseif nargin == 4
        
        F = zeros([size(M,1)*p,  size(N,2)*c]);
        
        for i = 1:p
            F(size(M,2)*(i-1)+1 : size(M,2)*i,  1:size(N,2)) = M^i*N;
        end
 
        for i = 1:c-1
            1 : size(M,2)*(c-i)
            F(size(M,2)*i+1 :   end   , size(N,2)*i+1  : size(N,2)*(i+1)) =...
            F(1 : size(M,2)*(p-i)   , 1:size(N,2));
        end        
    end
end
