% Run localizer first
% Load Gmapping pose mat

imshow(imcomplement(map));
hold on
zoom(2)

plot((gmapping_pose(:,1)./0.05)+520,-(gmapping_pose(:,2)./0.05)+430,'*-b')

plot((Pose(1:20:3490,1)./0.05),(Pose(1:20:3490,2)./0.05),'.-r')

legend('Gmapping Pose', 'VCD Based Localizer')

% print('Gmapping_vs_VCD.png', '-dpng', '-r600')

