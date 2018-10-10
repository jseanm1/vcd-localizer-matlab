% load iciis_1_localized

figure

imshow(imcomplement(map));

hold on
zoom(1.5)

plot((gt_jfr(:,1)+70.2)/0.05, (gt_jfr(:,2)+70.2)/0.05, '-r')
% plot((gps(:,1)+70.2)/0.05, (gps(:,2)+70.2)/0.05, '-g')
plot((Pose(2:end,1))/0.05, (Pose(2:end,2))/0.05, '-b')
legend('Ground Truth', 'Estimate')

axis on
grid on
xticks(0:200:2800)
xticklabels({'-700', '-60', '-50', '-40', '-30', '-20', '-10', '0', '10', '20', '30', '40'})
yticks(0:200:2800)
yticklabels({'70', '60', '50', '40', '30', '20', '10', '0', '-10', '-20', '-30', '-40'})

xlabel('(m)')
ylabel('(m)')
