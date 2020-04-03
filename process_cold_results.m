clear
clc
load freiburg_A_ext_2_localized.mat
load freiburg_A_ext_2_gmapping.mat

gm = gmapping_pose;
gmapping_pose = gm(:,1:2);


psi = (Pose(2,3) + gm(1,3))/2;            
            
gmapping_pose = [cos(psi) -sin(psi);
    
                sin(psi) cos(psi)] * gmapping_pose';
            
gmapping_pose = gmapping_pose';

figure
hold on
imshow(imcomplement(map))
hold on
plot((Pose(2:end,1))/0.05, (Pose(2:end,2))/0.05, 'b', 'MarkerSize', 2)
plot((-gmapping_pose(:,1)+Pose(2,1))/0.05, (gmapping_pose(:,2)+Pose(2,2))/0.05, 'r')


ang = -pi/2:pi/180:pi/2;

figure
hold on

for i=conf.start_index:length(laser)
    x = Pose(i-conf.start_index+2,1) + (laser(i+1,:).*sin(-Pose(i-conf.start_index+2,3)+ang));
    y = Pose(i-conf.start_index+2,2) + (laser(i+1,:).*cos(-Pose(i-conf.start_index+2,3)+ang));
    
    plot(y,x, '.k', 'MarkerSize', 1)
    
    pause(0.1)
end


