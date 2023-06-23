%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

function dms_analysis()
clear all
% close all
clc 
%% Load data
path_ = cd;
path_ = [path_ '\sup\DMS\'];

filenames = dir(path_);
filenames = filenames(3:end);
data =[];
for fi= 1 : size(filenames,1)
load(strcat(path_,'\',filenames(fi).name))
data(fi).name = response(1).subject_name;
 data(fi).condition = [response.cond];
 data(fi).response = [response.respons];
 data(fi).rt = [response.reaction_time_match];

end

%%  Perfomance
pref_all = [];rt_all = [];
for ss=1:size(data,2)
 
    pref_all(ss)=100*sum(data(ss).response==2)/length(data(ss).condition);   
    rt_all(ss)=nanmean(data(ss).rt);
    
     for ci=1:4
    pref_all_cond(ss,ci)=100*sum(data(ss).response==2&ismember(data(ss).condition,ci))/length(data(ss).condition(ismember(data(ss).condition,ci)));
     rt_all_cond(ss,ci)=nanmean(data(ss).rt(ismember(data(ss).condition(data(ss).response==2),ci)));
  
     end
    

end


%% Preview perforamnce
figure('name','Performance')
ax = subplot(121);
hold on
plot(pref_all_cond)

xlabel('sessions')

ylabel('Percent correct (%) ')
title('Performance')
set(gca,'fontsize',14,'fontweight','bold')

ax = subplot(122);
hold on
   
rt_uncon = rt_all_cond;


plot(rt_uncon)
xlabel('sessions')

ylabel('RT (sec.) ')
title('Reaction time')
set(gca,'fontsize',14,'fontweight','bold')
