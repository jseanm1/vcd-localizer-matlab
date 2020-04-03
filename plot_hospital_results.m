% clear
% load hospital_localized_opt.mat
% ekf = load('hospital_localized_ekf.mat');
% ekf = load('hospital_localized_ekf2.mat');

close all


% figure
% hold on
% imshow(imcomplement(map(550:1050,250:1350)))
% hold on
% % plot((12.88+GT_odom(2:end,2))./0.05, (51.0625 -GT_odom(2:end,3))./0.05, '-b', 'MarkerSize', 1)
% plot((0.38+GT_odom(2:end,2))./0.05, (23.5625 -GT_odom(2:end,3))./0.05, '-b', 'MarkerSize', 1)
% plot(Pose(1:15:end,1)./0.05 - 250, Pose(1:15:end,2)./0.05 - 550, 'or', 'MarkerSize', 3)
% axis on
% xlim([0 1100])
% xticks([0 100 200 300 400 500 600 700 800 900 1000 1100])
% xticklabels({'0', '5', '10', '15', '20', '25', '30', '35', '40', '45' '50', '55'})
% ylim([0 500])
% yticks([0 100 200 300 400 500])
% yticklabels({'25', '20', '15', '10', '5', '0'})
% legend({'Ground Truth', 'Optimization Based Localizer'})
% xlabel('X (m)')
% ylabel('Y (m)')
% 
% sig = sqrt(cov);
% 
% figure
% 
% subplot(3,1,1)
% hold on
% box on
% % plot(GT_odom(45:8117+44,2), '-b')
% plot(GT_odom(45:end,1)-69.4, Pose(2:end,1) - GT_odom(45:end,2) - 12.8751, '-r')
% plot(GT_odom(45:end,1)-69.4, 2*sig(1:end,1,1), '-b')
% plot(GT_odom(45:end,1)-69.4, -2*sig(1:end,1,1), '-b')
% xlabel('\it Time (s)')
% ylabel('\it x error (m)')
% ylim([-0.2 0.2])
% xlim([0 1563.1])
% 
% subplot(3,1,2)
% hold on
% box on
% plot(GT_odom(45:end,1)-69.4, Pose(2:end,2) + GT_odom(45:end,3) - 51.05, '-r')
% plot(GT_odom(45:end,1)-69.4, 2*sig(1:end,2,2), '-b')
% plot(GT_odom(45:end,1)-69.4, -2*sig(1:end,2,2), '-b')
% xlabel('\it Time (s)')
% ylabel('\it y error (m)')
% ylim([-0.2 0.2])
% xlim([0 1563.1])
% 
% subplot(3,1,3)
% hold on
% box on
% plot(GT_odom(45:end,1)-69.4, Pose(2:end,3) + GT_odom(45:end,4) - 4.71, '-r')
% plot(GT_odom(45:end,1)-69.4, 2*sig(1:end,3,3), '-b')
% plot(GT_odom(45:end,1)-69.4, -2*sig(1:end,3,3), '-b')
% xlabel('\it Time (s)')
% ylabel('\it \phi error (rad)')
% ylim([-0.1 0.1])
% xlim([0 1563.1])
% 
% legend('Error', '\pm 2 \sigma boundaries')

ekf.pose = zeros(length(ekf.results),3);

for i=1:length(ekf.results)
    ekf.pose(i,:) = ekf.results{i}.Xk;
