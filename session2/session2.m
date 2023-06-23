%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

%% session #2 Variable Types

%% Integer 
N  = 64;
N1 = 385;
N2 = 1276;

%% double
Flt    = 54.97;%  double 
Fn123J = .7;
A_d2   = 3.2;

%% Boolean
T = true; 
F = false;

%% Some example of wrong Variable Name
%  13f   = 34
% _temp = 3.7
% $fs   = 3
% ?var  = 100

%% Vectors &  matrices
%% Creating vectors 
Confidence_level = [1,2,3,4,5];
Confidence_level = [1 2 3 4 5];
Confidence_level = [1:5];
Confidence_level = [1:1:5];

%% Creating vectors -> odd index, even index , ....
odd_num  = [1:2:31]; % odd numbers form 1 to 31
even_num = [0:2:30]; % even numbers form 0 to 30

%% Creating matrices -> different matrices 

LeftVSRight           = [ 1,3,5,7;
                          2,4,6,8 ] ;      
        
AnswerAndReactionTime = [ false,.15; true,.64 ;true,.37; false,.518 ]; 

choice                = [1 2 3; 
                         4 5 6;
                         7 8 9];

%% Creating matrices --> ones & zeros - 2D

TrueAnswers = ones(3);
            
TrueAnswers = ones(2,3);

WrongAnswer = zeros(3,4);

%% Creating matrices --> random & NAN -  3D
 
ReactionTime     = rand(1,15);
 
StimulusDuration = rand(6,4);      
Confidence       = rand(5,4,3); % between 0 to 1
IrrelevantAnswer =  nan(2,2,4);

%% Creating matrices --> Describing matrices - size & length

a1 = size(WrongAnswer); % 3 * 4
a2 = size(Confidence); % 5 * 4 * 3

a3 = length(ReactionTime); % 1 * 15 
a4 = length(IrrelevantAnswer) ; % 2 * 2 * 4

%% Mymatrice  -> Accessing elements

%% Creating matrices --> Accessing elements 1D
a = ReactionTime(3);
b = Confidence([1,2,4]);

%% Creating matrices --> Accessing elements 2D
c = StimulusDuration(2,3);

d = StimulusDuration(1,:);

e = StimulusDuration(1:3,1);

%% Creating matrices --> Accessing elements
f = Confidence(end);
g = Confidence(end-1);


%% Vector adding  --> Adding a constant to each element in a vector
old_Conditions = [1 2 3];
a = old_Conditions + 1;

b = old_Conditions + 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vector adding  --> Adding two vectors
 
New_Conditions = [5 1 5];

added          = old_Conditions + New_Conditions;

added_With_Int = old_Conditions + New_Conditions + 5 ;


%% transposing a matrix
old_Conditions = [1 2 3];

old_Conditions = old_Conditions';
old_Conditions = old_Conditions';


%% Vector multiplication --> a constant to each element in a vector
multiplication           = old_Conditions .* New_Conditions % The .* sign refers to element-wise multiplication

multiplication_With_Int  = old_Conditions * 4

multiplication_With_Int1 = old_Conditions .* 4

%% operators 

% Element-wise operators:
            % .*	multiplication
            % ./ 	division
            % .^	exponentiation
       
division_With_Int = New_Conditions ./ 5 

division          = New_Conditions ./ old_Conditions 

exponentiation    = old_Conditions .^ 4 

%% Many other functions work element-wise, e.g.:

Mysqrt = sqrt(exponentiation)

Mylog = log(exponentiation)

%% Working with strings
%Strings in Matlab are vectors of characters

%% Always use single quotes to define strings

SubjectName = 'Dr. Ehsan Rezayat'

SubjectName(5) % E

SubjectName(5:10) % Ehsan

%% double str

double('a')

char(98)

%% strcat

Codition = ' Social task' 

strcat(SubjectName,' - ',Codition )

%% What do we typically do with strings?


str1    = sprintf('Please maintain gaze on the fixation point throughout the trial \n');
title   = sprintf('Train phase  \n')
message = [ title , str1 ,'... After fixation point and when you are ready press Space button to begin each trial...'];
message

%% What do we typically do with strings?
no_session   = 2;
no_subject   = 1;
no_block     = 4;
ReactionTime = rand(1,15)
info.RT      = ReactionTime;
a            = sprintf('subject (%i)/session_E %i-%i',no_subject,no_session,no_block);

disp(a)

%% What do we typically do with strings?

A1 = [9.9, 9900];
A2 = [8.8,  7.7 ; ...
      8800, 7700];
formatSpec = 'X is %4.2f meters or %8.3f mm\n';
fprintf(formatSpec,A1,A2)

%% Working with strings

CourseName = 'PsychPhysics'; 
 
disp(CourseName)

fprintf(CourseName)

% PsychPhysics>> sprintf(CourseName)
%% Formatting strings
help fprintf

%% Formatting strings

%s	string
%d 	integer/digit
%i	integer/digit
%f	floating point number  
%c	single character

employee = 'Fred';
age      = 32;
score    = 88.432;
fprintf('Employee: %s is %d years old and scored %f',employee,age,score);

%% Formatting strings
% \t	tab
% \n	newline
% \v 	vertical tab
employee = 'Fred';
age      = 32;
fprintf('%s\t%d\n',employee,age)

%% Working with numbers in strings
employee = 'Fred';
age      = 32;
score    = 88.432;

fprintf('Score: %f\n',score);

fprintf('Score: %.2f\n',score);

fprintf('Score: %.0f\n',score);

fprintf('Score: %.5f\n',score);
9
fprintf('Age: %d\n',age)

fprintf('Age: %.4d\n',age)
 %% Special characters
 
%  ‘’	to print a single-quote
%  %%to print a percent sign
name = 'amir';
age      = 32;
score    = 88.432;

fprintf ('Score was %.2f%%\n',score)

fprintf('Name is ''%s''\n',name)

%% Creating string variables

help sprintf

%% Creating string variables 

subject = 'jimmy';
logfileName = sprintf('data_%s.txt',subject)

%% Collections of strings

SubjectsNames = ['Jonas','Fred','John']

SubjectsNames = {'Jonas','Fred','John'}

%% Using cell arrays

myinfo = {'hello',4,'goodbye',543.43}

myinfo = {[1:5],[6:10]}

myinfo(1)

myinfo{1}

%% Structures

patient.name    = 'John Doe';
patient.billing = 127.00;
patient.test    = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];

patient

patient(2).name    = 'Jane Doe';
patient(2).billing = 156.00;
patient(2).test    = [71 73, 55; 101, 22, 22; 242, 211, 205];

patient(1)

patient(2)



