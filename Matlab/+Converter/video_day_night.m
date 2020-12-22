

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

data = struct('year', [], 'month', [], 'day', [], 'hour', [], 'mmf', []);

data(1).year = 2020;
data(1).month = 10;
data(1).day = 10;
data(1).hour = 12;

data(2).year = 2020;
data(2).month = 10;
data(2).day = 11;
data(2).hour = 00;

data(3).year = 2020;
data(3).month = 11;
data(3).day = 01;
data(3).hour = 12;

data(4).year = 2020;
data(4).month = 11;
data(4).day = 02;
data(4).hour = 00;

data(5).year = 2020;
data(5).month = 11;
data(5).day = 28;
data(5).hour = 12;

data(6).year = 2020;
data(6).month = 11;
data(6).day = 29;
data(6).hour = 00;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

Video = VideoWriter([DS.Movies 'day_night.avi'], ...
            'Uncompressed AVI');
open(Video);

% --- Filesystem

for i = 1:numel(data)
    
    dDir = [DS.Data num2str(data(i).year, '%04i') filesep ...
        num2str(data(i).month, '%02i') filesep ...
        num2str(data(i).day, '%02i') filesep];
    fname = [dDir 'video_' num2str(data(i).hour, '%02i') '.dat'];
    
    % --- Data file
    
    data(i).mmf = memmapfile(fname, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });
    
end

for t = 1:500
    
    Res = [data(1).mmf.Data(t).frame data(3).mmf.Data(t).frame data(5).mmf.Data(t).frame ; ...
        data(2).mmf.Data(t).frame data(4).mmf.Data(t).frame data(6).mmf.Data(t).frame];
    
% % %     figure(1)
% % %     clf
% % %     
% % %     imshow(Res)
% % %     
% % %     return
    
    writeVideo(Video, Res);
    
end

close(Video);
