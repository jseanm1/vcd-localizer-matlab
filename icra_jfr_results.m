clear all

load icra_jfr_results

sig = sqrt(cov);

figure
hold on
plot(gt_jfr(70:end-25,1)*0, '-b')
plot(gps(70:end-25,1) - gt_jfr(70:end-25,1), '-g')
plot(Pose(2:end-25,1) - gt_jfr(70:end-25,1) - 70.2, '-r')
plot(2*sig(1:119,1,1), '-k')
plot(-2*sig(1:119,1,1), '-k')
legend('Ground Truth X', 'GPS', 'VCD Localizer X', '+-2 Sigma')
xlabel('Iterations')
ylabel('X(m)')
print('icra_jfr_x.png', '-dpng', '-r600')

figure
hold on
plot(gt_jfr(70:end-25,2)*0, '-b')
plot(gps(70:end-25,2) - gt_jfr(70:end-25,2), '-g')
plot(Pose(2:end-25,2) - gt_jfr(70:end-25,2) - 70.2, '-r')
plot(2*sig(1:119,2,2), '-k')
plot(-2*sig(1:119,2,2), '-k')
legend('Ground Truth X', 'GPS', 'VCD Localizer Y', '+-2 Sigma')
xlabel('Iterations')
ylabel('Y(m)')
print('icra_jfr_y.png', '-dpng', '-r600')

figure
hold on
plot(gt_jfr(70:end-25,3)*0, '-b')
plot(gps(70:end-25,3) - gt_jfr(70:end-25,3), '-g')
plot(Pose(2:end-25,3) - gt_jfr(70:end-25,3), '-r')
plot(2*sig(1:119,3,3), '-k')
plot(-2*sig(1:119,3,3), '-k')
legend('Ground Truth X', 'GPS', 'VCD Localizer Yaw', '+-2 Sigma')
xlabel('Iterations')
ylabel('Yaw(m)')
print('icra_jfr_yaw.png', '-dpng', '-r600')
hold off

imshow(imcomplement(map))
hold on
plot(gt_jfr(70:end-25,1)/0.05 + 1404,gt_jfr(70:end-25,2)/0.05 + 1404, '-b')
plot(gps(70:end-25,1)/0.05 + 1404, gps(70:end-25,2)/0.05 + 1404, '-g')
plot(Pose(2:end-25,1)/0.05, Pose(2:end-25,2)/0.05, '-r')
zoom(1.8)
print('icra_jfr_path.png', '-dpng', '-r600')