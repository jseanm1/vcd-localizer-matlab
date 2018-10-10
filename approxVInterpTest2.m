clear
clc

load observations.mat;
% load intel_0.05_padded.mat;        
load intel_0.05_cres50_qres25.mat
map = imread('intel_padded_0.05.png');

conf.map_resolution = 0.05;
conf.map_size = size(map).*conf.map_resolution;

[DT, DtIndex] = bwdist(map, 'euclidean');
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

            DT1(i,j) = (col - j).*conf.map_resolution;
            DT2(i,j) = (row - i).*conf.map_resolution;
        end
    end
end

[X1, X2] = ndgrid(conf.map_resolution:conf.map_resolution:conf.map_size(1),conf.map_resolution:conf.map_resolution:conf.map_size(2));

DTobj = griddedInterpolant(X1, X2, DT, 'cubic');
DTobj1 = griddedInterpolant(X1, X2, DT1, 'cubic');
DTobj2 = griddedInterpolant(X1, X2, DT2, 'cubic');
disp('Distance functions calculated');

xRange = 25:0.01:45;
yRange = 25:0.01:45;

approxDTx = zeros(length(yRange), length(xRange));
approxDTy = zeros(length(yRange), length(xRange));
interpDTx = zeros(length(yRange), length(xRange));
interpDTy = zeros(length(yRange), length(xRange));

X_ = zeros(length(yRange)*length(xRange), 2);
length(yRange)

disp('Calculate query points');
for i = 1:length(yRange)
    for j = 1:length(xRange)
        X_((i-1)*length(xRange)+j,:) = [xRange(j), yRange(i)]; 
    end
end

disp('Query X spline')
Zx = query2DCubicSpline(optCPx, optKx, X_);

disp('Query Y spline')
Zy = query2DCubicSpline(optCPy, optKy, X_);

disp('Fill matrices')
for i = 1:length(yRange)
    for j = 1:length(xRange)
        approxDTx(i,j) = Zx((i-1)*length(xRange)+j);
        approxDTy(i,j) = Zy((i-1)*length(xRange)+j);
        interpDTx(i,j) = DTobj1(yRange(i),xRange(j));
        interpDTy(i,j) = DTobj2(yRange(i),xRange(j));
    end
end
disp('Matrices completed');

figure
mesh(approxDTx)
title('Approx DTx')

figure
mesh(approxDTy)
title('Approx DTy')

figure
mesh(interpDTx)
title('Interp DTx')

figure
mesh(interpDTy)
title('Interp DTy')

figure
mesh(approxDTx - interpDTx)
title('Delta X')

figure
mesh(approxDTy - interpDTy)
title('Delta Y')





