%% Get Laser readings out of Laser File
function [X_ort] = laser_read(X_ort_raw, conf)

X_ort = X_ort_raw;

lsi = find(X_ort(1,:) < conf.laser_reading_max);
X_ort = X_ort(:,lsi);

lsi = find(X_ort(1,:) > conf.laser_reading_min);
X_ort = X_ort(:,lsi);

end