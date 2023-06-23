% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
% This function perform svm classifire 
% 
% inputs:
% I: response signal, spike counts in specific time interval correspond to
% each trials
% grp: the stimulus signal, the code of stimulus coresspond to stimulus which
% was preseted in each trial in response signal.
% rate: the percent of test and train 0.7 70%
% rep: numper of repitionsion for cross validation 
% 
% output:
% out :  out.C confusion matrix  out.pt performace for repetition 
% out.tu 
%
% Edited  By M.R.A Dehaqani & E.Rezayat

function out = ndass_svm(I,grp,rate,rep)
Pt = [];
Tu = [];
for cnt = 1:rep
    [test train] = gen_fx_get_equal_part(grp,rate);
%     if sum(test)>5 && sum(train) > 5
        cls = gen_fx_MC_SVM(I(test,:),I(train,:),grp(train));
        Pt = [Pt; sum(cls == grp(test))/sum(test)];
        Ct(:,:,cnt)= confusionmat(cls,grp(test));
        Tu = [Tu diag(Ct(:,:,cnt)) ./ (sum(Ct(:,:,cnt)))'];
%     else
%         Pt = [Pt; nan];
%         Ct(:,:,cnt)= nan;
%         Tu = [Tu nan];
%     end
end
out.C = Ct; out.pt = Pt; out.tu = Tu;
end

function [test train] = gen_fx_get_equal_part(grp,rate)
catNo = unique(grp);
asiz = []; for cat=catNo'; asiz = [asiz sum(grp == cat)];end
minL = min(asiz);
TrSiz = floor(rate*minL);
TeSiz = minL - TrSiz; 

train = zeros(size(grp)); test = zeros(size(grp));
for cat = catNo'
    ix = grp == cat;
    iix = find(ix);
    Rrp = randperm(length(iix));
    train(iix(Rrp(1:TrSiz))) = 1;
    test(iix(Rrp(end-TeSiz+1:end))) = 1;
end

train = logical(train);
test = logical(test);
end

function class = gen_fx_MC_SVM(sample,train,grp)

classNo = double(unique(grp));
cls_nu = length(classNo);
% r = combntns(1:cls_nu,2);
r = nchoosek(1:cls_nu,2);
vote = [];
for i =1 : length(r(:,1))
    ix = (grp == classNo(r(i,1))) | (grp == classNo(r(i,2)));
    svmStruct = fitcsvm(train(ix,:),grp(ix));
    vote = [vote predict(svmStruct,sample)];
end
class = mode(vote,2);
end
