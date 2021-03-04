clear all
close all
clc

% Obtain sound device informations
devinfo = audiodevinfo;

% set the input and output device we will use in the code
inputdev = devinfo.input(1).ID;
outputdev = devinfo.output(1).ID;

% Set the sample rate, bit depth and channels for the recording
Fs = 8000;
Nbits = 16;
NChannels = 1;

% create the recorder obejct. We will use this object to record our sound
% and also store it into this object
recObj = audiorecorder(Fs,Nbits,NChannels,inputdev);

% if the recording does not work, use the following line to load an audio file
% % Filename = 'test.wav';
% % [myRecording, Fs, Nbits] = wavread(Filename);

recordTime = 1;
disp('Recording starts in 3,');
pause(1);
disp('2,');
pause(1);
disp('1,');
pause(1);
disp('Start Recording:');
recordblocking(recObj, recordTime)
disp('Recording has finished.');

% grabs the audio data from our recorded sound and stores it into a
% variable
myRecording = getaudiodata(recObj);

plot([1:length(myRecording)]/Fs,myRecording);
xlabel('time (s)')
ylabel('Amplitude')

% If we want to pay the audio again, we create another object and then call
% the audioplayer function to play our sound
playObj = audioplayer(myRecording,Fs,Nbits,outputdev);
play(playObj);

% This will store our current workspace (e.g. all variables) so we can work
% on it later
save('myTuningForkRecording')