
clear all
clc
close all


path_code = cd;
savepath = [path_code '\results'];
addpath = [path_code '\data']
load('dataset_100.mat');
delays =[1.5 3 6];

%% sorting the age
T = struct2table(resp); % convert the struct array to a table
sortedT = sortrows(T, 'age'); % sort the table by 'DOB'
sorted_resp = table2struct(sortedT);

%%

% x= sorted_resp(1).error*pi/10;%randn(nn,1)
% hist(x)
% [B] = mixtureFit(x,0+zeros(size(x)))
kappa_all=[];
for i=1:length(sorted_resp)
    error_radian = sorted_resp(i).error*pi/10;
    error_radian= error_radian(~isnan(error_radian));
    [B]= mixtureFit(error_radian,0+zeros(size(error_radian)));
    kappa_all=[kappa_all;B(1)];
end
age=[sorted_resp.age];
corrplot([age', kappa_all])
[coef, pval]=corr(age', kappa_all)

sd_all=k2sd(kappa_all);

%% article data

load('Exp_data.mat');

for i=1:length(n_items)
    n1(i)=ismember(n_items(i),1);
end

n1_num=sum(n1==1,'all');
x=error(n1==1);

% bins= [-pi/2:pi/12:pi/2];
[B] = mixtureFit(x,0+zeros(size(x)));
K=B(1);

nBins=25;
binEdges = linspace(-pi, pi, nBins+1);
binCenters = binEdges(1:end-1) + diff(binEdges)/2;

[c,r]=hist(x, binEdges)
bar(r, c/length(x))
scatter(r, c/length(x))





v_x = [-pi:0.01:pi];
p = vonmisespdf (v_x, 0, K)
p1 = plot(v_x,p)





h=(hist(x,13)/1871)
f = fit(bins',h','gauss1')
plot(f)
xlim([-pi/2,pi/2])
hold on
bar(h)


bins= [-pi/2:pi/12:pi/2];
[~, binId] = histc( [x'], bins ) ;
plot(hist(binId, 14)/1871)

for i=1:length(binId)
    bin(i)=ismember(binId(i),i);
end
n1_num=sum(bin7==1,'all');


grouped_bin = accumarray( binId', [x'], [], @(v){v} ) ;
for a= 1: length(grouped_age)
    age_group_error(a)= nanmean(sorted_mean_error(binId==a));
end




figure
nn=100000;
% x= sorted_resp(1).error*pi/10;%randn(nn,1)
% hist(x)
% [B] = mixtureFit(x,0+zeros(size(x)))
t=zeros(length(x),1)
[B] = mixtureFit(x)
K=B(1)


[c,r]=hist(x)
% bar(r,c)
bar(r,c/sum(c))

hold on
% p = vonmisespdf ([-pi:0.01:pi], 0, K)
v_x = [-pi/2:0.01:pi/2];
p = vonmisespdf (v_x, 0, K)
p1 = plot(v_x,p)
p1.LineWidth=6;
hold on

sd = k2sd(K)
y = normpdf(v_x,0,sd);
p2=plot(v_x, y)
p2.LineWidth=2;


