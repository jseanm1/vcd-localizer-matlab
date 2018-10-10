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

% First observation
obs = observations{1}(1:2,:)';

approxDTx = query2DCubicSpline(optCPx, optKx, obs);
approxDTy = query2DCubicSpline(optCPy, optKy, obs);

interpDTx = DTobj1(obs(:,2),obs(:,1));
interpDTy = DTobj2(obs(:,2),obs(:,1));

% Plot everything around 31.9712,27.4087
xRange = 30:0.01:48;
yRange = 23:0.01:28;

approxDTxNeighbour = zeros(length(yRange), length(xRange));
approxDTyNeighbour = zeros(length(yRange), length(xRange));
interpDTxNeighbour = zeros(length(yRange), length(xRange));
interpDTyNeighbour = zeros(length(yRange), length(xRange));

for i = 1:length(yRange)
    for j = 1:length(xRange)
        approxDTxNeighbour(i,j) = query2DCubicSpline(optCPx, optKx, [xRange(j), yRange(i)]);
        approxDTyNeighbour(i,j) = query2DCubicSpline(optCPy, optKy, [xRange(j), yRange(i)]);
        interpDTxNeighbour(i,j) = DTobj1(yRange(i), xRange(j));
        interpDTyNeighbour(i,j) = DTobj2(yRange(i), xRange(j));
    end
end

deltaX = approxDTxNeighbour - interpDTxNeighbour;
deltaY = approxDTyNeighbour - interpDTyNeighbour;

figure
mesh(approxDTxNeighbour)
title('Approx DTx')

figure
mesh(approxDTyNeighbour)
title('Approx DTy')

figure
mesh(interpDTxNeighbour)
title('Interp DTx')

figure
mesh(interpDTyNeighbour)
title('Interp DTy')


































