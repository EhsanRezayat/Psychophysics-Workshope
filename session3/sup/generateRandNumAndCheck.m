%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
function generateRandNumAndCheck()
% This Function will generate a random number, and check whether that
% number is greater than 0.5 or not
% This Function has no input or output
% randNum -> created random number
randNum =randn; 
if(randNum > 0.5)
    fprintf('The value is %g and it is bigger than 0.5.\n',randNum);
else
    fprintf('The value is %g and is not bigger than 0.5.\n',randNum);
end
end