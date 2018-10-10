c = [cov_Xr40(1,1) cov_Xr40(1,2); cov_Xr40(2,1) cov_Xr40(2,2)];
v = cov(pose40(:,1:2))

figure
hold on
plot(pose40(:,1),pose40(:,2), '.y')
plot(poseMean40(1,1), poseMean40(1,2), 'bo')
error_ellipse(v, poseMean40(1,1:2), 'conf', 0.9)
error_ellipse(c, poseMean40(1,1:2), 'conf', 0.9)
legend('Monte Carlo Particles', 'VCD Mean', '\pm2\sigma Monte Carlo', '\pm2\sigma VCD')
xlabel('X(m)')
ylabel('Y(m)')

c = [cov_Xr828(1,1) cov_Xr828(1,2); cov_Xr828(2,1) cov_Xr828(2,2)];
v = cov(pose828(:,1:2))

figure
hold on
plot(pose828(:,1),pose828(:,2), '.y')
plot(poseMean828(1,1), poseMean828(1,2), 'bo')
error_ellipse(v, poseMean828(1,1:2), 'conf', 0.9)
error_ellipse(c, poseMean828(1,1:2), 'conf', 0.9)
legend('Monte Carlo Particles', 'VCD Mean', '\pm2\sigma Monte Carlo', '\pm2\sigma VCD')
xlabel('X(m)')
ylabel('Y(m)')