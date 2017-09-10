jfr2bag = rosbag('jfr_simulation3.bag');

odomMsgSet = select(jfr2bag, 'Topic', '/hexacopter/mavros/local_position/odom');
imageMsgSet = select(jfr2bag, 'Topic', '/hexacopter/perspective_camera/image_raw');
odomImageMsgSet = select(jfr2bag, 'Topic' , {'/hexacopter/mavros/local_position/odom', '/hexacopter/perspective_camera/image_raw'});

odomMsgs = readMessages(odomMsgSet);
imageMsgs = readMessages(imageMsgSet);
odomImageMsgs = readMessages(odomImageMsgSet);

% test sequence
[m,n] = size(imageMsgs);

for i=2:m
    if imageMsgs{i}.Header.Seq - imageMsgs{i-1}.Header.Seq ~= 1
        error('Sequence mismatch Img %d', i);
    end
end

[m,n] = size(odomMsgs);

for i=2:m
    if odomMsgs{i}.Header.Seq - odomMsgs{i-1}.Header.Seq ~= 1
        error('Sequence mismatch Odom %d', i);
    end
end
