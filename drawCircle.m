function [] = drawCircle()
clear all;
r = 10000;
c = 10000;
resolution = 0.2;
map = zeros(r,c,3);
map = uint8(map);

% Grass
map(:,:,2) = 255;

shapeInserter = vision.ShapeInserter('Shape','Circles', 'Fill', true, 'FillColor', 'White');
circle = int32([r/2,c/2,5*200]);
map = shapeInserter(map, circle);

release(shapeInserter);
shapeInserter = vision.ShapeInserter('Shape','Rectangles', 'Fill', true, 'FillColor', 'Black');

[u,v,wp, hp] = convertToPx(0,0,0.5,10);
rectangle = int32([u,v,wp, hp]);
map = shapeInserter(map, rectangle);

[u,v,wp, hp] = convertToPx(2.5,0,5,0.5);
rectangle = int32([u,v,wp, hp]);
map = shapeInserter(map, rectangle);

% Set black to gray
[r,c,d] = size(map);
for i=1:r
    for j=1:c
        if map(i,j,2) == 0
            map(i,j,:) = 32;
        end
    end
end

% Resize to desired resolution
mapRz = imresize(map, resolution);

% Rotate for kentland angle
mapRt = imrotate(mapRz, -52.0016, 'bicubic');

[r,c,d] = size(mapRt);
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
%viscircles(centre,radius,'Color',colors{1});
imwrite(mapRt, 'jfr_circle.png');
end

function [u,v,wp, hp] = convertToPx(x,y,w,h)
    u = 200 * (x - w/2) + 5000;
    v = -200 * (y + h/2) + 5000;
    
    wp = 200 * w;
    hp = 200 * h;
end
