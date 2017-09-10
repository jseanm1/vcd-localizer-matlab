jfr2bag = rosbag('jfr_simulation3_clog1.bag');

odomMsgSet = select(jfr2bag, 'Topic', '/hexacopter/mavros/local_position/odom');
scanPoseSet = select(jfr2bag, 'Topic', '/hexacopter/scanpos');

odomMsgs = readMessages(odomMsgSet);
scanPoseMsgs = readMessages(scanPoseSet);

img = imread('jfr_kentland.png');
mapbw = im2bw(img);
map = edge(mapbw, 'Canny');

