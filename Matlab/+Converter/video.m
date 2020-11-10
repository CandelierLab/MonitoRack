warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 21;
hour = 11;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% --- Filesystem

dDir = [DS.Data num2str(year, '%04i') filesep ...
            num2str(month, '%02i') filesep ...
            num2str(day, '%02i') filesep]; 
fname = [dDir 'video_' num2str(hour, '%02i') '.dat'];
        
% --- Data file
        
mmf = memmapfile(fname, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });

Video = VideoWriter([DS.Movies num2str(year, '%04i') '-' ...
            num2str(month, '%02i') '-' ...
            num2str(day, '%02i') ' ' num2str(hour, '%02i') 'h.avi'], ...
            'Uncompressed AVI');
open(Video);

figure(1)
set(gcf, 'WindowStyle','docked')

for i = 1:3500
    
    writeVideo(Video, mmf.Data(i).frame);
    
%     imshow(mmf.Data(i).frame);
%     title("Frame " + i + " / " + numel(mmf.Data), 'Interpreter', 'LaTeX')
%         
%     drawnow limitrate
    
end

close(Video);
