function hd=config_psychtoolbox(hd)

%% Configure constant and variables (log)

%% Start Psychtoolbox - FINISHED

PsychDefaultSetup(2)

%% Configure Audio - FINISHED

% Initialize Sounddriver
InitializePsychSound(1);

% Number of channels and Frequency of the sound
hd.audio.nrchannels = 2;
hd.audio.freq = 48000;

% How many times to we wish to play the sound
hd.audio.repetitions = 1;

% Start immediately (0 = immediately)
hd.audio.startCue = 0;

% Should we wait for the device to really start (1 = yes)
% INFO: See help PsychPortAudio

hd.audio.waitForDeviceStart = 1;

audiodevices = PsychPortAudio('GetDevices',3);

if ~isempty(audiodevices)
    %ASIO audio
    if(strcmp('ASIO4ALL v2',{audiodevices.DeviceName})==1)

        hd.audio.outdevice = audiodevices.DeviceIndex;
    
    else
    
        error('No ASIO sound device found, please install ASIO4ALL : http://www.asio4all.com/')
    end

else
    
    error('No sound device found')

end


% Open Psych-Audio port, with the follow arguements
% (1) outdevice = ASIO sound device
% (2) 1 = sound playback only
% (3) 1 = default level of latency
% (4) Requested frequency in samples per second
% (5) 2 = stereo putput

hd.audio.pahandle = PsychPortAudio('Open', hd.audio.outdevice, 1, 1, hd.audio.freq, hd.audio.nrchannels);

% Set the volume to full for this script
PsychPortAudio('Volume', hd.audio.pahandle, 1);

%% Configure Screen - FINISHED

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1

hd.screen.white = WhiteIndex(screenNumber);
hd.screen.black = BlackIndex(screenNumber);

%% Present Test to patient

% Open an on screen window using PsychImaging and color it grey.

[window, windowRect] = PsychImaging('OpenWindow', screenNumber, hd.screen.black);

hd.screen.window=window;
hd.screen.windowRect=windowRect;

