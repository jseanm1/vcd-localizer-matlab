clear all

map = im2bw(imcomplement(imread('x.jpg')));
imshow(map)
resolution = 0.05;

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

            DT1(i,j) = (col - j).*resolution;
            DT2(i,j) = (i - row).*resolution;
        end
    end
end

DT = DT.*resolution;

[X1, X2] = ndgrid(resolution:resolution:m*resolution,resolution:resolution:n*resolution);

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
