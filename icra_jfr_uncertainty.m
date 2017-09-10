c = [cov_Xr10(1,1) cov_Xr10(1,2); cov_Xr10(2,1) cov_Xr10(2,2)];
v = cov(pose10(:,1:2))

figure
hold on
plot(pose10(:,1),pose10(:,2), '.k')
plot(mean(pose10(:,1)),mean(pose10(:,2)), 'bo')
error_ellipse(v, mean(pose10(:,1:2)), 'conf', 0.95)
plot(tp_10(1,1), tp_10(1,2), 'rx')
error_ellipse(c, tp_10(1,1:2), 'conf', 0.95)
legend('Monte Carlo Particles', 'Monte Carlo Mean', 'Monte Carlo Error', 'VCD Mean', 'VCD Error')

print('icra_jfr_uncertainty_pose10.png', '-dpng', '-r1200')

c = [cov_Xr100(2,2) cov_Xr100(2,1); cov_Xr100(1,2) cov_Xr100(1,1)];
v = cov(pose100(:,1:2))

figure
hold on
plot(pose100(:,1),pose100(:,2), '.k')
plot(mean(pose100(:,1)),mean(pose100(:,2)), 'bo')
plot(tp_100(1,1), tp_100(1,2), 'rx')
error_ellipse(c, tp_100(1,1:2), 'conf', 0.95)
error_ellipse(v, mean(pose100(:,1:2)), 'conf', 0.95)
legend('Monte Carlo Particles', 'Monte Carlo Mean', 'Monte Carlo Error', 'VCD Mean', 'VCD Error')

print('icra_jfr_uncertainty_pose100.png', '-dpng', '-r1200')