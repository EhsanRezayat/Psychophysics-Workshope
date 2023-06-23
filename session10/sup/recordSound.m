function audioData=recordSound()
%Initialize sound driver 
InitializePsychSound; 
duration = 5; 
%Open audio channel for recording using mode 2 
freq = 44100; 
pahandle = PsychPortAudio('Open', [], 2, 0, freq, 2); 
%Set up buffer for recording 
PsychPortAudio('GetAudioData', pahandle, duration); 
%Start recording 
PsychPortAudio('Start', pahandle, 0, 0, 1); 
%Go until keypress 
fprintf('Recording...\n'); 
WaitSecs(duration); 
fprintf('Done recording.\n'); 
%Stop Recording 
PsychPortAudio('Stop', pahandle); 
%Get the audio data we recorded 
audioData = PsychPortAudio('GetAudioData',pahandle); 

%Close the audio channel 
PsychPortAudio('Close',pahandle); 
end