sig = sqrt(cov);
% 
% figure
% 
% imshow(imcomplement(map));
% hold on
% 
% plot((gt_jfr(50:140,1)+130)/0.05, (gt_jfr(50:140,2)+113)/0.05, '-xb')
% plot(Pose(2:92,1)/0.05, Pose(2:92,2)/0.05, 'xr')
% plot(Pose(2:21,1)/0.05, Pose(2:21,2)/0.05, '-r')
% plot(Pose(25:50,1)/0.05, Pose(25:50,2)/0.05, '-r')
% plot(Pose(70:89,1)/0.05, Pose(70:89,2)/0.05, '-r')
% legend('RTK-GPS Pose', 'VCD Pose', 'VCD Trajectory')

% figure
% hold on
% plot(Pose(2:92,1) - gt_jfr(50:140,1) - 130, '-r')
% plot(2*sig(1:91,1,1), '-b')
% plot(-2*sig(1:91,1,1), '-b')

figure

subplot(3,1,1)
hold on
plot(1:19, Pose(2:20,1) - gt_jfr(50:68,1) - 130, '-r')
plot(1:19, 2*sig(1:19,1,1), '-b')
plot(1:19, -2*sig(1:19,1,1), '-b')
plot(25:49, Pose(26:50,1) - gt_jfr(74:98,1) - 130, '-r')
plot(25:49, 2*sig(25:49,1,1), '-b')
plot(25:49, -2*sig(25:49,1,1), '-b')
plot(70:89, Pose(71:90,1) - gt_jfr(119:138,1) - 130, '-r')
plot(70:89, 2*sig(70:89,1,1), '-b')
plot(70:89, -2*sig(70:89,1,1), '-b')
xlabel('Localization Step')
ylabel('Error - X(m)')

subplot(3,1,2)
hold on
plot(1:19, Pose(2:20,2) - gt_jfr(50:68,2) - 113, '-r')
plot(1:19, 2*sig(1:19,2,2), '-b')
plot(1:19, -2*sig(1:19,2,2), '-b')
plot(25:49, Pose(26:50,2) - gt_jfr(74:98,2) - 113, '-r')
plot(25:49, 2*sig(25:49,2,2), '-b')
plot(25:49, -2*sig(25:49,2,2), '-b')
plot(70:89, Pose(71:90,2) - gt_jfr(119:138,2) - 113, '-r')
plot(70:89, 2*sig(70:89,2,2), '-b')
plot(70:89, -2*sig(70:89,2,2), '-b')
xlabel('Localization Step')
ylabel('Error - Y(m)')

subplot(3,1,3)
hold on
plot(1:19, Pose(2:20,3) - gt_jfr(50:68,3) - pi+0.6632, '-r')
plot(1:19, 2*sig(1:19,3,3), '-b')
plot(1:19, -2*sig(1:19,3,3), '-b')
plot(25:49, Pose(26:50,3) - gt_jfr(74:98,3) - pi+0.6632, '-r')
plot(25:49, 2*sig(25:49,3,3), '-b')
plot(25:49, -2*sig(25:49,3,3), '-b')
plot(70:89, Pose(71:90,3) - gt_jfr(119:138,3) - pi+0.6632, '-r')
plot(70:89, 2*sig(70:89,3,3), '-b')
plot(70:89, -2*sig(70:89,3,3), '-b')
xlabel('Localization Step')
ylabel('Error - Yaw(rad)')

legend('Error', '\pm2\sigma')

% figure
% hold on
% plot(Pose(2:21,2) - gt_jfr(50:69,2) - 113, '-r')
% plot(2*sig(1:20,2,2), '-b')
% plot(-2*sig(1:20,2,2), '-b')
% 
% figure
% hold on
% plot(Pose(2:21,3) - gt_jfr(50:69,3) - pi+0.6632, '-r')
% plot(2*sig(1:20,3,3), '-b')
% plot(-2*sig(1:20,3,3), '-b')

