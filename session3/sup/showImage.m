%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
%%% Program showImage.m
function gca = showImage(M, lut_type)
gca = figure; % Opens a graphics window
image(M); % Display image M in the graphics window
% axis( ' image ' ); % Sets axis properties of the image in the
% graphics window
axis  off %' ); % Turn off the axes
if strcmp(lut_type, 'grayscale' ) % Check if lut_type is
% grayscale
lut = [[0:255]'  [0:255]' [0:255]'  ]/255;
colormap(lut);
else
colormap default ; % Use Matlab ’ s default colormap
end