% * * * * * * * * * * * * * * * *Neural data analysis Summer school* * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * *Held in: IPM* * * * * * * * * * * * * * * * * * *
% * * * * * * * * * * * * * * * * * * * * *August 2021* * * * * * * * * * * * * * * * * * *
% This function compute the explained variance (EV) proposed by 
% Olejnik, S., & Algina, J. (2003). Generalized eta and omega 
% squared statistics: measures of effect size for some common
% research designs. Psychological methods, 8(4), 434.
% 
% inputs:
% group1 : response signal of  group (1), 
% group2 : response signal of  group (2),
% group3 : response signal of  group (2),
%
% output:
% EV : the value of explained variance between group variance 
% divided by within grouo variance 
%
% Edited  By E.Rezayat


% This code calculates explained variance proposed by 
%Olejnik, S., & Algina, J. (2003). Generalized eta and omega 
%squared statistics: measures of effect size for some common
%research designs. Psychological methods, 8(4), 434.

function EV = ndass_ev(group1,group2,group3)

if (group1==0); EV=nan;return;end

if (group2==0); EV=nan;return;end

arr = [group1;group2;group3];
labels_ = [ones(length(group1),1); 2*ones(length(group2),1); 3*ones(length(group3),1)];
[~,tb1] = anova1(arr,labels_,'off');

 EV = (tb1{2,2}-(tb1{2,3}*tb1{3,4}))/(tb1{4,2}+tb1{3,4});

end