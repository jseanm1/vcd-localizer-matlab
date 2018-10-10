clear
clc

bag = rosbag('/home/janindu/data/ICRA_2019/7Sep18/cas_lab_mapping/cas_lab_localize_2018-09-07-02-15-22.bag');

odomBag = select(bag, 'Topic', '/odom');
odomMsgs = readMessages(odomBag);

laserBag = select(bag, 'Topic', '/urg_scan');
laserMsgs = readMessages(laserBag);

laser = zeros(length(laserMsgs), 713);
odomTemp = zeros(length(odomMsgs), 4);

for i=1:length(odomMsgs)
    odomTemp(i,4) = odomMsgs{i}.Header.Stamp.Sec + odomMsgs{i}.Header.Stamp.Nsec/1000000000;
    
    odomTemp(i,1) = odomMsgs{i}.Pose.Pose.Position.X;
    odomTemp(i,2) = odomMsgs{i}.Pose.Pose.Position.Y;
    
    quat = [odomMsgs{i}.Pose.Pose.Orientation.W, odomMsgs{i}.Pose.Pose.Orientation.X, odomMsgs{i}.Pose.Pose.Orientation.Y, odomMsgs{i}.Pose.Pose.Orientation.Z];
    
    eul = quat2eul(quat);
    
    odomTemp(i,3) = eul(1);
end

for i=1:length(laserMsgs)
   time = laserMsgs{i}.Header.Stamp.Sec + laserMsgs{i}.Header.Stamp.Nsec/1000000000;
   
   laser(i,1) = time;
   
   laser(i,2:end) = laserMsgs{i}.Ranges';    
end
   
odomTS = timeseries(odomTemp(:,1:3), odomTemp(:,4));
odomLaser = getsamples(resample(odomTS, laser(:,1), 'linear'), 1:length(laser));
odom = odomLaser.Data;

angles = laserMsgs{1}.AngleMax:-1*laserMsgs{1}.AngleIncrement:laserMsgs{1}.AngleMin;

% Remove time from laser - hack
time = laser(:,1);
laser = laser(:,2:end);

save('7_sep_cas_lab.mat', 'laser', 'odom', 'angles', 'time');
