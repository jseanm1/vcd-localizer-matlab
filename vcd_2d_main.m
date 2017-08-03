% clear all
close all

dataset_sel = 2;
% 1. CAS dataset
% 2. Intel Dataset

%% Set conf 
conf.skip_it = 1; % Skip scans default 2 because the otherone is used to make the map

% Draw settings
conf.draw_ellipses = 0;
conf.animate_ellipses = 0;
conf.draw_path = 0;
conf.half_draw = 0; %Do not draw laser readings
conf.laser_hold=0; % persistant laser readings
conf.debug = 5; % Draw interval

conf.rec_video = 0; % record video

%% Load Map
global map;
global conf;

switch dataset_sel
  case 1
    load CAS_map;
    map = imcomplement(im2bw(map_final));
    conf.laser_reading_max = 20;
    conf.laser_reading_min = 2;

  case 2
    % Intel
    load map_split_clean;
    conf.map_resolution = 0.05; %Map resolution
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  otherwise
    error('Please select a valid dataset!');
end

global mapsize;
conf.map_size = size(map).*conf.map_resolution;
mapsize = conf.map_size;

%% Generate DTs
global DT;
global DT1;
global DT2;
global DTobj;
global DTobj1;
global DTobj2;
global X_ort;

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
            DT2(i,j) = (i - row).*conf.map_resolution;
        end
    end
end

[X1, X2] = ndgrid(conf.map_resolution:conf.map_resolution:conf.map_size(1),conf.map_resolution:conf.map_resolution:conf.map_size(2));

DTobj = griddedInterpolant(X1, X2, DT, 'cubic');
DTobj1 = griddedInterpolant(X1, X2, DT1, 'cubic');
DTobj2 = griddedInterpolant(X1, X2, DT2, 'cubic');

%% Map draw initialisation
global lasermap, global draw_init
draw_init = 0;
figure(11);
lasermap=subplot(1,1,1);
imshow(imcomplement(map));
hold on
%% Load Datasets
switch dataset_sel
    case 1
        load CAS_dataset_ppl
        n_scans = size(CASlaser,1);
        ang = [(-180/2+.25):0.25:(180/2)]/180*pi;
        laser= CASlaser;
        odom = CASodom;
        conf.start_index = 1320;
        pose = [28.44,21.56791,1.753]';

        conf.sim = 0;
    
    case 2
        load intelraw_laser;
        load intelraw_odom;
        n_scans = size(raw_laser,1);
        ang = [(-180/2+0.5):1:(180/2)]/180*pi;
        laser = raw_laser;
        odom= raw_odom;
        conf.start_index = 10;
        pose = [520*conf.map_resolution;
          430*conf.map_resolution;
          -1.7];
        conf.sim = 0;
        zoom(2);
        
end

%% Run VCD-localizer
for i = conf.start_index:n_scans
    
    if conf.skip_it~=1 % Skip scans default 2 because the otherone is used to make the map
        if(mod(i,conf.skip_it)~=0)
        continue;
        end
    end

    Scan_k = laser(i, :) ;
    Pose = pose';

    % Calculate velocity
    if exist('odom')
    u_k = [ sqrt( (odom(i,1)-odom(i-conf.skip_it,1))^2 + (odom(i,2)-odom(i-conf.skip_it,2))^2 )   odom(i,3)-odom(i-conf.skip_it,3)];
    else
    u_k = [0.0 0.0];
    end

    X_CDin = Pose(end,:) + [-u_k(1)*sin(Pose(end,3)) u_k(1)*cos(Pose(end,3)) -u_k(2)];
    [tp_2, jacobian] = optimizeVCD(X_CDin', Scan_k, ang, conf); % Optimizer

    if mod(i,50)==0
      draw_laser(tp_2,[Scan_k;ang],conf,[0 0 1]);
    end
    Pose(end+1,:)= tp_2' ; 
end
