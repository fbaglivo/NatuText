%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NatuText Pardigm V0 (Debug)
%
% This script plays audio files (2 Non-Motors, 2 Non-Social, 2 Motor, 2 
% Neutral) logging starting and ending times. It synchronizes with fMRI  
% TTL pulse. This scritp logs patient name, block id, starting and ending 
% times.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all


%% Patient info

subject_number=input('Ingrese el número de sujeto: ', 's');
name = input('Ingrese el nombre del paciente: ', 's');
date = datestr(now);


%% 

HideCursor();

hd.InterTextTime=60*0.1; % 0.1 Minutes in seconds
hd.BaselineTime=60*0.14;

index=2;

%% Load current task audio paths

audios=audio_files(str2num(subject_number));


%% Load Audio Files

hd.audiofile(1).audio = wavread(['Audios/' audios.first])';
hd.audiofile(2).audio = wavread(['Audios/' audios.second])';
hd.audiofile(3).audio = wavread(['Audios/' audios.third])';
hd.audiofile(4).audio = wavread(['Audios/' audios.fourth])';


%% Init Pysch enciroment

hd=config_psychtoolbox(hd);


%% wait for MRI TTL Pulse

w='Waiting MRI connection...';
DrawFormattedText(hd.screen.window, w , 'center',...
                'center', hd.screen.white);          
Screen('Flip',hd.screen.window,0,1);             
KbStrokeWait;

%%

log.times.absolute(1)=GetSecs; % START WITH TTL
log.times.relative(1)=GetSecs-log.times.absolute(1);


%% begin task main loop (4 tasks)
   
for times=1:4

    Screen('FillRect',hd.screen.window,hd.screen.black)  ; 
    w=['Preparando audio...' num2str(times)];
    DrawFormattedText(hd.screen.window, w , 'center',...
        'center', hd.screen.white);
    Screen('Flip',hd.screen.window,0,1);


    [~,keyCode,~]=KbStrokeWait;
   
    % skip audio
       
    if (find(keyCode) == KbName('q')) %Quit
        
        save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
        error('Finalizando script...')
        
    elseif (find(keyCode) == KbName('s')) %Skip
        
        continue;
        
    end

    for i=1:2
        
        Screen('FillRect',hd.screen.window,hd.screen.black)  ;
        w=['Reproduciendo audio ' num2str(times) ' corrida ' num2str(i)];
        DrawFormattedText(hd.screen.window, w , 'center',...
            'center', hd.screen.white);
        Screen('Flip',hd.screen.window,0,1);
        
        
        
        % Fill the audio playback buffer with the audio data, doubled for stereo
        % presentation
        PsychPortAudio('FillBuffer', hd.audio.pahandle, [hd.audiofile(times).audio]);
        
        log.times.absoulte(index)=GetSecs; % Log audio start time
        log.times.relative(index)=GetSecs-log.times.absolute(1);
        index=index+1;
        
        
        % Start audio
        PsychPortAudio('Start', hd.audio.pahandle, hd.audio.repetitions, hd.audio.startCue, hd.audio.waitForDeviceStart);
        
        % Wait for end of audio loop
        status=PsychPortAudio('GetStatus', hd.audio.pahandle);
        
        state=1;
        
        while(status.Active==1)
            
            status=PsychPortAudio('GetStatus', hd.audio.pahandle);
        
            if status.Active == 0
                % Log end time
                log.times.absoulte(index)=GetSecs; % Log audio end time
                log.times.relative(index)=GetSecs-log.times.absolute(1);
                index=index+1;
                
            end
            
            
            % Update screen, keep alive
            
            switch state
                
                case 1
                    
                    Screen('FillRect',hd.screen.window,hd.screen.black)  ;
                    w=['Reproduciendo audio ' num2str(times) ' corrida ' num2str(i) '.'];
                    DrawFormattedText(hd.screen.window, w , 'center',...
                        'center', hd.screen.white);
                    Screen('Flip',hd.screen.window,0,1);
                    state=2;
                    WaitSecs(1);
                    
                    
                case 2
                    
                    Screen('FillRect',hd.screen.window,hd.screen.black)  ;
                    w=['Reproduciendo audio ' num2str(times) ' corrida ' num2str(i) '..'];
                    DrawFormattedText(hd.screen.window, w , 'center',...
                        'center', hd.screen.white);
                    Screen('Flip',hd.screen.window,0,1);
                    state=3;
                    WaitSecs(1);
                    
                    
                case 3
                    
                    Screen('FillRect',hd.screen.window,hd.screen.black)  ;
                    w=['Reproduciendo audio ' num2str(times) ' corrida ' num2str(i) '...'];
                    DrawFormattedText(hd.screen.window, w , 'center',...
                        'center', hd.screen.white);
                    Screen('Flip',hd.screen.window,0,1);
                    state=1;
                    WaitSecs(1);
                    
            end
            
        end
        
        
        if (i==1)        
            
            WaitSecs(hd.InterTextTime);
        
        else
        
            WaitSecs(hd.BaselineTime);
            
        end
        
    end
    
    Screen('FillRect',hd.screen.window,hd.screen.black)  ;
    w='Ahora le harán unas preguntas...';
    DrawFormattedText(hd.screen.window, w , 'center',...
        'center', hd.screen.white);
    Screen('Flip',hd.screen.window,0,1);
    [~,keyCode,~]=KbStrokeWait;
     

      
end

%% Save & Close

save(['Log/' name '_' date(1:11) '.mat'],'log');
Screen('CloseAll'); % Cierro ventana del Psychtoolbox
