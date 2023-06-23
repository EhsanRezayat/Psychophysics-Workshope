% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
% This function compute the Area under ROC Cuvre 
% Green, D. M. & Swets, J. A. Signal Detection Theory And Psychophysics. Vol. 1
% (Wiley New York, 1966).
% 
% inputs:
% pref : response signal prefered condition, spike counts in specific time interval correspond to
% each trials
% npref: response signal prefered condition, spike counts in specific time interval correspond to
% each trials
%
% output:
% auc : the value of area under ROC curve in these conditions  
%
% Edited  By E.Rezayat

function auc = ndass_roc(pref,npref)

if (pref==0); auc=nan;return;end
if (npref==0); auc=nan;return;end

arr=sort([pref; npref]);
clear x;
clear y;
for p = 1 : size(arr)
    sens = size(find(pref>arr(p)),1) ./ ( size(find(pref>arr(p)),1) + size(find(pref<arr(p)),1));
    spec = size(find(npref<arr(p)),1) ./ ( size(find(npref<arr(p)),1) + size(find(npref>arr(p)),1));
    x(p) = 1-spec;
    y(p) = sens;
end;
auc = -trapz(x,y);

end
