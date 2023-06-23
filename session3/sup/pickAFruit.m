%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
%% Conditionals-Function

function fruit = pickAFruit(color,fruitsize)
% choose a fruit based on color and size
% color is a string, and size is a double representing weight in grams

if strcmp(color,'red')

	if fruitsize < 10
		fruit = 'apple';
	else
		fruit = 'watermelon';
	end
		

elseif strcmp(color,'yellow')

	fruit = 'banana';

else

	fruit = 'unknown';

end

end
