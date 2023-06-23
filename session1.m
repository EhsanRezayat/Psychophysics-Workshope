%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #1 Introduction 

%% Example: algorithm for calculate the area of circle %%%%%

% step 1 -> start
close all;
clear all;
clc;
% step 2 -> Read value of R
prompt = 'Please enter the Raduis :  ';
x      = input(prompt);

% step 3 -> set value of PI
Pi     = 3.141592653589;

% step 4 ->calculate the area 
area   = x * x * Pi;   %%% A = Pi*r^2
% step 5 -> print R , Area
fprintf('Radius of Circle is : %f \n',x);
fprintf('Area of Circle is : %f \n',area);

% stpe 6 -> end

%% The file browser

cd	%change directory
ls	%list directory contents
dir	%list directory contents
filenames = dir(cd);	%list directory contents
filenames = filenames(3:end);

%% Getting help
help sin
help gaussian
doc log
doc logit
