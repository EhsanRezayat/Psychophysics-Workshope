%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

function uncon_emotion_analysis()
% This code is written for an emotion recognition task analysis
%
% 2021-09-01 last modified
% Ehsan Rezayat &Helia Taghavi
% heliabsb@gmail.com

%  clear all
%  close all
% clc
% 
% %% Load data
% path_code = cd;
% 
% load('resp.mat')
path_ = cd;
path_ = [path_ '\sup\uncon emotion\'];
load([path_ 'resp.mat'])
%% Performance and reaction time for each emotion per each display diuration
legends            = {'joy','disgust','sadness','fear','wonder','anger'};
perf_all_per_em_per_tim = [];
rt_all_per_em_per_tim   = [];
rt_all_per_em_per_tim_cr =[];
rt_all_per_em_per_tim_wr =[];
cl={};

for si = 1 : size(resp,2)
    rec = [];
    rec = resp(si).rec;
    em_sel = resp(si).selected_emotion;
    rec(rec(:,3)>7,3) = rec(rec(:,3)>7,3)-7;
    
    
    emo = categorical({'joy','dis','sad','fear','wond','ang'}); % name of emotion to be displayed on x axis
    
    numOfEmo = length(unique(rec(:,3)));
    times      = unique(rec(:,2));
    
    for ti = 1:length(times)
        
        for ci = 1:numOfEmo
            ind_h = [];
            ind_h = ismember(rec(:,3),[ci ci+7]+1 )& rec(:,2) == times(ti);
            
            bhv = [];
            bhv = (rec(:,3)== em_sel)|(rec(:,3)== em_sel+7);
            
            perf_all_per_em_per_tim(si,ci,ti) = 100*sum(bhv(ind_h))/sum(ind_h);
            rt_all_per_em_per_tim(si,ci,ti)   = nanmean(rec(ind_h,5));
            rt_all_per_em_per_tim_cr(si,ci,ti)   = nanmean(rec(ind_h&bhv,5));
            rt_all_per_em_per_tim_wr(si,ci,ti)   = nanmean(rec(ind_h&(~bhv),5));
            
        end
    end
end

%% Total performance and reaction time on each displayed emotion (regardless of display diuration)
perf_all_per_em = [];
rt_all_per_em   = [];
for si = 1 : size(resp,2)
    rec = [];
    rec = resp(si).rec;
    em_sel = resp(si).selected_emotion;
    
    rec(rec(:,3)>7,3) = rec(rec(:,3)>7,3)-7;
    
    emo = categorical({'joy','dis','sad','fear','wond','ang'}); % name of emotion to be displayed on x axis
    
    numOfEmo = length(unique(rec(:,3)));
    times      = unique(rec(:,2));
    
    
    for ci = 1:numOfEmo
        ind_h               = [];
        ind_h               = ismember(rec(:,3),[ci ci+7]+1 );
        
        bhv = [];
        bhv = (rec(:,3)== em_sel)|(rec(:,3)== em_sel+7);
        
        perf_all_per_em(si,ci) = 100*sum(bhv(ind_h))/sum(ind_h);
        rt_all_per_em(si,ci)   = nanmean(rec(ind_h,5));
        
    end
    
end

%%
figure

for pm=1:6
    newcolors =[0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];
%     subplot(1,2,1);
    xlabel('Display diuration (ms)')
    ylabel('Mean Performance on all subjects (%)')

     plot(times, nanmean(squeeze(perf_all_per_em_per_tim(:,pm,:))),'LineWidth',4)
         hold on
     e=errorbar(times,nanmean(squeeze(perf_all_per_em_per_tim(:,pm,:))),nanstd(squeeze(perf_all_per_em_per_tim(:,pm,:)))/sqrt(size(perf_all_per_em_per_tim,1)),'HandleVisibility','off','Color',newcolors(pm,:),'LineWidth',2);

    legend(legends,'Location','northwest')
    xlim([15,55]);
    ylim([10 100]);
    title('Performance')
        set (gca, 'FontSize' ,15)
end
figure
for pm=1:6
%     subplot(1,2,2);
    xlabel('Display diuration (ms)')
    ylabel('Mean Reaction Time on all subjects (sec)')
     plot(times, nanmean(squeeze(rt_all_per_em_per_tim(:,pm,:))),'LineWidth',4)
        hold on

     errorbar(times,nanmean(squeeze(rt_all_per_em_per_tim(:,pm,:))),nanstd(squeeze(rt_all_per_em_per_tim(:,pm,:)))/sqrt(size(rt_all_per_em_per_tim,1)),'HandleVisibility','off','Color',newcolors(pm,:),'LineWidth',2)

    legend(legends,'Location','northwest')
%     ylim([0,100]);
    xlim([15,55]);
    title('Reaction Time')
    set (gca, 'FontSize' ,15)
end
% Total performance and reaction time on each display diuration (regardless of displayed emotion)
perf_all_per_tim = [];
rt_all_per_tim   = [];
for si = 1 : size(resp,2)
    rec = [];
    rec = resp(si).rec;
    em_sel = resp(si).selected_emotion;
    
    rec(rec(:,3)>7,3) = rec(rec(:,3)>7,3)-7;
    
    
    emo = categorical({'joy','dis','sad','fear','wond','ang'}); % name of emotion to be displayed on x axis
    
    numOfEmo = length(unique(rec(:,3)));
    times      = unique(rec(:,2));
    
    for ti = 1:length(times)
        
        ind_h               = [];
        ind_h               = rec(:,2) == times(ti);
        
        bhv = [];
        bhv = (rec(:,3)== em_sel)|(rec(:,3)== em_sel+7);
        
        perf_all_per_tim(si,ti) = 100*sum(bhv(ind_h))/sum(ind_h);
        rt_all_per_tim(si,ti)   = nanmean(rec(ind_h,5));
        
    end
    
end

%% Preview total performance and reaction time on each display diuration

figure;
subplot(1,2,1)
plot(times,perf_all_per_tim','LineWidth',2);
ticks = [7 10 20 30 50 70 100];
% xticks(ticks)
xlabel('Display Diuration(ms)')
ylabel('Percent Correct(%)')
title('Performance')
set(gca, 'fontsize', 14, 'fontweight', 'bold');

subplot(1,2,2)
plot(times,rt_all_per_tim','LineWidth',2);
ticks = [7 10 20 30 50 70 100];

xlabel('Display Diuration(ms)')
ylabel('Reaction Time(sec)')
title('Reaction Time')
set(gca, 'fontsize', 14, 'fontweight', 'bold');

%% Sample Fitting logistic regression to sample data

si = 2;
ci = 1;
p_ = round(squeeze(perf_all_per_em_per_tim(si,ci,:))/100*10);

PF = [];
x = times;
y = p_;
n = 10*ones(6,1) ;

b = glmfit(times,[y n],'binomial','link','logit');

yfit = glmval(b,x,'logit','size',n);
figure
plot(x,100* y./n,'ko',x,100*yfit./n,'r-','LineWidth',2)
hold on
plot(x,100*y./n,'LineWidth',1,'Color', 'k')
xlabel('Presentation Time(ms)')
ylabel('Percent Correct(%)')
set(gca, 'fontsize', 20);

xlabel('Display Diuration (ms)');
ylabel('Correct Response(%)');
% ylim([0,1]);
% legend(legends,'Location','southeast')
title('Performance');
set(gca, 'fontsize', 14, 'fontweight', 'bold');
legend('Measured','Fitted')

%% Fitting logistic regression to data
model_p =[];
for si = 1 : 15
    for ci = 1: 6
        p_ = round(squeeze(perf_all_per_em_per_tim(si,ci,:))/100*10);
        
        PF = [];
        x = times;
        y = p_;
        n = 10*ones(6,1) ;
        
        b = glmfit(times,[y n],'binomial','link','probit');
        model_p(si,ci,:) =b;
        % yfit = glmval(b,x,'probit','size',n);
        % plot(x, y./n,'o',x,yfit./n,'-','LineWidth',2)
    end
    
end
tresh =-1*squeeze(model_p(:,:,1))./squeeze(model_p(:,:,2));
sensitivity = squeeze(model_p(:,:,2));

%% Removoing out of range data
tresh (tresh >100) =nan; tresh (tresh <-100) =nan;

%% Preview threshold and sestivity of model fitting displayed emotion
figure;
 ax = subplot(1,1,1);
hold on
% bar(1:6,perf_all_per_em)

mBar=bar(1:6,nanmean(squeeze(tresh(:,:))),'FaceColor','g');
errorbar(1:6,nanmean(tresh(:,:)),nanstd(tresh(:,:))/sqrt(size(tresh,1)),'LineWidth',2,'Color','k','LineStyle','none')
ax.XTick = [1:6];
ax.XTickLabel = legends;
ax.XTickLabelRotation = 45;
xlabel('Emotions')
ylabel('Threshold (ms)')
title('Threshold')
set(gca, 'fontsize', 20);
axis ([0 7 -5 70])
% mBar.BarWidth=0.9;
% mBar.LineWidth=.5
% mBar.FaceColor=[0 0.6 0.6];
% set(gca,'YGrid','on');
% set(gca,'XGrid','on');

set(gcf,'inverthardcopy','off'); 
figure;
 ax = subplot(1,1,1);
hold on
bar(1:6,nanmean(squeeze(sensitivity(:,:))),'FaceColor','g')
errorbar(1:6,nanmean(sensitivity(:,:)),nanstd(sensitivity(:,:))/sqrt(size(sensitivity,1)),'LineWidth',2,'Color','k','LineStyle','none')
ax.XTick = [1:6];
ax.XTickLabel = legends;
ax.XTickLabelRotation = 45;

xlabel('Emotions')
ylabel('Sensitivity (a.u.)')
title('Sensitivity')
set(gca, 'fontsize', 20);
axis ([0 7 -0.05 0.5])

set(gcf, 'Color', [0.97 0.97 0.97]);
