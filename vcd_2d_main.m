clear all
close all

type = 0;
% 0. Localizer
% 1. Monte Carlo

dataset_sel = 4
% 1. CAS dataset
% 2. Intel Dataset
% 3. JFR Simulations
% 4. Hospital Dataset
% 5. Kentland Dataset
% 6. PR2 Dataset
% 7. Intel Padded
% 8. Intel partial1
% 9. Intel partial3
% 10. CAS LAB 7 sept 18
% 11  CAS LAB mapping
% 12 Freiburg Map A 2

%% Load Map
global map;
global conf;
global sensorCov;

global t_optimizer;
global t_cov;

global observations;

observations = {};

t_optimizer = [];
t_cov = [];

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
    sensorCov = 0.75^2;
%     load jfr_data
%     jfr_load_data
%     jfr_process_scans
%     map = flip(map);
%     load icra_jfr_dataset3_localized;
    conf.map_resolution = 0.05;
    conf.map_size = size(map).*conf.map_resolution;
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  case 4
    sensorCov = 0.02^2;
    map_final = imread('hospital_section_l.png');
    map = imcomplement(im2bw(map_final));
    conf.laser_reading_max = 29.0;
    conf.laser_reading_min = 0.1;
    load hospital_test4_02_ws
    conf.map_resolution = 0.05; %Map resolution
    
  case 5
    sensorCov = 1^2;
    kentland_load_data
    kentland_process_scans
    conf.map_resolution = 0.05;
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  case 6
    load pr2_data.mat
    map = imread('pr2_map_0.05.png');
    sensorCov = 0.02^2; 
    
  case 7
    map = imread('intel_padded_0.05.png');
    sensorCov = 0.02^2;
    conf.map_resolution = 0.05; %Map resolution
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
  
  case 8
    sensorCov = 0.02^2;
    map = imread('intel_partial.png');
    conf.map_resolution = 0.05; %Map resolution
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
    
  case 9
    sensorCov = 0.02^2;
    map = imread('intel_partial3.png');
    conf.map_resolution = 0.05; %Map resolution
    conf.laser_reading_max = 30;
    conf.laser_reading_min = .5;
        
  case 10
    sensorCov = 0.02^2;
    load cas_lab_map_new.mat
    conf.map_resolution = res;
    map = mat;
    conf.laser_reading_max = 5;
    conf.laser_reading_min = 0.75; 
    
  case 11
    sensorCov = 0.02^2;
    load cas_lab_map_new.mat
    conf.map_resolution = res;
    map = mat;
    conf.laser_reading_max = 5;
    conf.laser_reading_min = 0.75;
    
    case 12
        sensorCov = 0.02^2;
        load freiburg_map.mat
        map = imcomplement(map);
        conf.map_resolution = 0.05;
        conf.laser_reading_max = 30;
        conf.laser_reading_min = 01;
        conf.map_size = size(map).*conf.map_resolution;
    
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

            DT1(i,j) = (col - j);
            DT2(i,j) = (row - i);
        end
    end
end

[dt1_dx, dt1_dy] = gradient(DT1);
[dt2_dx, dt2_dy] = gradient(DT2);

DT1 = DT1.*conf.map_resolution;
DT2 = DT2.*conf.map_resolution;

[X1, X2] = ndgrid(conf.map_resolution:conf.map_resolution:conf.map_size(1),conf.map_resolution:conf.map_resolution:conf.map_size(2));

DTobj = griddedInterpolant(X1, X2, DT, 'cubic');
DTobj1 = griddedInterpolant(X1, X2, DT1, 'cubic');
DTobj2 = griddedInterpolant(X1, X2, DT2, 'cubic');

DT1_dxobj = griddedInterpolant(X1, X2, dt1_dx, 'cubic');
DT1_dyobj = griddedInterpolant(X1, X2, dt1_dy, 'cubic');

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
% %% Load Datasets
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
        laser = raw_laser + 0.01*randn(size(raw_laser));
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
        conf.start_index = 1;
