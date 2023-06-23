%% In the name of Allah
% PSTH
% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
function ndass_spiking_activity_01_raster_plot_dataset1()
clear all
close all
clc
path_ = cd;
addpath(genpath([path_ '\function']))
path_dataset= [path_ '\sup'];  % Enter the the path of dataset1 on your system 

%% Parameters
win_  = 60;
psth  = @(x) ndass_smooth(1000*mean(x,1), win_);
T_st  = 1;
T_end = 3001;

% response after stimulus onset
t_h = 1 : 2801;
% response before stimulus onset
t_h = t_h - 500;

%% Load Dataset
load([path_dataset '\dataset1.mat'])

%% Choose a sample neuron
sample_neuron = resp(1).FEF{2};
triInf = resp(1).condition;

%% Preview

figure
% ci = 1, condition 1
ci = 1 ;
% find trials with condition 1
ind_h = find(triInf == ci);
trial_num = 1 : size(ind_h,2);

ax = subplot(1, 2, 1);
hold on
var_h = [];
var_h = sample_neuron(ind_h, :);
var_h = var_h;
plot(t_h, psth(var_h), 'r')
% draw a line for stim onset
line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Firing rate (Hz)');
title(strcat('Condition', num2str(ci)));
text(500,50,strcat(' N = ', num2str(length(ind_h))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'k');
ax.XLim = [-500 2300];
ax.YLim = [0 150];
line([0 0], ylim, 'Color', 'k');

set(gca,'fontsize',14,'fontweight','bold');

% ci = 4, condition 4
ci = 4 ;
ind_h = find(triInf == ci);
trial_num = 1 : size(ind_h, 2);

ax = subplot(1, 2, 2);
hold on
var_h = [];
var_h = sample_neuron(ind_h,:);
var_h = var_h;
plot(t_h, psth(var_h), 'b')
% draw a line for stim onset
line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Firing rate (Hz)');
title(strcat('Condition', num2str(ci)));
text(500,50,strcat(' N = ', num2str(length(ind_h))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'k');
ax.XLim = [-500 2300];
ax.YLim = [0 150];
line([0 0], ylim, 'Color', 'k');
set(gca, 'fontsize', 14, 'fontweight', 'bold');

%% Calculation method 2 single trial firing rate
psth_resp = [];
for tri = 1 : size(triInf, 2)
   
   psth_resp (tri,:) = psth(sample_neuron(tri, :));   
   
end

%% Preview

figure
ax = subplot(1, 1, 1);
hold on

ci = 1;
ind_h1 = find(triInf == ci);
var_h = [];
var_h = psth_resp(ind_h1,:);
var_h = var_h;
ndass_niceplot(var_h, t_h, 1, 1, 0, 0)

ci = 4;
ind_h2 = find(triInf == ci);
var_h = [];
var_h = psth_resp(ind_h2,:);
var_h = var_h;
ndass_niceplot(var_h, t_h , 1, 0, 0, 1)

line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Firing rate (Hz)');
text(500, 70, strcat(' N1 = ', num2str(length(ind_h1))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'r');
text(500, 90, strcat(' N2 = ', num2str(length(ind_h2))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'b');

ax.XLim = [-500 2300];
ax.YLim = [0 150];
line([0 0], ylim, 'Color', 'k');
set(gca,'fontsize', 14, 'fontweight', 'bold');
legend ('In', '', 'Out')

%% Fano Factor 

figure
ax = subplot(1, 1, 1);
hold on

ci = 1;
ind_h1 = find(triInf == ci);
var_h = [];
var_h = psth_resp(ind_h1, :);

var_h =nanstd(var_h, 1)./mean(var_h, 1);
plot(t_h, var_h, 'r')

ci = 4;
ind_h2 = find(triInf == ci);
var_h = [];
var_h = psth_resp(ind_h2, :);

var_h =nanstd(var_h, 1)./mean(var_h, 1); %fanofactor
plot(t_h, var_h, 'b')

line([0 0], ylim, 'color', 'r')                                                 % Insert Onset line
xlabel('Time from sample onset (sec.)');
ylabel('Fano factor(a.u)');
text(500, 70, strcat(' N1 = ', num2str(length(ind_h1))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'r');
text(500, 90, strcat(' N2 = ', num2str(length(ind_h2))), ...
    'fontsize', 18, 'fontweight', 'bold', 'Color', 'b');

ax.XLim = [-500 2300];
% ax.YLim=[0 1];
line([0 0], ylim, 'Color', 'k');
set(gca, 'fontsize', 14, 'fontweight', 'bold');
legend ('In', 'Out')