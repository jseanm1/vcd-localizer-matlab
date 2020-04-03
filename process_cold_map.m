clear
clc

img = imread('cold/freiburg_path_A_ext_3/map.pgm');

map = img(1501:2300,1501:2101);

for i=1:700
    for j=1:500
        if map(i,j) ~= 0
            map(i,j) = 255;
        end
    end
end
map = im2bw(map);

imshow(map);



save('freiburg_map.mat', 'map');

