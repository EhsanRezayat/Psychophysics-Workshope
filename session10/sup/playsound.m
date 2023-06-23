%% play sound 
function playsound() 
%Mark script start time
scriptStart = GetSecs();
%Initialize the sound driver
InitializePsychSound;
%Read in the sound data from file
wavfilename=[cd '/sup/Applause.wav']
[soundData, freq] = audioread(wavfilename);
%Prepare sound data (make it two rows for stereo playback)
soundData = [soundData, soundData];
numChannels=2;
%Open the audio driver
pahandle = PsychPortAudio('Open',[], [], 0, freq,numChannels);
%Fill the buffer
PsychPortAudio('FillBuffer',pahandle,soundData');
%Play the sound
playTime = PsychPortAudio('Start',pahandle);
fprintf('\nSound started playing %.2f seconds after start of script\n',playTime,scriptStart);
%Close the audio driver
PsychPortAudio('Stop', pahandle, 1,0);
PsychPortAudio('Close',pahandle);
end