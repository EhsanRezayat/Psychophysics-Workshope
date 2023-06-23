%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #4 Input output file & Plotting  
path_code = cd;
addpath(genpath([path_code '\sup']))

%% Saving variables

age            =30;
employee       ='chef';
mycell         ={'hello',2};
patient(2).name='Jone Doe';
patient(2).test=[79,72];
score          =100;

who;
whos;

save('matlabclass1');
clear;
who;

load('matlabclass1');
who;

save('onevar.mat','patient','employee');
clear;
who;
load('onevar');
who;
%% Working with files
load ch08filename.mat
datafile     = load ('ch08filename.mat');
%the ch08filename.mat contains three variables: frex, timevec,and tf_data.

data         = cell(5,1);
for fi       = 1:5
    data{fi} = load(['data_rat' num2str(fi) '.mat']);
end
path_code = cd;
path_code =[path_code '\sup'];
files1       = dir(strcat(path_code,'\*rat*.mat'));

filedir      = path_code; 
files        = dir([ filedir '\*rat*.mat' ]);
data         = cell(size(files));
for fi       = 1:length(files)
    data{fi} = load([ filedir '\' files(fi).name ]); 
end
%% Writing to files
%example 1
myFileID = fopen('testfile.txt','w');
xf       = 100;
fprintf(myFileID,'X is equal to %d\n',xf);
outPut1  = fclose(myFileID);

outPut2  = fopen('/usr/bin/test.txt','w');
%% Writing to files

x               = [1:10];
y               = x .^3;
myExponentsFile = fopen('e.txt','w');
fprintf(myExponentsFile,'%d %d\n',[x;y]);
fclose(myExponentsFile);
%% Writing to files
%example 3
x = rand(5);
csvwrite('randomvalues.csv',x);
clear all
x = csvread('randomvalues.csv');
%% Writing to files
%example 4
logFID = fopen('log.txt');
data   = textscan(logFID,'%s %f %f %f %f %f %f');
data 
subjectcodes = data{1};
subjectcodes
fclose(logFID);
   

%% Plot lines
figure
%example 1
x = -10:2:20;
y = x.^2;
plot(x,y)
%% Plot lines
figure
%example 2
plot(1:10);
%% Plot lines
%example 3
figure
cla
plot(x,y/50,'r');
 hold on;
plot(x,log(y),'k'); % log is the natural log
plot(x,y.^(1/3),'m');

%% Plot lines:linewidth
%example 4
figure
plot(x,y,'ro-','linewidth',3)
hold on
plot(x,2*y,'r*--','linewidth',1) % default with is 1
%% Plot lines:legend
%example 5
figure
plot(x,y,'y-',x,y,'go');
hold on
plot(x,2*y,'bp');
hold on
plot(x,log(y),'c+:'); 
legend({'y=x^2';'y=2(x^2)' ;'2*y';'y=log(x^2)'});
%% Plot lines:hold on-hold off
%example 6
figure
plot(x,y);
hold on;
plot(x,log(y));
hold off;
plot(x,y.^(1/3));
%% Plot lines:hold on-hold off
%example 7
figure
x  = linspace(0,pi);
y1 = cos(x);
plot(x,y1);
hold on
y2 = cos(2*x);
plot(x,y2,'r');
hold on;
y3 = cos(3*x);
plot(x,y3,'g');
legend('cos(x)','cos(2x)','cos(3x)');
%% Plot lines:title
%example 8
figure
plot((1:10).^2)
title('My Title');

%% Plot lines: xlabel-ylabel
%example 9
figure
plot((1:10).^2)
xlabel('Population');
ylabel({2010;'Population';'in Years'});
%% Plot lines: xlabel-ylabel
%example 10
figure
% Create data and 2-by-1 tiled chart layout
x              = linspace(-2*pi,2*pi);
y1             = sin(x);
y2             = cos(x);
p              = plot(x,y1,x,y2);
% p(1).LineWidth = 2;
% p(2).Marker    = '*';
title('Plot')
xlabel('(X)','FontSize',12,...
       'FontWeight','bold','Color','g');

ylabel('(Y)','FontSize',12,...
       'FontWeight','bold','Color','r');
%% Plot lines: axis
figure
x = linspace(0,2*pi);
y = sin(x);
plot(x,y,'-o');

 axis([0 2*pi -1.5 1.5]);

%% Bar plot
figure
%example 1
bar(x,y,.2);
%% Bar plot
%example 2
figure
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
bar(y);
%% Bar plot
%example 3
figure
y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
bar(y);
%% Bar plot
%example 4
figure
y = [2 2 3; 2 5 6; 2 8 9; 2 11 12];
bar(y,'stacked');
%% Bar plot
%example 5
figure
y = [75 91 105 123.5 131 150 179 203 226 249 281.5];
bar(y,'FaceColor',[1 0 1],'EdgeColor',[0.6 .9 .9],'LineWidth',1.5);

%% errorbar
%example 1
figure
x   = 1:10:100;
y   = [20 30 45 40 60 65 80 75 95 90];
err = 8*ones(size(y));
errorbar(x,y,err);
%% errorbar
%example 2
figure
x   = linspace(0,10,15);
y   = sin(x/2);
err = 0.3*ones(size(y));
errorbar(x,y,err,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
%% errorbar
%example 3
figure
x = 1:2:20;
y = x.^2;
bar(x,y);
hold on
e = 100*rand(size(x));
errorbar(x,y,e) % symmetric
% errorbar(x,y,e/2,e/8) % asymmetric
% errorbar(x,y,e,'.');

%% Scatter
%example 1
figure
scatter(x,y,'o');
%% Scatter
%example 2
figure
x  = linspace(0,3*pi,200);
y  = cos(x) + rand(1,200);
sz = linspace(1,100,200);
scatter(x,y,sz);
%% Scatter
%example 3
figure
n      = 100;
frate  = linspace(10,40,n) + 10*rand(1,n);
fvar   = frate + 5*randn(1,n);
ndepth = linspace(100,1000,n);
scatter(frate,fvar,100,ndepth,'filled');
%% Scatter
%example 4
figure
theta = linspace(0,2*pi,150);
x     = sin(theta) + 0.75*rand(1,150);
y     = cos(theta) + 0.75*rand(1,150);  
sz    = 140;
scatter(x,y,sz,'d');
%% Scatter
%example 5
figure
theta = linspace(0,2*pi,300);
x     = sin(theta) + 0.75*rand(1,300);
y     = cos(theta) + 0.75*rand(1,300);  
sz    = 40;
scatter(x,y,sz,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);

%% subplot
%example 1
figure
subplot(2,1,1);
x  = linspace(0,10);
y1 = sin(x);
plot(x,y1);
subplot(2,1,2); 
y2 = sin(5*x);
plot(x,y2);
%% subplot
%example 2
figure
subplot(2,2,1)
x  = linspace(0,10);
y1 = sin(x);
plot(x,y1);
title('Subplot 1: sin(x)');

subplot(2,2,2)
y2 = sin(2*x);
plot(x,y2);
title('Subplot 2: sin(2x)');

subplot(2,2,3)
y3 = sin(4*x);
plot(x,y3);
title('Subplot 3: sin(4x)');

subplot(2,2,4)
y4 = sin(8*x);
plot(x,y4);
title('Subplot 4: sin(8x)');
%% subplot
%example 3
figure
subplot(2,2,1);
x     = linspace(-3.8,3.8);
y_cos = cos(x);
plot(x,y_cos);
title('Subplot 1: Cosine')

subplot(2,2,2);
y_poly = 1 - x.^2./2 + x.^4./24;
plot(x,y_poly,'g');
title('Subplot 2: Polynomial');

subplot(2,2,[3,4]);
plot(x,y_cos,'b',x,y_poly,'g');
title('Subplot 3 and 4: Both');
%% subplot
%example 4
figure
for k = 1:4
    ax(k) = subplot(2,2,k);
end

subplot(ax(2))
x = linspace(1,50);
y = sin(x);
plot(x,y,'Color',[0.1, 0.5, 0.1]);
title('Second Subplot');
axis([0 50 -1 1]);


%%  Experiment 

SOA = 20*randn(1000,1);

figure 
subplot(211)
hist(SOA)
Precent_Response  = 100./(1+exp(-(SOA-0)/3.5));


subplot(212)
scatter(SOA,Precent_Response)
xlabel('SOA (ms)')
ylabel('Preformance (%)')

