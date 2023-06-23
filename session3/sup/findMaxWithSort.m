%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
function maxNum= findMaxWithSort (data)
%findMaxWithSort compute the maximum nember in a given vector via sort
%function
%maxNum is the maximum number
%input -> data: any given vector
%output -> maxNum: the maximum number in that vector

%% check inputs
% check that data are numeric
if ~isa(data,'numeric')
    help findMaxWithSort
    error('Input must contain numbers!');
end
% check that the input is a vector
if sum(size(data)>1)>1
    help findMaxWithSort
    error('Data must be a vector!');
end
% check that the input vector has more than one element
if numel(data)<2
    help findMaxWithSort
    error('Data must have more than 1 element!');
end
%% Find maximum number
sorted = sort(data);
maxNum = sorted(end);
fprintf('sorted values are:\n');
fprintf('%g \n',sorted);
fprintf('Maximum value is %g.\n',maxNum);
end
