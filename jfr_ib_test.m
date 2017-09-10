close all
j = 320;
nano = 1/1000000000;
camera_f = 10.0;

mapParams.resolution = 0.05;
mapParams.xoffset = 0;
mapParams.yoffset = 0;

image = readImage(imageMsgs{j});

imshow(image)

imageStamp = imageMsgs{j}.Header.Stamp;
t = imageStamp.Sec + imageStamp.Nsec*nano;

[m,n] = size(odomImageMsgs);

for i=1:m
    if strcmp(odomImageMsgs{i}.MessageType, 'nav_msgs/Odometry')
        currentOdom = odomImageMsgs{i};
    elseif strcmp(odomImageMsgs{i}.MessageType, 'sensor_msgs/Image')
        if odomImageMsgs{i}.Header.Seq == j + 565
            i
            currentImage = readImage(odomImageMsgs{i});
            if (odomImageMsgs{i}.Header.Stamp - currentOdom.Header.Stamp > odomImageMsgs{i+1}.Header.Stamp - odomImageMsgs{i}.Header.Stamp)
                currentOdom = odomImageMsgs{i+1};
            end
            break
        end
    else
        i
        error('Unknown Message');
    end
end

img = edge(im2bw(imgaussfilt(currentImage)), 'Canny');
        
pose.x = currentOdom.Pose.Pose.Position.X;
pose.y = currentOdom.Pose.Pose.Position.Y;
pose.z = currentOdom.Pose.Pose.Position.Z;            
orientation = currentOdom.Pose.Pose.Orientation;
eul = quat2eul([orientation.W, orientation.X, orientation.Y, orientation.Z]);
rotm = eul2rotm(eul);

[m,n] = size(img);

newImgV = [];
j2 = n/2;
i2 = m/2;

for i=1:m
    for j=1:n
        if img(i,j) == 1
            j3 = (j-j2)*mapParams.resolution;
            i3 = (i-i2)*mapParams.resolution;
            den = (rotm(3,1) * j3 + rotm(3,2) * i3 - rotm(3,3) * camera_f) / pose.z;
            tmpX = pose.x - (rotm(1,1) * j3 + rotm(1,2) * i3 - rotm(1,3) * camera_f) / den;
            tmpY = pose.y - (rotm(2,1) * j3 + rotm(2,2) * i3 - rotm(2,3) * camera_f) / den;
            px = GXWX(mapParams, tmpX);
            py = GYWY(mapParams, tmpY);
            
            newImgV(end+1,:) = [py, px];
        end
    end
end

newImg = zeros(3,3);
minVals = min(newImgV);

[m,n] = size(newImgV);

for i=1:m
    rc = newImgV(i,:) - minVals + [1,1];
    newImg(rc(1),rc(2)) = 1;
end

figure
imshow(newImg);


function[x] = GXWX(mapParams, x)
x = floor(((x - mapParams.xoffset)) + 0.5)/mapParams.resolution;
end

function[y] = GYWY(mapParams, y)
y = floor(((y - mapParams.yoffset)) + 0.5)/mapParams.resolution;
end



