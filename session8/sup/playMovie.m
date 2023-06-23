%% %%%%%%   In the name of God, the most gracious, the most merciful %%%%%%
%% MATLAB for Brain and Cognitive Psychology Workshope 2023
% Ehsan Rezayat, Ph.D.
% Faculty of Psychology and Education, University of Tehran,
% Institute for Research in Fundamental Sciences (IPM), School of Cognitive Sciences,
% rezayat@ut.ac.ir, rezayat@ipm.ir, erezayat.er@gmail.com
% Contributed by: Amir.M Mousavi.H, Helia Thaghavi & Fatemeh Fallah
% Amir.harris@sru.ac.ir   heliabsb@gmail.com  fh.fallah90@gmail.com
% last edition : 02/11/2023

function playMovie()

Screen('Preference','SkipSyncTests',1);

%Set the movie path and filename
pathToMovie=[pwd,'\sup\emotion.mp4'];

%Set clip info
toTime=inf;   %second to stop in movie
soundvolume=1; % 0 to 1

%Open the screen
% [w,rect]=Screen('OpenWindow',max(Screen('screens')),0);
%[wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 900 800]);
[wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ]);

%Open the movie
[movie,dur,fps,width,height]=Screen('OpenMovie',wPtr,pathToMovie);

%Play the movie
Screen('PlayMovie',movie,1,0,soundvolume);

%Mark starting time
t=GetSecs();

%loop through each frame of the movie and present it
while t<toTime
    
    %get the texture
    tex=Screen('GetMovieImage',wPtr,movie);
    
    %if there is no texture,we are at the end of the movie
    if tex<=0
        break;
    end
    
    %draw the texture
    Screen('DrawTexture',wPtr,tex);
    t=Screen('Flip',wPtr);
    
    %discard this texture
    Screen('Close',tex);
end

%Stop the movie
Screen('PlayMovie',movie,0);

%Close the movie
Screen('CloseMovie',movie);

%Clear the screen
clear Screen;
end

