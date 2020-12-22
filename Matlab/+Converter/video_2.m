

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 12;
day = 01;
hour = 12;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

Video = VideoWriter([DS.Movies 'Bad_Conditions.avi'], ...
            'Uncompressed AVI');
open(Video);

% --- Filesystem

dDir = [DS.Data num2str(year, '%04i') filesep ...
            num2str(month, '%02i') filesep ...
            num2str(day, '%02i') filesep]; 
fname = [dDir 'video_' num2str(hour, '%02i') '.dat'];
        
% --- Data file
        
mmf = memmapfile(fname, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });


for i = 1:500
    
    writeVideo(Video, mmf.Data(i).frame);
    
end

year = 2020;
month = 12;
day = 15;
hour = 12;

% --- Filesystem

dDir = [DS.Data num2str(year, '%04i') filesep ...
            num2str(month, '%02i') filesep ...
            num2str(day, '%02i') filesep]; 
fname = [dDir 'video_' num2str(hour, '%02i') '.dat'];
        
% --- Data file
        
mmf = memmapfile(fname, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });


for i = 1:500
    
    writeVideo(Video, mmf.Data(i).frame);
    
end





close(Video);
