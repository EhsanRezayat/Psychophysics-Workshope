% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
% This function compute the mutual information of R and S according 
% Sugass(Nature 99) paper. at the end the correction Panzeri term also will be
% subtract.
% 
% inputs:
% R: response signal, spike counts in specific time interval correspond to
% each trials
% S: the stimulus signal, the code of stimulus coresspond to stimulus which
% was preseted in each trial in response signal.
% binNo: is the first bin number which is used to find response probability
% function
% minSample: minimum samples which we consider for each bin, if the number
% of samples do not rich to this number, two bins was merged.
%
% output:
% Iraw : the value of mutual information  
% I : the value of mutual information with panzeri correction 
%
% Edited  By M.R.A Dehaqani & E.Rezayat

function [Iraw I] = ndass_mi(R,S,binNo,minSample)
%  R = R(:,2); binNo = 20; minSample = 5;

%% Compute the Response Probabilty P(r)
[n edges]= gen_fx_MyhistCinf(R,binNo,minSample);
P_r = n / sum(n);
%% Find Probabilty Response given Stimulus P(r|s)
Stim = unique(S)';
P_rs = [];
P_s = [];
for s = Stim
    ix = (S == s);
    P_s = [P_s sum(ix)/length(S)];
    n  = histc(R(ix),edges);
    if size(n,2)>1; n=n'; end
    n(end) = [];
    P_rs = [P_rs n/sum(n)];
end

% Compute the Panzeri Correction Term
Bs = sum(P_rs(:) ~= 0);
B = length(edges) - 1;
SS = length(Stim);
N = length(R);
C = (Bs-B-(SS-1))/(2*N*log(2));

HR = sum(log2(P_r) .* P_r);
P_rsT = P_rs;
P_rsT(P_rs(:) == 0) = 1;
Hnoise = sum(P_s .* sum((log2(P_rsT) .* P_rs),1));

Iraw = -HR + Hnoise;
I = Iraw - C;
end

function [n newEdges]= gen_fx_MyhistCinf(R,binNo,minSample)
edges = linspace(min(R),max(R),binNo+1);
edges(end) = edges(end) + 0.1;
newEdges(1) = edges(1);
for i=2:length(edges)
    if sum(R >= newEdges(end) & R < edges(i)) > minSample
        newEdges = [newEdges edges(i)];
    end
end
newEdges(end) = edges(end);
[n bin]= histc(R,newEdges);
n(end) = [];
end