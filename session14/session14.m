%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #14 Data Analysis  
close all;
clear all;
clc;

path_code = cd;
addpath(genpath([path_code '\sup']))

%% 

%% definiation to generate data
nDataPts = 20;
rho = .8;
intercept = .0;

%% generate simulated data
data = zeros(nDataPts,2);
data(:,2) = randn(nDataPts,1);
data(:,1) = randn(nDataPts,1).* sqrt(1-rho^2) + (data(:,2).*rho) + intercept;
X = [ones(nDataPts,1) data(:,2)];
y = data(:,1);
plot(data(:,2),data(:,1),'O','MarkerFaceColor','black')
xlabel('X');
ylabel('Y');

%% How to Estimate Y (YHat) related to X (input data)

%% Hypotheis-1: There is no relationship (The worst Model) 
YHat_1 = sum(y,1)/nDataPts;
figure()
plot(data(:,2),data(:,1),'O','MarkerFaceColor','black')

xlabel('X');
ylabel('Y');
hold on
plot (data(:,2),YHat_1 *ones(nDataPts,1), 'g*-' , 'MarkerSize', 10)

%% Hypotheis-2: There is a linear relationship
b0 = 0.2;
b1 = 0.9;
YHat_2 = (ones(nDataPts,1)*b0) +(data(:,2).* b1);
figure()
plot(data(:,2),data(:,1),'O','MarkerFaceColor','black')

xlabel('X');
ylabel('Y');
hold on
plot(data(:,2),YHat_2, 'b-.o' , 'MarkerSize', 12)
%%%
b0 = -0.2;
b1 = 0.8;
YHat_3 = (ones(nDataPts,1)*b0) +(data(:,2).* b1);
hold on 
plot(data(:,2),YHat_3, 'r-.*' , 'MarkerSize', 12)

legend('Data' ,' y=0.2+0.9 x',' y=-0.2+0.8 x')

%% RMSD error 
 Error_file2= sqrt(sum((y-YHat_2).^2))/nDataPts;
 fprintf('b = [0.2 0.9], error =%f \n ',Error_file2)
 Error_file3= sqrt(sum((y-YHat_3).^2))/nDataPts;
 fprintf('b = [-0.2 0.8], error =%f \n ',Error_file3)

%% Grid search for finding both mean and std of CDF
B0 = -2:0.05:2;
B1 = -2:0.05:2;
k = 0;
for i = B0
    l = 0;
    k = k+1;
    for j = B1
        l = l+1;
        Yhat =(i) + (data(:,2).*j);
        Error_file(k,l)= sqrt(sum((y-Yhat).^2))/nDataPts;    
    end
end
figure()
surf(B1,B0,Error_file)
xlabel('b1');
ylabel('b0');
zlabel('RMSD');

[ind1,ind2]=find(min(Error_file(:)) == Error_file);
[B0(ind1), B1(ind2)];
E_GS = Error_file(ind1,ind2);

%% Find the best Model based on Grid search
b0_GS = B0(ind1);
b1_GS = B1(ind2);
YHat_gridS = (ones(nDataPts,1)*b0_GS) +(data(:,2).* b1_GS);
figure()
plot(data(:,2),data(:,1),'O','MarkerFaceColor','black')

xlabel('X');
ylabel('Y');

hold on
plot(data(:,2),YHat_gridS, 'r:o' , 'MarkerFaceColor',[1 0 1],'MarkerSize', 10)

%% do (LSE) analysis and compute parameters
b_MSE = X \ y;
b_MSE_derivation= inv(X'*X)*(y'*X)';
b_MSE_eq= inv(X'*X)*(X'*y);

YHat_LSE = (ones(nDataPts,1)*b_MSE(1)) +(data(:,2).* b_MSE(2));
figure()
plot(data(:,2),data(:,1),'O','MarkerFaceColor','black')

xlabel('X');
ylabel('Y');
hold on
plot(data(:,2),YHat_LSE, 'r:S' , 'MarkerFaceColor',[1 0 0],'MarkerSize', 12)
E_LSE= sqrt(sum((y-YHat_LSE).^2))/nDataPts;

