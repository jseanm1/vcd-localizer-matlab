close all;
clear all;
clc;

load intel_0.05_padded.mat
map = imread('intel_padded_0.05.png');
conf.map_resolution = 0.05;
conf.map_size = size(map).*conf.map_resolution;

[DTobj1, DTobj2] = getInterpolatedDT(map, conf);
X = getQueryPoints(conf.map_size(1)/conf.map_resolution, conf.map_size(2)/conf.map_resolution, conf.map_resolution);

[optResX, optResY, DTResX, DTResY, deltaX, deltaY] = compareAndDisplay(optCPx, optCPy, optKx, optKy, DTobj1, DTobj2, X);

function [optResX, optResY, DTResX, DTResY, deltaX, deltaY] = compareAndDisplay(optCPx, optCPy, optKx, optKy, DTobj1, DTobj2, X)
    s = size(X,1);
    
    optResX = query2DCubicSpline(optCPx, optKx, X);
    optResY = query2DCubicSpline(optCPy, optKy, X);

    DTResX = zeros(s,1);
    DTResY = zeros(s,1);
    
    deltaX = zeros(s,1);
    deltaY = zeros(s,1);
    
    for i=1:s
        x = X(i,1);
        y = X(i,2);
        
        DTResX(i) = DTobj1(y,x);
        DTResY(i) = DTobj2(y,x);
        
        deltaX(i) = optResX(i)- DTResX(i);
        deltaY(i) = optResY(i)- DTResY(i);
    end

    
    figure
    plot(deltaX, 'r')
    hold on
    plot(deltaY, 'b')
    
end

function [DTobj1, DTobj2] = getInterpolatedDT(map, conf)
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
end

function [X_] = getQueryPoints(imgn, imgm, res)
    cRes = 100;
    qRes = 1;
    
    X_ = zeros((imgn/qRes-(5*cRes/qRes)+1) * (imgm/qRes-(5*cRes/qRes)+1), 2);

    for j=(3*cRes):qRes:imgn-(2*cRes)
        for i=(3*cRes):qRes:imgm-(2*cRes)
            idx = ((j-(3*cRes)))/qRes*(imgm/qRes-(5*cRes/qRes)+1) + (i-(3*cRes))/qRes+1;
            X_(idx,:) = [i*res, j*res];        
        end
    end
end

