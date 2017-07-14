%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function use the subject_number to look in a table located 
% in a xls file for the audio filenames, and return them in a structure
% named audios
%
% Fabricio Baglivo, 2017


function [audios]=audio_files(subject_number)


[~,~, raw]=xlsread('TrialOrder.xls');


Motor1='Motor 1.wav';
Motor2='Motor 2.wav';
NoMotor1='No Motor 1.wav';
NoMotor2='No Motor 2.wav';
Social1='Social 1.wav';
Social2='Social 2.wav';
NoSocial1='No Social 1.wav';
NoSocial2='No Social 2.wav';


audios.first=eval(cell2mat(raw(subject_number,1)));
audios.second=eval(cell2mat(raw(subject_number,2)));
audios.third=eval(cell2mat(raw(subject_number,3)));
audios.fourth=eval(cell2mat(raw(subject_number,4)));



        
