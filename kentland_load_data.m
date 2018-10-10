jfr2bag = rosbag('kentland3_scanpos.bag');

% odomMsgSet = select(jfr2bag, 'Topic', '/hexacopter0/mavros/local_position/odom');
scanPoseSet = select(jfr2bag, 'Topic', '/hexacopter/scanpos');

% odomMsgs = readMessages(odomMsgSet);
scanPoseMsgs = readMessages(scanPoseSet);

img = imread('kentland_map.png');
mapbw = im2bw(img);
mapbw = fliplr(flipud(mapbw));
map = edge(mapbw, 'Canny');