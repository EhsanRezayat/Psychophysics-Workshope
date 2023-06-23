%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #3 Control statement  
close all;
clear all;
clc;
path_code = cd;
addpath(genpath([path_code '\sup']))

%% Condtioninal statement 
x =4.9;

if x>4
    disp(('x is bigger than 4'))
elseif x<3
    disp(('x is less  than 3'))

else
    disp(('x is between 3 and 4'))

end


%% Finding values within a Matrix

x = rand(1,10);

indicesWhereBig = find(x>.5);
valuesWhereBig1 = x(indicesWhereBig);

valuesWhereBig2 = x(find(x>.5));
% the equivalent of two above lines
%% Logical indexing

% example 1
logicalIndices = x>.5;
whos logicalIndices

logicalValues = x(logicalIndices);
x(x>.5); 
% equivalent to x(find(x>.5))


% example 2   
newvec = [1 0 0 0 0 1 1 0 1 0];
whos newvec

% x(newvec); 
%Error 

newvec = logical(newvec);
x(newvec);

% example 3
Matrix1 = [1:100];
Matrix1(Matrix1<=23);


Matrix2 = [1:10];
Matrix2(Matrix2<5) = 0;
%% Getting the truth
% 1 == 2;
% 1 < 2;
% 1 = 2;  
% Error: The expression to the left of the equals sign is not a valid target for an assignment.
x = 5;
x < 100;
%% Testing the truth

% example 1
x = 3; y = 1;

x>4 && y>4;
%ans=0 False

(x>4) && (y>4);
%ans=0 False

(x>4) || (y>4);
%ans=1 True

(y>4);
%ans=0 False

~(y>4);
%ans=1 True

% example 2
x = 'hello';
y = 'goodbye';
% x == y;  
%Error using  ==  Matrix dimensions must agree.
 
%help strcmp
 
TF1 = strcmp(x,y);
%TF1=0 False

y   = 'Hello';
TF2 = strcmp(x,y);
%TF2=0 False

TF3 = strcmpi(x,y);
%TF3=1 true

%% Conditionals-Function
x = 5; y = 10;
isItBigger(x,y);

isItNine(x);

% pickAFruit(color,fruitsize);

%% 
doLoop1_for();

doLoop2_for();
%% Matlab’s Anti-loop bias

%Loop version:
x        = .01;
for k    = 1:1000
    y(k) = log10(x);
    x    = x + .01;
end
%% Matlab’s Anti-loop bias

% Vector version:
x = .01:.01:10;
y = log10(x);
%% While loops-Function

doLoop3_while();

doLoop4_while();
subjectCode = 10;score =19;subjectName ='Helia';
doesNothing(score,subjectName);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Functions %%%%%%%%%%%%%%%%%%%%%%%  

%%
path_code = cd;%'D:/Workshop-psycho/session1/supplementary/';
addpath(genpath(path_code));

%% example of a function with no input or output value
close all
clc
generateRandNumAndCheck;
%% example of a function with one input and no output value
nameVar = 'helia';
printAName(nameVar);

%% example of a function with two input and no output value
subject_name = 'helia';
subject_age  = 30;

printSubjectNameAndAge(subject_name,subject_age);

%% example of a function with one input and one output value
numVector     = [13 7 89 54 3 19 42];
maximumNumber = findMaxWithSort(numVector);

%% example of a function with one input and two output value
numVector  = [13 7 89 54 3 19 42];
[max, loc] = findMaxNumLocation(numVector);

%% defining a global variable inside a function
xArray = [3 16 76 54 2 90 18 43];
getSomeStats(xArray);
global numOfElements;   % numOfElements is defined as a global varible and 
                        % is also defined as a global inside getSomeStats function
global average;         % average is defined as a global varible is "NOT" 
                        % defined as a global varible inside getSomeStats function
numOfElements;          % numOfElements will have the same value that was 
                        % assigned to it in getSomeStats function
average;                % average will be empty because it was not defined  
                        % as global variable inside getSomeStats
% sd                      % this line will get you error beacause sd was "NOT"  
                        % defined here or as a global varible inside getSomeStats function
fprintf('in the main workspace:\n Number of elements are: %g\n The average is: %g \n ',numOfElements,average);

%% using a global variable inside a function

global var1;        
global var2;
global var3;
var1 = 30;
var2 = 46;
var3 = 6 ;
sum  = sumOfVariables();

