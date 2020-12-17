function manualSeed

warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0;

Str = IP.Images(year, month, day, hour);

Str.Proc.IP.name = 'proc_1';

% Str.Proc.Sub.name = 'sub_1';
% Str.Proc.Sub.dt = 3;
% Str.Proc.Sub.xval = [0.35 1];

ws = 21;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% Create directory
if ~exist([DS.Files Str.path], 'dir')
    mkdir([DS.Files Str.path]); 
end

if exist(Str.Files.mlabel, 'file')
    
    tmp = load(Str.Files.mlabel, 'L');
    L = tmp.L;
    
else
    
    param = struct('algo', Str.Proc.IP.name, 'ws', ws, 'dt', Str.Proc.Sub.dt, 'xval', Str.Proc.Sub.xval);
    L = struct('t', {}, 'x', {}, 'y', {}, 'l', {});
    save(Str.Files.mlabel, 'param', 'L');
    
end

% Compute background
Str.setBackground;

% Process frames
Str.process;

% --- Processed & labels

tmp = load(Str.Files.label);
uL = tmp.L;

L = struct('t', {}, 'x', {}, 'y', {}, 'l', {});

% --- Display -------------------------------------------------------------

x = [];
y = [];

figure(1)
set(gcf, 'WindowStyle','docked')
clf

ax = axes('Position', [0.01 0.05 0.485 0.99]);
zoom = axes('Position', [0.505 0.05 0.485 0.99]);

sl = uicontrol('Style', 'slider', 'Units', 'Normalized', 'Position', [0 0 1 0.03], ...
    'min', 1, 'max', Str.T, 'value', 100, 'SliderStep', [1 10]/(Str.T-1));

addlistener(sl, 'Value', 'PostSet', @updateImage);
set(gcf, 'WindowButtonDownFcn', @mouseClick);
set(gcf, 'KeyPressFcn', @keyInput);

updateImage();
updateZoom();
updateCW();

% === Nested functions ====================================================

    function updateImage(varargin)
        
        t = round(get(sl, 'value'));       
                
        hold(ax, 'off')
        imshow(Str.getFrame(t), 'Parent', ax);
        caxis(ax, [0 3])
        
        hold(ax, 'on')
        
        I = [uL(:).t]==t;
        scatter(ax, [uL(I).x], [uL(I).y], 200, 'sr');
        
        title(ax, "Frame " + t + " / " + Str.T)
        
        drawnow limitrate
        
    end

    function mouseClick(varargin)
        
        src = varargin{1};
        
        switch src.SelectionType
            case 'normal'   % Right click
                
                tmp = ax.CurrentPoint;
                loc = tmp(1,1:2);
                
                % Get nearest
                I = find([uL(:).t]==round(get(sl, 'value')));
                [~, mi] = min(([uL(I).x]-loc(1)).^2 + ([uL(I).y]-loc(2)).^2);
                
                x = uL(I(mi)).x;
                y = uL(I(mi)).y;
                
                % Hightlight focus
                updateImage;
                scatter(ax, x, y, 200, 'sy')
                
                % Display
                updateZoom;
                
            case 'alt'   % Left click
                
                tmp = ax.CurrentPoint;
                x = tmp(1,1);
                y = tmp(1,2);
                
                % Hightlight focus
                updateImage;
                scatter(ax, x, y, 200, 'sy')
                
                % Display
                updateZoom;
        end
        
    end

    function keyInput(varargin)
        
        switch varargin{2}.Character
            
            case {'0', '1', '2'}
                
                i = numel(L)+1;
                L(i).t = round(get(sl, 'value'));
                L(i).x = x;
                L(i).y = y;
                L(i).l = str2double(varargin{2}.Character);
                
                save(Str.Files.mlabel, 'L', '-append');
                
        end
        
        updateCW();
        
    end

    function updateCW()
        
        % --- Update CW
        
        clc
        
        fprintf('\n0 (Miss): <strong>%03i</strong> labels\n', nnz([L(:).l]==0));
        fprintf('1 (Fish): <strong>%03i</strong> labels\n', nnz([L(:).l]==1));
        fprintf('2 (Mult): <strong>%03i</strong> labels\n\n', nnz([L(:).l]==2));
        
    end

    function updateZoom
        
        if isempty(x)
            axis(zoom, 'off')
            return
        end
        
        Sub = Str.getSub(round(get(sl, 'value')), x, y, ws);
        
        hold(zoom, 'off');
        
        imshow(Sub, 'Parent', zoom);
        caxis(zoom, [0 1])
        colorbar(zoom)
                
        drawnow limitrate
        
    end

end

