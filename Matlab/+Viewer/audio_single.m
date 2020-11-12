function audio

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 13;
hour = 03;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% --- Filesystem

% Data directory
dDir = [DS.Data num2str(year, '%04i') filesep ...
            num2str(month, '%02i') filesep ...
            num2str(day, '%02i') filesep];  
fname = [dDir 'audio_' num2str(hour, '%02i') '.dat'];
        
% --- Data file
        
mmf = memmapfile(fname, 'Format', 'double');
A = mmf.Data;
t = (0:numel(A)-1)/44100;

figure(1)
set(gcf, 'WindowStyle','docked')
clf
hold on

plot(t, A, '-')

box on

xlabel('t (s)', 'Interpreter', 'Latex');
ylabel('Amplitude', 'Interpreter', 'Latex');

ylim([-1 1]/2)