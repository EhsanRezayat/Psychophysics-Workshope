 
function playMovie()

Screen('Preference','SkipSyncTests',1);

%Set the movie path and filename
pathToMovie=[pwd,'\sup\emotion.mp4'];

%Set clip info
toTime=inf;   %second to stop in movie
soundvolume=1; % 0 to 1

%Open the screen
% [w,rect]=Screen('OpenWindow',max(Screen('screens')),0);
 [wPtr,rect]=Screen('Openwindow',max(Screen('Screens')),[128 128 128 ],[1 1 1900 1000]);

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

