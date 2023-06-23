%% In the name of Allah
% Rasterplot  preview 
% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * * 
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *  
function ndass_spiking_activity_02_psth_dataset1()


clear all
close all
clc

% path_dataset= 'E:\Jalal\WorkShop\Workshop_TA_NDAS2_2021\NDASS codes\session 8 rate coding 1';  % Enter the the path of dataset1 on your system 

path_ = cd;
addpath(genpath([path_ '\function']))
path_dataset= [path_ '\sup'];  % Enter the the path of dataset1 on your system 

%% Parameters
% response after stimulus onset
time_stamps = 1 : 2801;
% response before stimulus onset
time_stamps = time_stamps - 500;

%% Load Dataset
load([path_dataset '\dataset1'])

%% Choose a sample neuron
sample_neuron = resp(1).FEF{1};
triInf = resp(1).condition;

%% Raster Plot
figure

%%% raster plot for condtion 1
% ci = 1, condition 1
ci = 1;  
% find trials with condition 1
ind_h = find(triInf == ci);
trial_num = 1:size(ind_h, 2);

ax = subplot(1, 2, 1);
hold on 
var_h = [];
var_h = sample_neuron(ind_h, :);
% % % var_h = var_h;
imagesc(time_stamps, trial_num,var_h)           
colormap(flipud(colormap('gray')));
% [xPoints, yPoints] = plotSpikeRaster(var_h,'PlotType','vertline');
% draw a line for stim onset
line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Trial number (#)');
title(strcat('Condition',num2str(ci)));
text(500, 12, strcat(' N = ', num2str(length(ind_h))),...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'r');
line([0 0], ylim, 'Color', 'r');
ax.XLim = [-300 2300]; 
ax.YLim = [0 length(trial_num)];
set(gca, 'fontsize', 14, 'fontweight', 'bold');


%%% Repeate for condtion 4
% ci = 4, condition 4
ci = 2;
ind_h = find(triInf == ci);
trial_num = 1 : size(ind_h, 2);

ax = subplot(1, 2, 2);
hold on 
var_h = [];
var_h = sample_neuron(ind_h,:);
var_h = var_h;
imagesc(time_stamps,trial_num,var_h)           
colormap(flipud(colormap('gray')));
% [xPoints, yPoints] = plotSpikeRaster(var_h,'PlotType','vertline');
% draw a line for stim onset
line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Trial number (#)');
title(strcat('Condition',num2str(ci)));
text(500, 12, strcat(' N = ',num2str(length(ind_h))),...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'r');
line([0 0], ylim, 'Color', 'r');
ax.XLim = [-300 2300]; 
ax.YLim = [0 length(trial_num)];
set(gca, 'fontsize', 14, 'fontweight', 'bold');
% ax.XTick=[0 0.300 1.300];
% ax.YTick=[0 0.5];
