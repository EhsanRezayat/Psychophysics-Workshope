%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #13 Data Analysis  
close all;
clear all;
clc;

path_code = cd;
addpath(genpath([path_code '\sup']))

%% Random dot motion task
rdm_analysis()

%% Delay Mstch to Sample task
dms_analysis()

%% Unconscious Emotion task
uncon_emotion_analysis()

%% Emotion task
emotion_analysis()


  
