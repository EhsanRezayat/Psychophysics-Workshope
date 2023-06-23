%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
function [average,sd] = getSomeStats(x)
    global numOfElements 
    numOfElements = length(x);
    average = sum(x)/numOfElements;
    sd = sqrt(sum((x-average).^2/numOfElements));
    fprintf('Within the function workspace:\n Number of elements are: %g\n The average is: %g \n The standard deviation is: %g \n',numOfElements,average,sd);

end