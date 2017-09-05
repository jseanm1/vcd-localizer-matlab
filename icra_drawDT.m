map = imread('jfr_kentland.png');
map = rgb2gray(map);
mapPart = map(1250:1750,1250:1750);
mapPart = im2bw(mapPart);

[DT, DtIndex] = bwdist(mapPart, 'euclidean');
DT = double(DT);
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

            DT1(i,j) = (col - j);
            DT2(i,j) = (i - row);
        end
    end
end

imshow(flipud(mapPart))
figure
mesh(DT1)
axis off
figure
mesh(DT2)
axis off
figure
mesh(DT)
axis off
