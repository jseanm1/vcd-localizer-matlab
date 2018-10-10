load icra_hospital_skip5_std30cm
sig = sqrt(cov)*5;

figure

subplot(3,1,1)
hold on
% plot(GT_odom(45:8117+44,2), '-b')
plot(GT_odom(45:5:end-1,1), Pose(2:end,1) - GT_odom(45:5:end-1,2) - 12.8751, '-r')
plot(GT_odom(45:5:end-1,1), 2*sig(1:end,1,1), '-b')
plot(GT_odom(45:5:end-1,1), -2*sig(1:end,1,1), '-b')
xlabel('Time (s)')
ylabel('Error - X (m)')

subplot(3,1,2)
hold on
% plot(GT_odom(45:10:end-2,3), '-b')
% plot(Pose(2:end,2), '-r');
plot(GT_odom(45:5:end-1,1), Pose(2:end,2) + GT_odom(45:5:end-1,3) - 51.05, '-r')
plot(GT_odom(45:5:end-1,1), 2*sig(1:end,2,2), '-b')
plot(GT_odom(45:5:end-1,1), -2*sig(1:end,2,2), '-b')
xlabel('Time (s)')
ylabel('Error A- Y (m)')

subplot(3,1,3)
hold on
plot(GT_odom(45:5:end-1,1), Pose(2:end,3) + GT_odom(45:5:end-1,4) - 4.71, '-r')
plot(GT_odom(45:5:end-1,1), 2*sig(:,3,3), '-b')
plot(GT_odom(45:5:end-1,1), -2*sig(:,3,3), '-b')
xlabel('Time (s)')
ylabel('Error - Yaw (rad)')

legend('Error', '\pm2\sigma')

