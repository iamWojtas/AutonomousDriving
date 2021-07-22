% P=A_cons*(H\A_cons');
% d=(A_cons*(H\f)+b);
% [n,m]=size(d);
% x_ini=zeros(n,m);
% lambda=x_ini;
% al=10;
% 
% for km=1:38
%     
%     %find the elements in the solution vector one by one
%     % km could be larger if the Lagranger multiplier has a slow
%     % convergence rate.
%     lambda_p=lambda;
%     for i=1:n
%         w= P(i,:)*lambda-P(i,i)*lambda(i,1);
%         w=w+d(i,1);
%         la=-w/P(i,i);
%         lambda(i,1)=max(0,la);
%         endal=(lambda-lambda_p)'*(lambda-lambda_p);
%         if (al<10e-8)
%             break;
%         end
%     end
% end

function eta = BookHildreth(H,f,A_cons,b,vint)

%     E=H;
%     F=f;
%     M=A_cons;
%     gamma=b;
%     eta =x;
    [n1,m1]=size(A_cons);
    eta=-H\f;
    kk=0;

    for i=1:n1
        if  (A_cons(i,:)*eta>b(i))
            kk=kk+1;
        else
            kk=kk+0;
        end
    end
    
    if (kk==0)
        return;
    end
        
   
    P=A_cons*(H\A_cons');
    d=(A_cons*(H\f)+b);
    [n,m]=size(d);
    x_ini=zeros(n,m);
    lambda=x_ini;
    al=10;
    iterator = 0;
    etaPlot = zeros(10,10000);

    for km=1:10000
    
        %find the elements in the solution vector one by one
        % km could be larger if the Lagranger multiplier has a slow
        % convergence rate.
        lambda_p=lambda;
        
        
%         % plotting the convergence pt 1/2
%         if vint == 20
%             etaPlot(:,km)=-H\f -H\A_cons'*lambda;
%             iterator = iterator + 1;
%         end
        
        for i=1:n
            w= P(i,:)*lambda-P(i,i)*lambda(i,1);
            w=w+d(i,1);
            la=-w/P(i,i);
            lambda(i,1)=max(0,la);
        end
        
        al=(lambda-lambda_p)'*(lambda-lambda_p);
%         % plotting the convergence pt 1/2
%             if vint == 20 && iterator > 100 && iterator < 200
%                 etaPlot = etaPlot(:,1:iterator);
%                 plot(etaPlot')
%                 cokolwiek = 123 ;
%             end% 
        if (al<10e-8)
            break;
        end
        
    end
    eta=-H\f -H\A_cons'*lambda; 
end