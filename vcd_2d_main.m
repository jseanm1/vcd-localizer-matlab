clear all
close all

type = 0;
% 0. Localizer
% 1. Monte Carlo

dataset_sel = 2;
% 1. CAS dataset
% 2. Intel Dataset
% 3. JFR Simulations
% 4. Hospital Dataset

%% Load Map
global map;
global conf;
global sensorCov;

switch dataset_sel
  case 1
    load CAS_map;
    map = imcomplement(im2bw(map_final));
    conf.map_resolution = 0.05;
    conf.laser_reading_max = 20;
    conf.laser_reading_min = 2;

  case 2
    % Intel
    sensorCov = 0.02^2;
    load map_split_clean;
    conf.map_resolution = 0.05; %Map resolution
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  case 3
    % JFR
    sensorCov = 0.5^2;
    load jfr_data
    jfr_process_scans
%     map = flip(map);
    conf.map_resolution = 0.05;
    conf.map_size = size(map).*conf.map_resolution;
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  case 4
    map_final = imread('hospital_section_l.png');
    map = imcomplement(im2bw(map_final));
    conf.laser_reading_max = 4.8;
    conf.laser_reading_min = .1;
    load hospital_test4_02_ws
    conf.map_resolution = 0.02; %Map resolution
    
  otherwise
    error('Please select a valid dataset!');
end

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
global DT1_dxobj;
global DT1_dyobj;
global DT2_dxobj;
global DT2_dyobj;
global DT1_dx2obj;
global DT1_dy2obj;
global DT2_dx2obj;
global DT2_dy2obj;

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
        
    case 3
        n_scans = size(laser_ranges', 1);
        laser = laser_ranges';
        clear odom
        conf.start_index = 70;
%       40:  pose = [69 + 0.194584146142006; 69 + 0.929364144802093; 0];
        pose = [-5.7084 + 70.2;   8.1791 + 70.2;   -0.0429];    
        %pose = [69 + 14.2380; 69 + -9.2832; -0.0204];
        
    case 4
        n_scans = size(GT_laser,1);
        conf.laser_ang_min = -2.356194496154785 ; 
        conf.laser_ang_max = 2.356194496154785 ; 
        conf.laser_res = deg2rad(270/1081); 
        conf.laser_reading_max = 29; 
        conf.laser_reading_min = .1;
        ang = (conf.laser_ang_min : conf.laser_res : conf.laser_ang_max - conf.laser_res);

        laser = GT_laser;

        odom = GT_odom(:,2:4);
        conf.start_index = 2;
        pose = [1220*conf.map_resolution;
            719*conf.map_resolution;
            1.7];
    
    conf.sim = 0;   
end

if type == 0
    %% Run VCD-localizer
    Pose = pose';
    cov = [];

    for i = conf.start_index:n_scans

        if conf.skip_it~=1 % Skip scans default 2 because the otherone is used to make the map
            if(mod(i,conf.skip_it)~=0)
            continue;
            end
        end

        if dataset_sel == 3
            Scan_k = laser{i};
            ang = laser_bearings{i};
        else        
            Scan_k = laser(i, :) ;
        end

        % Calculate velocity
        if exist('odom')
            u_k = [ sqrt( (odom(i,1)-odom(i-conf.skip_it,1))^2 + (odom(i,2)-odom(i-conf.skip_it,2))^2 )   odom(i,3)-odom(i-conf.skip_it,3)];
        else
            u_k = [0.0 0.0];
        end
        
        X_CDin = Pose(end,:) + [-u_k(1)*sin(Pose(end,3)) u_k(1)*cos(Pose(end,3)) -u_k(2)]
        
        if dataset_sel == 3 % For JFR dataset, use GPS to initialize
            X_CDin = gps(i,:) + [70.2 70.2 0];
        end
        
        [tp_2, cov_Xr] = optimizeVCD(X_CDin', Scan_k, ang, conf); % Optimizer
        tp_2
        
%         tp_2 = gt_jfr(i,:)' + [70.45 70.45 0]';
%         tp_2 = Pose(end,:)
%         std_Xr = sqrt(cov_Xr);
%         [std_Xr(1,1) std_Xr(2,2) std_Xr(3,3)]

        if mod(i,1)==0
              draw_laser(tp_2,[Scan_k;ang],conf,[1 0 1]);
%           pause(1);
        end
        Pose(end+1,:)= tp_2';
        cov(i-conf.start_index+1,:,:,:) = cov_Xr;
    end
else
   %% Run Monte Carlo
   if dataset_sel == 3
       iterations = 1000;
       sigma = 0.25;

       pose10 = zeros(iterations, 3);
       pose100 = zeros(iterations, 3);

       initGuess10 = gps(conf.start_index+10,:) + [70.2 70.2 0];
       initGuess100 = gps(conf.start_index+100,:) + [70.2 70.2 0];

       Scan_k = laser{conf.start_index+10};
       ang = laser_bearings{conf.start_index+10};
       
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess10, randScan, ang, conf); % Optimizer
           pose10(i,:) = tp_2';
           plot(tp_2(1,1)/0.05,tp_2(1,2)/0.05, 'rx')
           [1 i]
       end

       [tp_10, cov_Xr10] = optimizeVCD(initGuess10, Scan_k, ang, conf); % Optimizer
       tp_10
       cov_Xr10

       Scan_k = laser{conf.start_index+100};
       ang = laser_bearings{conf.start_index+100};
       
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess100, randScan, ang, conf); % Optimizer
           pose100(i,:) = tp_2';
           [2 i]
       end

       [tp_100, cov_Xr100] = optimizeVCD(initGuess100, Scan_k, ang, conf); % Optimizer
       tp_100
       cov_Xr100
   else
       iterations = 100000;
       sigma = 0.02;

       pose75 = zeros(iterations, 3);
       pose750 = zeros(iterations, 3);

       initGuess75 = [26.1926678977323; 21.6522428977820; -1.57131998766469];
       initGuess750 = [39.1852750940015; 34.8938337056028; -6.20687660689260];

       Scan_k = laser(75,:);
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess75, randScan, ang, conf); % Optimizer
           pose75(i,:) = tp_2';       
       end

       [tp_75, cov_Xr75] = optimizeVCD(initGuess75, Scan_k, ang, conf); % Optimizer
       tp_75
       cov_Xr75

       Scan_k = laser(750,:);
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess750, randScan, ang, conf); % Optimizer
           pose750(i,:) = tp_2';       
       end

       [tp_750, cov_Xr750] = optimizeVCD(initGuess750, Scan_k, ang, conf); % Optimizer
       tp_750
       cov_Xr750
   end
end
