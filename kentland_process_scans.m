camera_f = 31.0;

mapParams.resolution = 0.05;
mapParams.xoffset = 0;
mapParams.yoffset = 0;

conf.map_resolution = mapParams.resolution;
conf.map_size = size(map).*conf.map_resolution;

[m,n] = size(scanPoseMsgs);
gt_jfr = zeros(m,3);
laser_ranges = {};
laser_bearings = {};

pose = {};
angles = [];
for i = 1:m
    pose.x = -scanPoseMsgs{i}.Pose.Pose.Pose.Position.Y;
    pose.y = -(scanPoseMsgs{i}.Pose.Pose.Pose.Position.X);
    pose.z = scanPoseMsgs{i}.Pose.Pose.Pose.Position.Z;
    orientation = scanPoseMsgs{i}.Pose.Pose.Pose.Orientation;
    eul = quat2eul([orientation.W, orientation.X, orientation.Y, orientation.Z]);
    rotm = eul2rotm(eul);
    eul(1,2) = -eul(1,2);
    angles(i,:) = eul;
    
    gt_jfr(i,1) = pose.x;
    gt_jfr(i,2) = pose.y;
    gt_jfr(i,3) = eul(1);
    
    clear ranges
    clear bearings
    ranges = scanPoseMsgs{i}.Scan.Ranges;
    bearings = scanPoseMsgs{i}.Scan.Intensities;
    [r,c] = size(ranges);
    
    tmp_ranges = zeros(1, r);
    tmp_bearings = zeros(1, r);
    
    for j = 1:r
       x_r = ranges(j) * sin(bearings(j));% / mapParams.resolution;
       y_r = ranges(j) * cos(bearings(j));% / mapParams.resolution;
       
       den = (rotm(3,1) * x_r + rotm(3,2) * y_r - rotm(3,3) * camera_f) / pose.z;
       tmpX = (rotm(1,1) * x_r + rotm(1,2) * y_r - rotm(1,3) * camera_f) / den;
       tmpY = (rotm(2,1) * x_r + rotm(2,2) * y_r - rotm(2,3) * camera_f) / den;
       
       px = GXWX(mapParams, tmpY);
       py = GYWY(mapParams, tmpX);
%        
       tmp_ranges(1,j) = sqrt(px^2 + py^2);
       tmp_bearings(1,j) = atan2(px,py);
       
    end
    
    laser_ranges{i} = tmp_ranges;
    laser_bearings{i} = tmp_bearings;
end

% figure
% hold on
% plot(angles(:,1), '-r')
% plot(angles(:,2), '-g')
% plot(angles(:,3), '-b')

gps = zeros(m,3);
% gps(:,1:2) = normrnd(gt_jfr(:,1:2), 0.25);
% gps(:,3) = normrnd(gt_jfr(:,3),0.02);

function[x] = GXWX(mapParams, x)
x = floor(((x - mapParams.xoffset)) + 0.5);
end

function[y] = GYWY(mapParams, y)
y = floor(((y - mapParams.yoffset)) + 0.5);
end