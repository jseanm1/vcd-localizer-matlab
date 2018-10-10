% jfr2bag = rosbag('jfr_icra_4.bag');
jfr2bag = rosbag('iciis_2.bag');

odomMsgSet = select(jfr2bag, 'Topic', '/hexacopter/mavros/local_position/odom');
scanPoseSet = select(jfr2bag, 'Topic', '/hexacopter/scanPos');

odomMsgs = readMessages(odomMsgSet);
scanPoseMsgs = readMessages(scanPoseSet);

img = imread('jfr_kentland_track.png');
mapbw = im2bw(img);
map = edge(mapbw, 'Canny');

