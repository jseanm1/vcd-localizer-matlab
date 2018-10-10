% Load the PR2 localization bag and get the scan messages ready

bag = rosbag('./pr2_loc.bag');
bagSelect = select(bag, 'Topic', '/base_scan');
laserMsgs = readMessages(bagSelect);

laser = [];
n = length(laserMsgs);

for i = 1:n
    laser(i,:) = laserMsgs{i}.Ranges';    
end

map = imread('pr2_map_0.05.png');

conf.map_resolution = 0.05;
conf.laser_reading_max = 25;   % in meters
conf.laser_reading_min = 1.50;
conf.map_size = size(map).*conf.map_resolution;
conf.laser_res = deg2rad(180/1040);

savefile = 'pr2_data.mat';

save(savefile, 'laser', 'conf');
