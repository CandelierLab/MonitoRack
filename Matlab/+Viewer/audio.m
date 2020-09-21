function audio

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 9;
day = 7;
hour = 10;

% =========================================================================

% --- Filesystem

% Data directory
dataDir = 'D:\MonitoRack\Data\';
if ~exist(dataDir, 'dir')
    dataDir = 'C:\Users\Jean Perrin\Documents\Science\Projects\MonitoRack\Data\';
end

dDir = [dataDir num2str(year, '%04i') filesep ...
            num2str(month, '%02i') filesep ...
            num2str(day, '%02i') filesep]; 
fname = [dDir 'audio_' num2str(hour, '%02i') '.dat'];
        
% --- Data file
        
mmf = memmapfile(fname, 'Format', 'double');
A = mmf.Data;
t = (0:numel(A)-1)/44100;

A(1:10)

figure(1)
set(gcf, 'WindowStyle','docked')
clf
hold on

plot(t, A, '-')

box on

xlabel('t (s)', 'Interpreter', 'Latex');
ylabel('Amplitude', 'Interpreter', 'Latex');