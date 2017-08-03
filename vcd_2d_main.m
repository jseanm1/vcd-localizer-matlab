% clear all
close all

dataset_sel = 3;
% 1. CAS dataset
% 2. Intel Dataset

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
