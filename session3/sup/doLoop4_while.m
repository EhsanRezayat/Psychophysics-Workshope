%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com 
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023
%% While loops-Function
function doLoop4_while()
%do a loop


x = 0;
% % % Infinite loops

% while 1
% 	x = x + 1;
% 	fprintf('x is %d\n',x);
% end


% % % Breaking loops

while 1
	x = x + 1;
	fprintf('x is %d\n',x);
%     end the loop, regardless of whether condition is still true
     if sqrt(x) == 5 
		break;
     end
end




    
