%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
%
%% Debugging
function debugDemo(subjectCode)
%Print out the condition associated with the subject
mySubjects={'SB01','SB02','SB03'};
myConditions={'D','T','D'};
myData={mySubjects,myConditions};

subjectindex=find(strcmp(mySubjects,subjectCode));
myConditions=myData{2}(subjectindex);

printSomething(myConditions);
%we are calling another function that we defined in the same file.
end

function printSomething(stringToPrint)
%All this does is print out the string that is passed to it.

fprintf('This is your string:%s\n',stringToPrint);
end
