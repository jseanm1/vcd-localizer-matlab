clear
clc

conf.map_resolution = 0.05;

map = imread('mbzirc_map.png');
%map = rgb2gray(map);
%map = im2bw(map);
map = edge(map, 'Canny');

[DT, DtIndex] = bwdist(map, 'euclidean');
DT = double(DT.*conf.map_resolution);
[m,n] = size(DT);
DT1 = zeros(m,n);
DT2 = zeros(m,n);
for i = 1:m
    for j = 1:n
        if DT(i,j) ~= 0
            index = double(DtIndex(i,j));
            col = double(floor(index/m) + 1);
            row = double(mod(index, m));
            if row == 0
                row = m;
            end

            DT1(i,j) = (col - j).*conf.map_resolution;
            DT2(i,j) = (row - i).*conf.map_resolution;
        end
    end
end

figure
hold on
title('Unsigned DT')
mesh(DT)

figure
hold on
title('Vector DT:X')
mesh(DT1)

figure
hold on
title('Vector DT:Y')
mesh(DT2)




