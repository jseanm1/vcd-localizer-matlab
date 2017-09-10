close all

conf.map_resolution = 0.05;
conf.map_size = [25.05,25.05];

map = imread('jfr_kentland.png');
map = rgb2gray(map);
mapPart = map(1250:1750,1250:1750);
mapPart = imgaussfilt(mapPart);
mapPart = im2bw(mapPart);
mapPart = edge(mapPart, 'Canny');

[DT, DtIndex] = bwdist(mapPart, 'euclidean');
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
            DT2(i,j) = (i - row).*conf.map_resolution;
        end
    end
end

[X1, X2] = ndgrid(conf.map_resolution:conf.map_resolution:conf.map_size(1),conf.map_resolution:conf.map_resolution:conf.map_size(2));
DTobj = griddedInterpolant(X1, X2, DT, 'cubic');
DTobj1 = griddedInterpolant(X1, X2, DT1, 'cubic');
DTobj2 = griddedInterpolant(X1, X2, DT2, 'cubic');

[dt1_dx, dt1_dy] = gradient(DT1);
DT1_dxobj = griddedInterpolant(X1, X2, dt1_dx, 'cubic');
DT1_dyobj = griddedInterpolant(X1, X2, dt1_dy, 'cubic');

[dt2_dx, dt2_dy] = gradient(DT2);
DT2_dxobj = griddedInterpolant(X1, X2, dt2_dx, 'cubic');
DT2_dyobj = griddedInterpolant(X1, X2, dt2_dy, 'cubic');

[dt1_dx2, dt1_dxdy] = gradient(dt1_dx);
DT1_dx2obj = griddedInterpolant(X1, X2, dt1_dx2, 'cubic');

[dt1_dydx, dt1_dy2] = gradient(dt1_dy);
DT1_dy2obj = griddedInterpolant(X1, X2, dt1_dy2, 'cubic');

[dt2_dx2, dt2_dxdy] = gradient(dt2_dx);
DT2_dx2obj = griddedInterpolant(X1, X2, dt2_dx2, 'cubic');

[dt2_dydx, dt2_dy2] = gradient(dt2_dy);
DT2_dy2obj = griddedInterpolant(X1, X2, dt2_dy2, 'cubic');


% imshow(flipud(mapPart))
% figure
% mesh(DT1)
% axis off
% figure
% mesh(DT2)
% axis off
% figure
% mesh(DT)
% axis off

row = linspace(12.5,12.5,501); 
col = 0.05:0.05:25.05;

figure
hold on
plot(col,DTobj(row,col),'b')
plot(col,DTobj1(row,col),'g')
plot(col,DTobj2(row,col),'y')
plot(col,DTobj2(row,col).^2 + DTobj1(row,col).^2,'r')
legend('Unsigned DT', 'DTx', 'DTy', 'DTx^2 + DTy^2');
xlabel('x(m)');
ylabel('Distance Value')

print('icra_cross_x.png', '-dpng', '-r600')

figure
hold on
plot(col,DTobj(col,row),'b')
plot(col,DTobj1(col,row),'g')
plot(col,DTobj2(col,row),'y')
plot(col,DTobj2(col,row).^2 + DTobj1(col,row).^2,'r')
legend('Unsigned DT', 'DTx', 'DTy', 'DTx^2 + DTy^2');
xlabel('y(m)');
ylabel('Distance Value')

print('icra_cross_y.png', '-dpng', '-r600')
