function [] = drawMap()
clear all;
close all;
map = zeros(10000,10000,3);
map = uint8(map);
resolution = 0.2;
% Grass
map(:,:,2) = 255;
% Arena
for i = 501:9500
    for j = 4001:6000
        map(i,j,:) = 32;
    end
end

shapeInserter = vision.ShapeInserter('Shape','Rectangles', 'Fill', true, 'FillColor', 'White');

% Resolution 1 px = 0.01m Hardcoded (Sorry)
[u,v,wp,hp] = convertToPx(-6.67, 40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-3.33, 40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(3.33, 40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(6.67, 40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 31.11, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 22.22, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 13.33, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 4.44, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -4.44, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -13.33, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -22.22, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -31.11, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-6.67, -40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-3.33, -40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(3.33, -40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(6.67, -40, 0.5, 5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, -35, 20, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(0, 35, 20, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-7.5, -31.11, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-7.5, -13.33, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-7.5, 4.44, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(-7.5, 22.22, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(7.5, 31.11, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(7.5, 13.33, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(7.5, -4.44, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

[u,v,wp,hp] = convertToPx(7.5, -22.22, 5, 0.5);
rectangle = int32([u,v,wp,hp]);
map = shapeInserter(map, rectangle);

% [u,v,wp,hp] = convertToPx(10, -40, 10, 0.5);
% rectangle = int32([u,v,wp,hp]);
% map = shapeInserter(map, rectangle);
% 
% 
% [u,v,wp,hp] = convertToPx(7.5, -22.22, 5, 0.5);
% rectangle = int32([u,v,wp,hp]);
% map = shapeInserter(map, rectangle);
% 
% [u,v,wp,hp] = convertToPx(17.5, -30, 5, 0.5);
% rectangle = int32([u,v,wp,hp]);
% map = shapeInserter(map, rectangle);
% 
% [u,v,wp,hp] = convertToPx(15, -30, 0.5, 10);
% rectangle = int32([u,v,wp,hp]);
% map = shapeInserter(map, rectangle);

% release(shapeInserter);
% red = double([255 0 0]);
% % set(shapeInserter,'Shape','Circles','Fill', true, 'FillColor', 'Black');
% shapeInserter = vision.ShapeInserter('Shape','Circles', 'Fill', true, 'FillColor', 'Custom', 'CustomFillColor', red);
% [u,v,wp,hp] = convertToPx(20, -35, 10, 10);
% circle = int32([u,v,wp/2.0]);
% map = shapeInserter(map, circle);

% Resize to desired resolution
mapRz = imresize(map, resolution);

% Rotate for kentland angle
mapRt = imrotate(mapRz, -52.0016, 'bicubic');

[r,c,d] = size(mapRt)
% Set black to green and gray to black
for i=1:r
    for j=1:c
        if mapRt(i,j,1) == 0
            mapRt(i,j,2) = 255;
        elseif mapRt(i,j,1) == 32
            mapRt(i,j,:) = 0;
        end
    end
end

imshow(mapRt);
imwrite(mapRt, 'jfr_kentland_track.png');
end

function [u,v,wp, hp] = convertToPx(x,y,w,h)
    u = 100 * (x - w/2) + 5000;
    v = -100 * (y + h/2) + 5000;
    
    wp = 100 * w;
    hp = 100 * h;
end