%       40:  pose = [69 + 0.194584146142006; 69 + 0.929364144802093; 0];
%         pose = [9.9 + 70.2;   9.9 + 70.2;   -0.0429];  
        pose = [70.2; 70.2; 0]; % iciis_1
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
        conf.start_index = 45;
        pose = [1220*conf.map_resolution;
            719*conf.map_resolution;
            1.6];
        conf.sim = 1;
        
    case 5
        n_scans = size(laser_ranges', 1);
        laser = laser_ranges';
        clear odom
        conf.start_index = 50 ;
%         pose = [2000*conf.map_resolution; 2000*conf.map_resolution; 0];
        pose = gt_jfr(1,:)' + [135; 110; pi/2];
        zoom(2)
        
    case 6
        n_scans = size(laser, 1);
        conf.start_index = 1200;
        ang = -pi/2 : conf.laser_res : pi/2 - conf.laser_res
        pose = [690*0.05; 540*0.05; 0];
%         pose = [44.86; 24.54; -pi/2];

    case 7
        load intelraw_laser;
        load intelraw_odom;
        n_scans = size(raw_laser,1);
        ang = [(-180/2+0.5):1:(180/2)]/180*pi;
        laser = raw_laser;
        odom= raw_odom;
        conf.start_index = 10;
        pose = [620*conf.map_resolution;
          530*conf.map_resolution;
          -1.7];
        conf.sim = 0;
%         zoom(2);

    case 8
        load intelraw_laser;
        load intelraw_odom;
%         n_scans = size(raw_laser,1);
        n_scans = 100;
        ang = [(-180/2+0.5):1:(180/2)]/180*pi;
        laser = raw_laser;
        odom= raw_odom;
        conf.start_index = 10;
        pose = [220*conf.map_resolution;
          350*conf.map_resolution;
          -1.57];
        conf.sim = 0;
        
    case 9
        load intelraw_laser;
        load intelraw_odom;
%         n_scans = size(raw_laser,1);
        n_scans = 4920;
        ang = [(-180/2+0.5):1:(180/2)]/180*pi;
        laser = raw_laser;
        odom= raw_odom;
        conf.start_index = 4900;
        pose = [125*conf.map_resolution;
          30*conf.map_resolution;
          0];
        conf.sim = 0;
        
    case 10
        load 7_sep_cas_lab.mat
        ang = angles;
        conf.start_index = 2;
        pose = [7.75; 8.25; -1.2;];
        n_scans = length(laser);
        conf.sim = 0;
        
    case 11
        load icra_mapping_1_2018.mat
        ang = angles;
        conf.start_index = 2;
        pose = [8.0; 9.5; -1.2;];
        n_scans = length(laser);
        conf.sim = 0;
        
    case 12
        load freiburg_A_cloudy_2.mat
        ang = [-pi/2:pi/180:pi/2];
        conf.start_index = 260;
        pose = [12.25; 15.0; 3.0107];
        n_scans = length(laser);
        laser = laser(:,2:end);
end

if type == 0
    %% Run VCD-localizer
    Pose = pose';
    cov = [];
    
    estimates = {};

    for i = conf.start_index:conf.skip_it:n_scans
        i
        if conf.skip_it~=1 % Skip scans default 2 because the otherone is used to make the map
            if(mod(i,conf.skip_it)~=0)
            continue;
            end
        end

        if dataset_sel == 3 || dataset_sel == 5
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
        
        if isfield(conf, 'sim')&&conf.sim
            % Add noise to the measurement
            Scan_k = Scan_k + sqrt(sensorCov).*randn(size(Scan_k));
            u_k(1) = u_k(1) + 0.04.*randn(size(u_k(1))); %0.04 linaer velocity noise
            u_k(2) = u_k(2) + 0.000001.*randn(size(u_k(2))); %0.01 angular velocity noise
        end
        
        X_CDin = Pose(end,:) + [-u_k(1)*sin(Pose(end,3)) u_k(1)*cos(Pose(end,3)) -u_k(2)];
%         X_CDin = Pose(end,:) + [u_k(1)*sin(Pose(end,3)) u_k(1)*cos(Pose(end,3)) u_k(2)];

        if dataset_sel == 3 % For JFR dataset, use GPS to initialize
            X_CDin = gps(i,:) + [70.2 70.2 -1.5707];
        elseif dataset_sel == 5
%             X_CDin = Pose(end,:);
              X_CDin = gt_jfr(i,:) + [130 113 pi-0.6632];
        end
        
%         [tp_2, cov_Xr, residual] = optimizeVCD(X_CDin', Scan_k, ang, conf); % Optimizer
          tp_2 = optimizeVCD(X_CDin', Scan_k, ang, conf); % Optimizer
%         tp_2 = gt_jfr(i,:) + [70.2 70.2 -1.5707];
%         cov_Xr
%         tp_2
%         2*sqrt(cov_Xr)
%         tp_2 = X_CDin';
        if mod(i,1)==0
            draw_laser(tp_2,[Scan_k;ang],conf,[1 0 1]);
        end
        Pose(end+1,:)= tp_2';
%         cov(end+1,:,:,:) = cov_Xr;
        
%         tempEstimate = {};
%         tempEstimate.cov = cov_Xr;
%         tempEstimate.residual = residual;
%         
%         estimates{end+1} = tempEstimate;
       
    end
else
   %% Run Monte Carlo
   sigma = sqrt(sensorCov);
   if dataset_sel == 3
       iterations = 30000;

       pose10 = zeros(iterations, 3);
       pose100 = zeros(iterations, 3);

       initGuess10 = gt_jfr(conf.start_index+10,:) + [70.2 70.2 0];
       initGuess100 = gt_jfr(conf.start_index+100,:) + [70.2 70.2 0];

       Scan_k = laser{conf.start_index+10};
       ang = laser_bearings{conf.start_index+10};
       
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess10, randScan, ang, conf); % Optimizer
           pose10(i,:) = tp_2';
           [1 i]
       end

       poseMean10 = mean(pose10);
       X_ort = laser_read([Scan_k; ang], conf);
       cov_Xr10 = calcUncertainty(X_ort, poseMean10);

       Scan_k = laser{c25onf.start_index+100};
       ang = laser_bearings{conf.start_index+100};
       
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess100, randScan, ang, conf); % Optimizer
           pose100(i,:) = tp_2';
           [2 i]
       end

       poseMean100 = mean(pose100);
       X_ort = laser_read([Scan_k; ang], conf);
       cov_Xr100 = calcUncertainty(X_ort, poseMean100);
   else
       iterations = 10000;

       pose40 = zeros(iterations, 3);
       pose75 = zeros(iterations, 3);
       pose750 = zeros(iterations, 3);
       pose828 = zeros(iterations, 3);

       initGuess40 = [26.0919;   21.6326;   -1.5532];
       initGuess75 = [26.1926678977323; 21.6522428977820; -1.57131998766469];
       initGuess750 = [39.1852750940015; 34.8938337056028; -6.20687660689260];
       initGuess828 = [38.8554;   39.1983;   -6.1602];

       
       Scan_k = laser(48,:);
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess40, randScan, ang, conf); % Optimizer
           pose40(i,:) = tp_2';       
       end

       poseMean40 = mean(pose40);
       X_ort = laser_read([Scan_k;ang],conf);
       cov_Xr40 = calcUncertainty(X_ort, poseMean40);
       
       Scan_k = laser(836,:);
       for i=1:iterations
           randScan = normrnd(Scan_k, sigma);
           [tp_2] = optimizeVCD(initGuess828, randScan, ang, conf); % Optimizer
           pose828(i,:) = tp_2';       
       end

       poseMean828 = mean(pose828);
       X_ort = laser_read([Scan_k;ang],conf);
       cov_Xr828 = calcUncertainty(X_ort, poseMean828);
       
%        Scan_k = laser(75,:);
%        for i=1:iterations
%            randScan = normrnd(Scan_k, sigma);
%            [tp_2] = optimizeVCD(initGuess75, randScan, ang, conf); % Optimizer
%            pose75(i,:) = tp_2';       
%        end
% 
%        [tp_75, cov_Xr75] = optimizeVCD(initGuess75, Scan_k, ang, conf); % Optimizer
%        tp_75
%        cov_Xr75
% 
%        Scan_k = laser(750,:);
%        for i=1:iterations
%            randScan = normrnd(Scan_k, sigma);
%            [tp_2] = optimizeVCD(initGuess750, randScan, ang, conf); % Optimizer
%            pose750(i,:) = tp_2';       
%        end
% 
%        [tp_750, cov_Xr750] = optimizeVCD(initGuess750, Scan_k, ang, conf); % Optimizer
%        tp_750
%        cov_Xr750
   end
end
