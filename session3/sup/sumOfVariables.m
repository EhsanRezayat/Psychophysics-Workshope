%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

function sumation = sumOfVariables()
% This function will calculate sumation of 3 global variables that are
% defined in the main workspace
global var1;        % This variable is defined as global in the main workspace          
global var2;        % This variable is defined as global in the main workspace
global var3;        % This variable is defined as global in the main workspace
sumation = var1 + var2 + var3;
end