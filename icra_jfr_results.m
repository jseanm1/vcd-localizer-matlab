% clear all
% 
% load icra_jfr_results
sig = sqrt(cov);

figure
hold on
% plot(gt_jfr(1:end,1)*0, '-b')
% plot(gps(70:end-25,1) - gt_jfr(70:end-25,1), '-g')
plot(Pose(2:end,1) - gt_jfr(1:end,1) - 70.2, '-b')
plot(2*sig(1:end,1,1), '-r')
plot(-2*sig(1:end,1,1), '-r')
% legend('Ground Truth X', 'GPS', 'VCD Localizer X', '+-2 Sigma')
legend('VCD Localizer Error X', '+-2 Sigma')
xlabel('Iterations')
ylabel('X(m)')
% print('icra_jfr_x.png', '-dpng', '-r600')

figure
hold on
% plot(gt_jfr(1:end,2)*0, '-b')
% plot(gps(70:end-25,2) - gt_jfr(70:end-25,2), '-g')
plot(Pose(2:end,2) - gt_jfr(1:end,2) - 70.2, '-b')
plot(2*sig(1:end,2,2), '-r')
plot(-2*sig(1:end,2,2), '-r')
% legend('Ground Truth Y', 'GPS', 'VCD Localizer Y', '+-2 Sigma')
legend('VCD Localizer Error Y', '+-2 Sigma')
xlabel('Iterations')
ylabel('Y(m)')
% print('icra_jfr_y.png', '-dpng', '-r600')

figure
hold on
% plot(gt_jfr(1:end,3)*0, '-b')
% plot(gps(70:end-25,3) - gt_jfr(70:end-25,3), '-g')
plot(Pose(2:end,3) - gt_jfr(1:end,3), '-b')
plot(2*sig(1:end,3,3), '-r')
plot(-2*sig(1:end,3,3), '-r')
% legend('Ground Truth Yaw', 'GPS', 'VCD Localizer Yaw', '+-2 Sigma')
legend('VCD Localizer Error Yaw', '+-2 Sigma')
xlabel('Iterations')
ylabel('Yaw(m)')
% print('icra_jfr_yaw.png', '-dpng', '-r600')
hold off

figure
hold on
plot(sig(1:end,1,1), '-r')
plot(sig(1:end,2,2), '-b')
plot(sig(1:end,3,3), '-g')
legend('Sigma X', 'Sigma Y', 'Sigma Yaw')
xlabel('Iterations')
ylabel('Sigma(m)')
