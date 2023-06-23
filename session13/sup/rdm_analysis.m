%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
function rdm_analysis()
clear all
% close all
clc 
%% Load data
path_ = cd;
path_ = [path_ '\sup\rdm'];
filenames = dir(path_);
filenames = filenames(3:end);
data =[];
load([path_ '\RespData_Saj_Self_Sub2_Ses1_Block1.mat'])
data(1).Motion= RespData_Saj_Self_Sub2_Ses1_Block1.Motion;
data(1).Answer= RespData_Saj_Self_Sub2_Ses1_Block1.Answer;
data(1).Coh= RespData_Saj_Self_Sub2_Ses1_Block1.Coh;
data(1).Confidence= RespData_Saj_Self_Sub2_Ses1_Block1.Confidence;
data(1).RT= RespData_Saj_Self_Sub2_Ses1_Block1.TrialRT;


load([path_ '\RespData_Saj_Self_Sub2_Ses1_Block2.mat'])
data(1).Motion=[data(1).Motion RespData_Saj_Self_Sub2_Ses1_Block2.Motion];
data(1).Answer=[data(1).Answer RespData_Saj_Self_Sub2_Ses1_Block2.Answer];
data(1).Coh= [data(1).Coh RespData_Saj_Self_Sub2_Ses1_Block2.Coh];
data(1).Confidence= [data(1).Confidence RespData_Saj_Self_Sub2_Ses1_Block2.Confidence];
data(1).RT= [data(1).RT  RespData_Saj_Self_Sub2_Ses1_Block2.TrialRT];


load([path_ '\RespData_mona_Self_Sub3_Ses1_Block1.mat'])
data(2).Motion= RespData_mona_Self_Sub3_Ses1_Block1.Motion;
data(2).Answer= RespData_mona_Self_Sub3_Ses1_Block1.Answer;
data(2).Coh= RespData_mona_Self_Sub3_Ses1_Block1.Coh;
data(2).Confidence= RespData_mona_Self_Sub3_Ses1_Block1.Confidence;
data(2).RT= RespData_mona_Self_Sub3_Ses1_Block1.TrialRT;


load([path_ '\RespData_mona_Self_Sub3_Ses1_Block2.mat'])
data(2).Motion=[data(2).Motion RespData_mona_Self_Sub3_Ses1_Block2.Motion];
data(2).Answer=[data(2).Answer RespData_mona_Self_Sub3_Ses1_Block2.Answer];
data(2).Coh= [data(2).Coh RespData_mona_Self_Sub3_Ses1_Block2.Coh];
data(2).Confidence= [data(2).Confidence RespData_mona_Self_Sub3_Ses1_Block2.Confidence];
data(2).RT= [data(2).RT  RespData_mona_Self_Sub3_Ses1_Block2.TrialRT];


data_ =[];
for i=1:2
   for tri = 1:size(data(i).Coh,2) 
      data_(i).Answer(tri) =strcmp(data(i).Answer(tri),'l')+1;
      data_(i).Motion(tri) =strcmp(data(i).Motion(tri),'l')+1;
      data(i).rt(tri)=data(i).RT{tri}(1);
   end
   data(i).Answer=data_(i).Answer;
    data(i).Motion=data_(i).Motion;
end


%%  Perfomance
pref_all = [];rt_all = [];rt_all_cr = [];rt_all_wr = [];
for ss=1:size(data,2)
    cc= unique(data(ss).Coh);
    
    for ci =1:size(cc,2)
        ind_h = ismember(data(ss).Coh,cc(ci));
        pref_all(ss,ci)=100*sum(data(ss).Answer(ind_h)==data(ss).Motion(ind_h))/length(data(ss).Motion(ind_h));
        rt_all(ss,ci)=nanmedian(data(ss).rt(ind_h));
              
        rt_all_cr(ss,ci)=nanmedian(data(ss).rt(data(ss).Answer(ind_h)==data(ss).Motion(ind_h)));
        rt_all_wr(ss,ci)=nanmedian(data(ss).rt(~(data(ss).Answer(ind_h)==data(ss).Motion(ind_h))));

        
    end
end


%% Preview perforamnce
figure('name','Performance')
ax = subplot(1,1,1);
hold on
h=plot(cc,pref_all');
% h(1).Marker='s';h(2).Marker='o';
ylabel('Percent correct (%) ')
xlabel('Coherency (%) ')
title('Performance')
set(gca,'fontsize',14,'fontweight','bold')
axis([0 60 ylim])

%% Preview Reaction time
figure('name','Reaction time')
ax = subplot(1,1,1);
hold on
h=plot(cc,rt_all');
% h(1).Marker='s';h(2).Marker='o';
ylabel('RT (ms) ')
xlabel('Coherency (%) ')
title('Reaction time')
set(gca,'fontsize',14,'fontweight','bold')
axis([0 60 ylim])

%% Preview Reaction time
figure('name','Reaction time')
ax = subplot(1,1,1);
hold on
h=plot(cc,rt_all_cr');
% h(1).Marker='s';h(2).Marker='o';
ylabel('RT (ms) ')
xlabel('Coherency (%) ')
title('Reaction time')
set(gca,'fontsize',14,'fontweight','bold')
% axis([0 60 ylim])
h=plot(cc,rt_all_wr','r');
