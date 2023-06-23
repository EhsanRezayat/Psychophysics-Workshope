%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

function emotion_analysis()
clear all
% close all
clc 
%% Load data
path_ = cd;
path_ = [path_ '\sup\emotion\'];
load([path_ 'eye_tracker_sample_data_psychology.mat'])
em_name = {'Ang' 'Dis' 'Fea' 'Joy' 'Neu' 'Sad' 'Sur'};


%% Perfomance
pref_all_con = []; pref_all_uncon=[];
pref_all_con_per_em=[];pref_all_uncon_per_em=[];
for ss=1:size(data,2)
  pref_all_uncon(ss) = 100*sum(data{ss}.bhv==1)/length(data{ss}.bhv);

for ci =1:7

 ind_h = [];ind_h = ismember(data{ss}.conditions,[ci ci+7]);
 pref_all_uncon_per_em(ss,ci) = 100*sum(data{ss}.bhv(ind_h)==1)/length(data{ss}.bhv(ind_h));
 rt_all_uncon_per_em(ss,ci) = nanmean(data{ss}.times(ind_h,5)-data{ss}.times(ind_h,4));

end
end

%% Preview perforamnce
figure('name','Performance')
ax = subplot(121);
hold on
errorbar([1:7],nanmean(pref_all_uncon_per_em),nanstd(pref_all_uncon_per_em)/...
    sqrt(size(pref_all_uncon_per_em,1)),'g','LineWidth',2)

ax.XTick = [1:7];
ax.XTickLabel = em_name;
% legend('Con','UnCon')
ylabel('Percent correct (%) ')
title('Performance')
set(gca,'fontsize',14,'fontweight','bold')

ax = subplot(122);
hold on
   
rt_uncon = rt_all_uncon_per_em;


errorbar([1:7],nanmean(rt_uncon),nanstd(rt_uncon)/...
    sqrt(size(rt_uncon,1)),'g','LineWidth',2 )
ax.XTick = [1:7];
ax.XTickLabel = em_name;
% legend('Con','UnCon')
ylabel('RT (sec.) ')
title('Reaction time')
set(gca,'fontsize',14,'fontweight','bold')

%% Stat on Performance
anova1(pref_all_uncon_per_em,[1:7])

%% Stat on Reaction time
anova1(rt_all_uncon_per_em,[1:7])

%% Eye Data

%% Baseline Correction 
data_ =data;
for ss=1:3
 

eye=data{ss}.eye; ntrial=size(eye,1);
eye_b=eye;
val_b=(nanmean(eye(:,3,1:1000),3));
val_bb=nanmean(val_b);val_bb=repmat(val_bb,ntrial,1);val_bb=repmat(val_bb,1,1,size(eye,3));
std_b=nanstd(val_b);std_b=repmat(std_b,ntrial,1);std_b=repmat(std_b,1,1,size(eye,3));
eye_b(:,3,:)=(eye(:,3,:)-val_bb)./std_b;

val_b=(nanmean(eye(:,4,1:1000),3));
val_bb=nanmean(val_b);val_bb=repmat(val_bb,ntrial,1);val_bb=repmat(val_bb,1,1,size(eye,3));
std_b=nanstd(val_b);std_b=repmat(std_b,ntrial,1);std_b=repmat(std_b,1,1,size(eye,3));
eye_b(:,4,:)=(eye(:,4,:)-val_bb)./std_b;

data{ss}.eye=eye_b;


end


%% Pupil over emotions 
pi=4;
pupil_all_con = []; pupil_all_uncon=[];
pupil_all_con_per_em=[];pupil_all_uncon_per_em=[];
for ss=1:3
  pupil_all_uncon(ss,:) = squeeze(nanmean(data{ss}.eye(data{ss}.bhv==1,pi,:)))';

for ci =1:7
  
    ind_h=[];ind_h=ismember(data{ss}.conditions,[ci ci+7])&data{ss}.bhv==1;
 pupil_all_uncon_per_em(ss,ci,:)=squeeze(nanmean(data{ss}.eye(ind_h,pi,:)))';


end
end


%% preview per Emotion 
t_h=-1000:2800;

figure

plot(t_h,squeeze(nanmean(pupil_all_uncon_per_em,1)))
title('UnConsi')

%% Stat on Pupi size 
var_h = squeeze(nanmean(pupil_all_uncon_per_em(:,:,3500:3800),3));
anova1(var_h,[1:7])

%%
figure
hold on
plot(squeeze(data{ss}.eye(1,5,:)),squeeze(data{ss}.eye(1,1,:)))
plot(squeeze(data{ss}.eye(1,5,:)),squeeze(data{ss}.eye(1,2,:)))
%%
figure
hold on
plot(squeeze(data{ss}.eye(50,1,:)),squeeze(data{ss}.eye(50,2,:)),'g')
 plot(squeeze(data{ss}.eye(10,1,:)),squeeze(data{ss}.eye(10,2,:)))
  plot(squeeze(data{ss}.eye(100,1,:)),squeeze(data{ss}.eye(100,2,:)),'r')