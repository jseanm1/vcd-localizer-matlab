c = [cov_Xr10(1,1) cov_Xr10(1,2); cov_Xr10(2,1) cov_Xr10(2,2)];
v = cov(pose10(:,1:2))

figure
hold on
plot(pose10(:,1),pose10(:,2), '.k')
plot(poseMean10(1,1), poseMean10(1,2), 'bo')
error_ellipse(v, poseMean10(1,1:2), 'conf', 0.9)
error_ellipse(c, poseMean10(1,1:2), 'conf', 0.9)
legend('Monte Carlo Particles', 'Monte Carlo Mean', 'Monte Carlo Error', 'VCD Error')
xlabel('X(m)')
ylabel('Y(m)')
c
cov_Xr10
% print('icra_jfr_uncertainty_pose10.png', '-dpng', '-r1200')

c = [cov_Xr100(1,1) cov_Xr100(1,2); cov_Xr100(2,1) cov_Xr100(2,2)];
v = cov(pose100(:,1:2))

figure
hold on
plot(pose100(:,1),pose100(:,2), '.k')
plot(poseMean100(1,1), poseMean100(1,2), 'bo')
error_ellipse(v, poseMean100(1,1:2), 'conf', 0.9)
error_ellipse(c, poseMean100(1,1:2), 'conf', 0.9)
legend('Monte Carlo Particles', 'Monte Carlo Mean', 'Monte Carlo Error', 'VCD Error')
xlabel('X(m)')
ylabel('Y(m)')

% print('icra_jfr_uncertainty_pose100.png', '-dpng', '-r1200')