end
% 
% figure
% hold on
% imshow(imcomplement(map(550:1050,250:1350)))
% hold on
% % plot((12.88+GT_odom(2:end,2))./0.05, (51.0625 -GT_odom(2:end,3))./0.05, '-b', 'MarkerSize', 1)
% plot((0.38+GT_odom(2:end,2))./0.05, (23.5625 -GT_odom(2:end,3))./0.05, '-b', 'MarkerSize', 1)
% plot(ekf.pose(1:15:end,1)./0.05 - 250, 1050 - (ekf.pose(1:15:end,2)./0.05), 'om', 'MarkerSize', 3)
% % plot((0.38+GT_odom(2,2))./0.05, (23.5625 -GT_odom(2,3))./0.05, 'xb', 'MarkerSize', 6)
% % plot(ekf.pose(1,1)./0.05 - 252, 1050 - (ekf.pose(1,2)./0.05), 'or', 'MarkerSize', 6)
% axis on
% xlim([0 1100])
% xticks([0 100 200 300 400 500 600 700 800 900 1000 1100])
% xticklabels({'0', '5', '10', '15', '20', '25', '30', '35', '40', '45' '50', '55'})
% ylim([0 500])
% yticks([0 100 200 300 400 500])
% yticklabels({'25', '20', '15', '10', '5', '0'})
% legend({'Ground Truth', 'EKF Based Localizer'})
% xlabel('X (m)')
% ylabel('Y (m)')


ekf.cov = zeros(length(ekf.results),3);

for i=1:length(ekf.results)
    ekf.cov(i,:) = [ekf.results{i}.Pk(1,1) ekf.results{i}.Pk(2,2) ekf.results{i}.Pk(3,3)];
end

ekf.err = ekf.pose - GT_odom(:,2:end);
ekf.err = ekf.err(:,:) - [12.8767 28.9999 0];

% figure
% hold on
% 
% subplot(3,1,1)
% hold on
% box on
% plot(GT_odom(1:end,1)-65, ekf.err(1:end,1), 'r')
% plot(GT_odom(1:end,1)-65, sqrt(ekf.cov(1:end,1)).*100, 'b')
% plot(GT_odom(1:end,1)-65, -sqrt(ekf.cov(1:end,1)).*100, 'b')
% ylabel('\it x error (m)')
% xlabel('Time (s)')
% ylim([-0.15 0.15])
% xlim([0 1563.1])
% 
% subplot(3,1,2)
% hold on
% box on
% plot(GT_odom(1:end,1)-65, ekf.err(1:end,2), 'r')
% plot(GT_odom(1:end,1)-65, sqrt(ekf.cov(1:end,2)).*150, 'b')
% plot(GT_odom(1:end,1)-65, -sqrt(ekf.cov(1:end,2)).*150, 'b')
% ylabel('\it y error (m)')
% xlabel('Time (s)')
% ylim([-0.15 0.15])
% xlim([0 1563.1])
% 
% subplot(3,1,3)
% hold on
% box on
% plot(GT_odom(1:end,1)-65, ekf.err(1:end,3), 'r')
% plot(GT_odom(1:end,1)-65, sqrt(ekf.cov(1:end,3)).*1000, 'b')
% plot(GT_odom(1:end,1)-65, -sqrt(ekf.cov(1:end,3)).*1000, 'b')
% ylabel('\it \phi error (rad)')
% xlabel('Time (s)')
% ylim([-0.25 0.25])
% xlim([0 1563.1])
% 
% legend('Error', '\pm 2 \sigma bounds')


opt_err = [sqrt((Pose(2:end,1) - GT_odom(45:end,2) - 12.8751).^2 + (Pose(2:end,2) + GT_odom(45:end,3) - 51.05).^2), Pose(2:end,3) + GT_odom(45:end,4) - 4.71];
opt_abs_err = abs(opt_err);
opt_sqr_err = opt_err.^2;

ekf_err = [sqrt(ekf.err(:,1).^2 + ekf.err(:,2).^2), ekf.err(:,3)];

ekf.abs_err = abs(ekf_err);
ekf.sqr_err = ekf_err.^2;

mean_opt_abs_err = mean(opt_abs_err)
std_opt_abs_err = std(opt_abs_err)

mean_ekf_abs_err = mean(ekf.abs_err)
std_ekf_abs_err = std(ekf.abs_err)

mean_opt_sqr_err = mean(opt_sqr_err)
std_opt_sqr_err = std(opt_sqr_err)

mean_ekf_sqr_err = mean(ekf.sqr_err)
std_ekf_sqr_err = std(ekf.sqr_err)









