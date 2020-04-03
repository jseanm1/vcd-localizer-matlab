% clear
% clc

% Load locpath manually

gt_pose = zeros(length(locpath)-30, 4);

for i=1:length(gt_pose)
    index = i+30;
    t = locpath(index, 4) + (locpath(index,5)/1000000000);
   gt_pose(i,:) = [t, locpath(index,9), locpath(index,10), locpath(index,12)];    
end

% bag = rosbag('./cold/freiburg_path_A_ext_2/odom_scans_tf.bag');
% 
% scanSelect = select(bag, 'Topic', '/scan');
% scanMsgs = readMessages(scanSelect);
% 
% laser = zeros(length(scanMsgs), 182);
% 
% for i=1:length(scanMsgs)
%     laser(i,1) = (scanMsgs{i}.Header.Stamp.Sec) + (scanMsgs{i}.Header.Stamp.Nsec*10^-9);
%     laser(i,2:end) = scanMsgs{i}.Ranges';    
% end

laserTS = timeseries(laser(:,2:end), laser(:,1));
laserSyncedTS = getsamples(resample(laserTS, gt_pose(:,1), 'linear'), 1:size(gt_pose,1));

laserSynced = laserSyncedTS.Data;

x = zeros(1,181);
y = zeros(1,181);
ang = -pi/2:pi/180:pi/2;
figure
hold on

for i=1:length(gt_pose)
   x = gt_pose(i,2) + (laserSynced(i,:).*cos(gt_pose(i,4)+ang)); 
   y = gt_pose(i,3) + (laserSynced(i,:).*sin(gt_pose(i,4)+ang));
   
   plot(y,x, '.k', 'MarkerSize', 1)
   
end

