dat = pose750(:,1:2);
n = hist3(dat, [150,400]);
n1 = n';
% n1(size(n,1) + 1, size(n,2) + 1) = 0;
xb = linspace(min(dat(:,1)),max(dat(:,1)),size(n,1));
yb = linspace(min(dat(:,2)),max(dat(:,2)),size(n,2));
h = pcolor(xb,yb,n1);
h.ZData = ones(size(n1)) * -max(max(n));
colormap(hot) % heat map
title('Seamount:Data Point Density Histogram and Intensity Map');
grid on
view(3);
