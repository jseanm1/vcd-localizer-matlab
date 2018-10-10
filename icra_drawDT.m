close all

conf.map_resolution = 0.05;
conf.map_size = [25.05,25.05];

map = imread('jfr_kentland.png');
map = rgb2gray(map);
mapPart = map(750:1250,1500:2000);
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
            DT2(i,j) = (row - i).*conf.map_resolution;
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
plot(linspace(4.9,4.9,501), linspace(-5,25,501), '--k')
plot(linspace(6.3,6.3,501), linspace(-5,25,501), ':k')
plot(linspace(7.35,7.35,501), linspace(-5,25,501), '--k')
plot(linspace(7.9,7.9,501), linspace(-5,25,501), '--k')
plot(linspace(20.8,20.8,501), linspace(-5,25,501), '--k')
plot(linspace(21.6,21.6,501), linspace(-5,25,501), '--k')
plot(linspace(23.6,23.6,501), linspace(-5,25,501), '--k')
plot(linspace(24.15,24.15,501), linspace(-5,25,501), '--k')
plot(linspace(7.65,7.65,501), linspace(-5,25,501), ':k')
plot(linspace(13.8,13.8,501), linspace(-5,25,501), ':k')
plot(linspace(21.2,21.2,501), linspace(-5,25,501), ':k')
plot(linspace(22.55,22.55,501), linspace(-5,25,501), ':k')
plot(linspace(23.85,23.85,501), linspace(-5,25,501), ':k')
legend('Unsigned DT', 'DTx', 'DTy', 'DTx^2 + DTy^2', 'Boundary', 'Cut Locus');
xlabel('x(m)');
ylabel('Distance Value')

print('icra_cross_x.png', '-dpng', '-r600')
% 
figure
hold on
plot(col,DTobj(col,row),'b')
plot(col,DTobj1(col,row),'g')
plot(col,DTobj2(col,row),'y')
plot(col,DTobj2(col,row).^2 + DTobj1(col,row).^2,'r')
plot(linspace(6.6,6.6,501), linspace(-5,25,501), '--k')
plot(linspace(11.8,11.8,501), linspace(-5,25,501), ':k')
plot(linspace(19,19,501), linspace(-5,25,501), '--k')
plot(linspace(19.6,19.6,501), linspace(-5,25,501), '--k')
plot(linspace(15.5,15.5,501), linspace(-5,25,501), ':k')
plot(linspace(19.3,19.3,501), linspace(-5,25,501), ':k')
plot(linspace(0,25,500), linspace(0,0,500), '-k')
legend('Unsigned DT', 'DTx', 'DTy', 'DTx^2 + DTy^2', 'Boundary', 'Cut Locus');
xlabel('y(m)');
ylabel('Distance Value')
% 
print('icra_cross_y.png', '-dpng', '-r600')

imshow(flipud(mapPart))
hold on
axis on

xticks(0:100:501)
xticklabels({'0', '5', '10', '15', '20', '25'})
yticks(0:100:501)
yticklabels({'25', '20', '15', '10', '05', '0'})

xlabel('X(m)')
ylabel('Y(m)')

h1 = plot(250*ones(1,500), 1:1:500, '--g')
h2 = plot(1:1:500, 250*ones(1,500), '--r')

hold off

set([h1 h2], 'LineWidth', 5);

legend('X = 12.5m', 'Y = 12.5m')

print('icra_kentland.png', '-dpng', '-r600')
% 
mesh(DT)
hold on
xticks(0:100:501)
xticklabels({'0', '5', '10', '15', '20', '25'})
yticks(0:100:501)
yticklabels({'0', '5', '10', '15', '20', '25'})
xlabel('X(m)')
ylabel('Y(m)')
% 
h1 = plot(250*ones(1,500), 1:1:500, 100, '--g')
h2 = plot(1:1:500, 250*ones(1,500), 100, '--r')




















