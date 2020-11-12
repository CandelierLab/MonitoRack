function video

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
<<<<<<< Updated upstream:Matlab/+Viewer/video.m
month = 10;
day = 7;
hour = 11;
=======
month = 11;
day = 03;
hour = 13;
>>>>>>> Stashed changes:Matlab/+Viewer/video_single.m

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

i = 1;

% --- Times

t = NaN(numel(mmf.Data),1);
for i = 1:numel(mmf.Data)
    t(i) = mmf.Data(i).t;
end

figure(1)
set(gcf, 'WindowStyle','docked')
clf
hold on

plot(t, '.-')
plot((1:numel(t))/25, 'k--')

% --- GUI

fig = figure(2);
set(gcf, 'WindowStyle','docked')
clf

ax = axes();

sl = uicontrol('Style', 'slider', 'Units', 'Normalized', 'Position', [0 0 1 0.03], ...
    'min', 1, 'max', numel(mmf.Data), 'value', 1, 'SliderStep', [1 10]/(numel(mmf.Data)-1));

addlistener(sl, 'Value', 'PostSet', @updateImage);

updateImage()

% === Nested functions ====================================================

    function updateImage(varargin)
        
        i = round(get(sl, 'value'));
        
        imshow(mmf.Data(i).frame, 'Parent', ax);
        title("Frame " + i + " / " + numel(mmf.Data), 'Interpreter', 'LaTeX')
        
        drawnow limitrate
        
    end

end


