function CheckIP

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0;

Str = IP.Images(year, month, day, hour);

Str.Proc.IP.name = 'algo_1';

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% Compute background
Str.setBackground;

% --- Process frames ------------------------------------------------------

figure(1)
set(gcf, 'WindowStyle','docked')
clf

axraw = axes('Position', [0.01 0.05 0.485 0.99]);
axres = axes('Position', [0.505 0.05 0.485 0.99]);

sl = uicontrol('Style', 'slider', 'Units', 'Normalized', 'Position', [0 0 1 0.03], ...
    'min', 1, 'max', Str.T, 'value', 100, 'SliderStep', [1 10]/(Str.T-1));

addlistener(sl, 'Value', 'PostSet', @updateImage);

updateImage();

% === Nested functions ====================================================

    function updateImage(varargin)
        
        t = round(get(sl, 'value'));
        [pos, Res] = Str.processFrame(t);
        
        % --- Raw image + positions
        
        hold(axraw, 'off')
        imshow(Str.getFrame(t), 'Parent', axraw);
        caxis(axraw, [0 3])
        
        hold(axraw, 'on')        
        scatter(axraw, pos(:,1), pos(:,2), 200, 'sr');
        
        title(axraw, "Frame " + t + " / " + Str.T)
        
        % --- Resulting image
        
        hold(axres, 'off')
        imshow(Res, 'Parent', axres);
        colorbar
        
        drawnow limitrate
        
    end

end

