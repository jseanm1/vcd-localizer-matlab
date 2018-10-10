% load fval_cov_intel.mat

x_cov = [];
y_cov = [];
yaw_cov = [];
fval = [];

for i=1700:1800
    x_cov(end+1) = estimates{i}.cov(1,1);
    y_cov(end+1) = estimates{i}.cov(2,2);
    yaw_cov(end+1) = estimates{i}.cov(3,3);
    fval(end+1) = sqrt(sumsqr(estimates{i}.residual));
end

figure
hold on
title('X std vs fval - Intel');
plot(sqrt(x_cov)*100, 'r')
plot(fval, 'g')
legend('X-std', 'fval')

figure
hold on
title('Y std vs fval - Intel');
plot(sqrt(y_cov)*100, 'r')
plot(fval, 'g')
legend('Y-std', 'fval')

figure
hold on
title('Yaw std vs fval - Intel');
plot(sqrt(yaw_cov)*100, 'r')
plot(fval, 'g')
legend('Yaw-std', 'fval')
