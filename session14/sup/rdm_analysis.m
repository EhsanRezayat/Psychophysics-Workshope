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
close all
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

load([path_ '\RespData_Saj_Self_Sub2_Ses1_Block2.mat'])
data(1).Motion=[data(1).Motion RespData_Saj_Self_Sub2_Ses1_Block2.Motion];
data(1).Answer=[data(1).Answer RespData_Saj_Self_Sub2_Ses1_Block2.Answer];
data(1).Coh= [data(1).Coh RespData_Saj_Self_Sub2_Ses1_Block2.Coh];
data(1).Confidence= [data(1).Confidence RespData_Saj_Self_Sub2_Ses1_Block2.Confidence];

load([path_ '\RespData_mona_Self_Sub3_Ses1_Block1.mat'])
data(2).Motion= RespData_mona_Self_Sub3_Ses1_Block1.Motion;
data(2).Answer= RespData_mona_Self_Sub3_Ses1_Block1.Answer;
data(2).Coh= RespData_mona_Self_Sub3_Ses1_Block1.Coh;
data(2).Confidence= RespData_mona_Self_Sub3_Ses1_Block1.Confidence;


load([path_ '\RespData_mona_Self_Sub3_Ses1_Block2.mat'])
data(2).Motion=[data(2).Motion RespData_mona_Self_Sub3_Ses1_Block2.Motion];
data(2).Answer=[data(2).Answer RespData_mona_Self_Sub3_Ses1_Block2.Answer];
data(2).Coh= [data(2).Coh RespData_mona_Self_Sub3_Ses1_Block2.Coh];
data(2).Confidence= [data(2).Confidence RespData_mona_Self_Sub3_Ses1_Block2.Confidence];


data_ =[];

for i=1:2
   for tri = 1:size(data(i).Coh,2) 
       data_(i).Answer(tri) =strcmp(data(i).Answer(tri),'l')+1;
      data_(i).Motion(tri) =strcmp(data(i).Motion(tri),'l')+1;

   end
   data(i).Answer=data_(i).Answer;
    data(i).Motion=data_(i).Motion;
end



%%  Perfomance
pref_all = [];rt_all = [];
for ss=1:size(data,2)
 cc= unique(data(ss).Coh);
 for ci =1:size(cc,2)
     ind_h = ismember(data(ss).Coh,cc(ci));
    pref_all(ss,ci)=100*sum(data(ss).Answer(ind_h)==data(ss).Motion(ind_h))/length(data(ss).Motion(ind_h));
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


%% Fitting logistic regression to sample data
ss=1;
ss = 2;
ci = 1;
p_ = pref_all(ss,:);

PF = [];
x = cc';
y = p_'/100;
y(y<0)=0;
n=[];
for ci =1:6

n = [n ;sum(ismember(data(ss).Coh,cc(ci)))];
end

b = glmfit(cc,[y n],'binomial','link','logit');

yfit = glmval(b,x,'logit','size',n);
figure
plot(x, y,'o',x,yfit,'-','LineWidth',2)
xlabel('Coherency (%) ')
ylabel('Correct Response(%)');
ylim([0,1]);
% legend(legends,'Location','southeast')
title('Performance');
set(gca, 'fontsize', 14, 'fontweight', 'bold');
legend('Measured','Fitted')
tresh =-1*squeeze(b(1))./squeeze(b(2));
sensitivity = squeeze(b(2));
%% Fitting logistic regression to data
model_p =[];
for ss = 1 : 2
        p_ = squeeze(pref_all(ss,:))';
        
        PF = [];
        x = cc';
        y = p_/100;
        y(y<0)=0;
        n=[];
for ci =1:6

n = [n ;sum(ismember(data(ss).Coh,cc(ci)))];
end

        b = glmfit(cc,[y n],'binomial','link','logit');
        model_p(ss,:) =b;
        % yfit = glmval(b,x,'probit','size',n);
        % plot(x, y./n,'o',x,yfit./n,'-','LineWidth',2)
        
        
    
    
end


tresh =-1*squeeze(model_p(:,1))./squeeze(model_p(:,2));
sensitivity = squeeze(model_p(:,2));
%% Removoing out of range data
% tresh (tresh >100) =nan; tresh (tresh <-100) =nan;
%% Preview threshold and sestivity of model fitting displayed emotion
figure;
ax = subplot(1,2,1);
hold on
bar([1 2],(squeeze(tresh(:,:))))
ylabel('Threshold (ms)')
title('Threshold')
set(gca, 'fontsize', 14, 'fontweight', 'bold');

ax = subplot(1,2,2);
hold on
bar([1 2],(squeeze(sensitivity(:,:))))

title('Sensitivity')
set(gca, 'fontsize', 14, 'fontweight', 'bold');