fprintf('b =[ %f %f] \n',b_MSE_derivation')

%% Modeling on Random dot motion task
rdm_analysis()


%% Unconscious Emotion task
uncon_emotion_analysis()

  
%%

%%% The aim of this file is Computing Parameters
%%% Maximum likelihood method
clear vars
clc
close all
path_ = cd;
addpath(genpath([path_ '\sup']))
%% definiation to generate data
nDataPts = 200;
rho = 0.9;
intercept = .0;
data = 4*randn(nDataPts,1)+3;
[gpdf,rn]=hist(data,25);
gpdf = gpdf/sum(gpdf);


%% Load data

load('Exp1_data.mat')

%%
 b=[0 0.1];
error_1 =error(n_items==1);
error_2 =error(n_items==2);
error_4 =error(n_items==4);
error_8 =error(n_items==8);

items=unique(n_items);
figure
pdf_hist=[];rn=[];
for i=1:4
    subplot(1,4,i)
    [pdf_hist(i,:), rn(i,:)] = hist(error(n_items==items(i)),100);
  pdf_hist(i,:)=pdf_hist(i,:) /sum(pdf_hist(i,:));
    bar( rn(i,:),pdf_hist(i,:))
end

%%  Simplex 
figure
for i = 1:4
   

x=rn(i,:);
y = error(n_items==items(i));

ga_fun = @(b) mle_gaussian_sample(b,y);

 startParms = [0 0.1];   % Starting point
 [b_sim,finDiscrepancy] = fminsearch(ga_fun, startParms);

subplot(1,4,i)
bar(rn(i,:),pdf_hist(i,:))
hold on
 b=b_sim;
YHat = (1/(sqrt(2*pi*b(2))))*exp(-1*((x-b(1))/(2*b(2))).^2);
YHat =YHat/sum(YHat);
plot(rn(i,:),YHat,'r')

b_simplex(i,:)=b_sim;
end

%%  GA 
figure
for i = 1:4
   

x=rn(i,:);
y = error(n_items==items(i));

ga_fun = @(b) mle_gaussian_sample(b,y);


nvars = 2;
A = [];
b = [];
Aeq = [];
beq = [];
lb = [-10,-10,-10];
ub = [10,10,10];
nonlcon = [];
% options = optimoptions ('ga', 'MaxGenerations', 1e3);
[b_ga,fval,exitflag,output] = ...
	ga (ga_fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon);



subplot(1,4,i)
bar(rn(i,:),pdf_hist(i,:))
hold on
 b=b_ga;
YHat = (1/(sqrt(2*pi*b(2))))*exp(-1*((x-b(1))/(2*b(2))).^2);
YHat =YHat/sum(YHat);
plot(rn(i,:),YHat,'r')

b_ga(i,:)=b_ga;
end

%% using bays toolbox 

figure
for i = 1:4
   

x=rn(i,:);
y = error(n_items==items(i));

      [B_d] = mixtureFit(y);
b_sim =B_d;
 
subplot(1,4,i)
bar(rn(i,:),pdf_hist(i,:))
hold on
 b=b_sim;
 mu= b(3);
k = b(1);
pt= b(2);
pu=b(4);
YHat = exp(k.*cos(x-mu) - log(2*pi) - besseliln(0,k));
YHat = pt*YHat+pu*(1/(2*pi));
YHat =YHat/sum(YHat);
plot(rn(i,:),YHat,'r')

b_bays_model(i,:)=b_sim;
end

%% per subject
b_bays_model_per_subject = [];
figure
for ss=1:length(unique(subject))


for i = 1:4
  
x=rn(i,:);
y = error(n_items==items(i)&subject==ss);

      [B_d] = mixtureFit(y);
b_sim =B_d;
 
subplot(1,4,i)
bar(rn(i,:),pdf_hist(i,:))
hold on
 b=b_sim;
 mu= b(3);
k = b(1);
pt= b(2);
pu=b(4);
YHat = exp(k.*cos(x-mu) - log(2*pi) - besseliln(0,k));
YHat = pt*YHat+pu*(1/(2*pi));
YHat =YHat/sum(YHat);
plot(rn(i,:),YHat,'r')

b_bays_model_per_subject(ss,i,:)=b_sim;
end

end
%% Standard Errors Across Participants

k_per_sub =[];

  k_per_sub= squeeze(b_bays_model_per_subject(:,:,1));
figure 
errorbar([1:4],nanmean(k_per_sub,1),nanstd(k_per_sub,[],1)/sqrt(size(k_per_sub,1)));
hold on
plot([1:4],b_bays_model(:,1)','r')
xlabel('WM load')
ylabel('WM precision ')
legend('avg per subject','overlay')

anova1(k_per_sub)



