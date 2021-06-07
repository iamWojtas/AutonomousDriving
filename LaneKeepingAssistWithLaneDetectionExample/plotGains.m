



figure('Name','Controller Performance','position',[100 100 720 600]);
% theta 1
subplot(3,2,1);
plot(gains(:,1),gains(:,2))
title('Theta 1')
xlabel('Speed (m/s)')
ylabel('Value')

% theta 1
subplot(3,2,2);
plot(gains(:,1),gains(:,3))
title('Theta 2')
xlabel('Speed (m/s)')
ylabel('Value')

% theta 1
subplot(3,2,3);
plot(gains(:,1),gains(:,4))
title('Theta 3')
xlabel('Speed (m/s)')
ylabel('Value')

% theta 1
subplot(3,2,4);
plot(gains(:,1),gains(:,5))
title('Theta 4')
xlabel('Speed (m/s)')
ylabel('Value')

% theta 1
subplot(3,2,5);
plot(gains(:,1),gains(:,6))
title('Theta 5')
xlabel('Speed (m/s)')
ylabel('Value')

% theta 1
subplot(3,2,6);
plot(gains(:,1),gains(:,7))
title('Theta 6')
xlabel('Speed (m/s)')
ylabel('Value')




