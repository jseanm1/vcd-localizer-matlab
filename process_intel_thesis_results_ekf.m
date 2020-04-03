% clear
% clc
% 
% load ekf_intel_localized.mat
% load intel_data.mat


% figure
% imshow(imcomplement(map))
% hold on
% zoom(2)
% plot((gmapping_pose(:,1)./0.05)+525, (-gmapping_pose(:,2)./0.05)+430, '-r')
% plot((Pose(23:10:3490,1)./0.05),(Pose(23:10:3490,2)./0.05),'xb')
% legend('GMapping Trajectory', 'EKF Based Localizer')

% lim = 11000;
% 
% figure
% imshow(imcomplement(map))
% hold on
% zoom(2)
% plot((Pose(2:1:lim,1)./0.05),(Pose(2:1:lim,2)./0.05), 'Marker', '.', 'MarkerSize', 3, 'Color', [0.8500 0.3250 0.0980], 'LineStyle', '-')
% legend('EKF Based Localizer Trajectory')

pcx = zeros((lim-conf.start_index+1)*180,1);
pcy = zeros((lim-conf.start_index+1)*180,1);
for i=conf.start_index:lim
   for j=1:180
      pcx(i-conf.start_index+1) = Pose(i-conf.start_index+2,1) + laser(i,j)*sin(-Pose(i-conf.start_index+2,3)+ang(j));
      pcy(i-conf.start_index+1) = Pose(i-conf.start_index+2,2) + laser(i,j)*cos(-Pose(i-conf.start_index+2,3)+ang(j)); 
   end    
end

figure
hold on
plot(pcx, -pcy, 'Marker', '.', 'MarkerSize', 3, 'Color', [0.8500 0.3250 0.0980], 'LineStyle', 'none')
axis equal
box on
xticks([])
yticks([])
xlim([12.5 47.5])
ylim([-47.5 -12.5])
