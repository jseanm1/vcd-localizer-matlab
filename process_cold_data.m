clear
clc

bag = rosbag('./cold/freiburg_path_A_ext_2/odom_scans_tf.bag');

odomSelect = select(bag, 'Topic', '/odom');
odomMsgs = readMessages(odomSelect);

scanSelect = select(bag, 'Topic', '/scan');
scanMsgs = readMessages(scanSelect);

laser = zeros(length(scanMsgs), 182);

startTimeScan = scanMsgs{1}.Header.Stamp.Sec + scanMsgs{1}.Header.Stamp.Nsec*10^-9;
startTimeOdom = odomMsgs{1}.Header.Stamp.Sec + odomMsgs{1}.Header.Stamp.Nsec*10^-9;

if (startTimeOdom > startTimeScan)
    startTime = startTimeScan;
else
    startTime = startTimeOdom;
end

for i=1:length(scanMsgs)
    laser(i,1) = (scanMsgs{i}.Header.Stamp.Sec) + (scanMsgs{i}.Header.Stamp.Nsec*10^-9) - startTime;
    laser(i,2:end) = scanMsgs{i}.Ranges';    
end

odomtmp = zeros(length(odomMsgs), 4);

for i=1:length(odomMsgs)
   odomtmp(i,1) =  (odomMsgs{i}.Header.Stamp.Sec) + (odomMsgs{i}.Header.Stamp.Nsec*10^-9) - startTime;
   
   x = odomMsgs{i}.Pose.Pose.Position.X;
   y = odomMsgs{i}.Pose.Pose.Position.Y;   
   phi = quat2eul([odomMsgs{i}.Pose.Pose.Orientation.W, odomMsgs{i}.Pose.Pose.Orientation.X, odomMsgs{i}.Pose.Pose.Orientation.Y, odomMsgs{i}.Pose.Pose.Orientation.Z]);
   
   odomtmp(i,2:4) = [x y phi(1)];   
end

odomTS = timeseries(odomtmp(:,2:4), odomtmp(:,1));
odomScanSynced = getsamples(resample(odomTS, laser(:,1), 'linear'), 1:size(laser,1));

odom = odomScanSynced.Data;
save freiburg_A_cloudy_2.mat

