function checkLabels

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0; 

Str = IP.Images(year, month, day, hour);

% -------------------------------------------------------------------------

play = false;

% =========================================================================

% --- Processed & labels

tmp = load(Str.Files.label);
L = tmp.L;

% --- Display -------------------------------------------------------------

figure(1)
set(gcf, 'WindowStyle','docked')
clf

ax = axes();

sl = uicontrol('Style', 'slider', 'Units', 'Normalized', 'Position', [0 0 1 0.03], ...
    'min', 1, 'max', Str.T, 'value', 1, 'SliderStep', [1 10]/(Str.T-1));

addlistener(sl, 'Value', 'PostSet', @updateImage);
set(gcf, 'WindowButtonDownFcn', @mouseClick);
set(gcf, 'KeyPressFcn', @keyInput);

updateImage();

% === Nested functions ====================================================

    function updateImage(varargin)
        
        t = round(get(sl, 'value'));       
        
        I = [L(:).t]==t;
        X = [L(I).x];
        Y = [L(I).y];
        Lb = [L(I).l];
        
        % --- Display
        
        cla
        hold(ax, 'on')
        
        imshow(Str.getFrame(t), 'Parent', ax);
        caxis(ax, [0 3])
                        
        % Miss
        scatter(ax, X(~Lb), Y(~Lb), 100, 'dm');
        
        % Fish
        scatter(ax, X(Lb), Y(Lb), 200, 'sy');
        
        title(ax, "Frame " + t + " / " + Str.T)
        
        drawnow limitrate
        
        if play
            if sl.Value<Str.T
                sl.Value = t+1;
                updateImage;
            else
                play = false;
            end
        end
        
    end

    function mouseClick(varargin)
        
        src = varargin{1};
        
        switch src.SelectionType
            
            case 'normal'   % Right click
                
                tmp = ax.CurrentPoint;
                loc = tmp(1,1:2);
                
                % Get nearest
                I = find([L(:).t]==round(get(sl, 'value')));
                [~, mi] = min(([L(I).x]-loc(1)).^2 + ([L(I).y]-loc(2)).^2);
                
                L(I(mi)).l = ~L(I(mi)).l;
                L(I(mi)).p = 1;
                
                updateImage;
                
%                 x = L(I(mi)).x;
%                 y = L(I(mi)).y;
% 
%                 [x y]
                
        end
        
    end

    function keyInput(varargin)
                
        switch varargin{2}.Key
            
            case 'rightarrow'
                
                if sl.Value<Str.T
                    sl.Value = sl.Value + 1;                
                    updateImage;
                end
                
            case 'leftarrow'
                
                if sl.Value>1
                    sl.Value = sl.Value - 1;                
                    updateImage;
                end
                
            case 'space'
                
                play = ~play;
                if play
                    updateImage;
                end
                
            case 's'
                
                fprintf('Saving ...');
                tic
                
                save(Str.Files.label, 'L');
                
                fprintf(' %02f sec\n', toc)
                
        end
        
        
    end

end

