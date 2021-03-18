%plot(q(:,1),q(:,2)) 
%plot(ans.q(:,1),ans.q(:,2)) 
figure('Name','Controller Performance','position',[100 100 720 600],'Color','white')

hold off

subplot(2,2,1);
plot(ans.q(:,1),ans.q(:,2)) 
title('Trajectory')

subplot(2,2,2); 
plot(ans.q1(:))
title('Steering angle')


subplot(2,2,3); 
plot(ans.tout(:),ans.q(:,2))
hold on
plot(ans.tout(:),ans.q(:,3))
title('Tracking error')



