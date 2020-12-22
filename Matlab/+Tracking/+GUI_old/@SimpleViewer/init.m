function init(this, varargin)
%INIT Viewer initialization
%   - Figure creation and widget placement
%   - Define callbacks and events

% === Informations ========================================================

% --- Data source

DS = DataSource;
fRaw = [DS.Data this.year filesep this.month filesep this.day filesep 'video_' this.hour '.dat'];
this.Images.mmap = memmapfile(fRaw, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });

% --- Number of images

this.Images.N = 5000;
while true
    
    if any(this.Images.mmap.Data(this.Images.N).frame)
        break;
    else
        this.Images.N = this.Images.N-1;
    end
    
end

% === Figure ==============================================================

% --- Parameters

this.Window.menuWidth = 400;
this.Visu.frameFormat = ['%0' num2str(ceil(log10(this.Images.N))) 'i'];

this.Visu.fps = 50;

% Views
this.Visu.viewPlay = false;

% --- Figure

this.Viewer = findobj('type', 'figure', 'name', 'Viewer');

if isempty(this.Viewer)
    this.Viewer = figure('name', 'Viewer');
else
    figure(this.Viewer.Number);
end

clf(this.Viewer)

%  --- User Interface -----------------------------------------------------

% --- Axis

this.ui.image = axes('units', 'pixels', 'Position', [0 0 1 1]);

% --- Title

this.ui.title = uicontrol('style', 'text', 'position', [0 0 1 1], ...
    'FontName', 'Courier New', 'FontSize', 12);

% --- Menu

this.ui.menu.shortcuts = uicontrol('style', 'text', ...
    'FontName', 'Courier New', 'FontSize', 11, 'HorizontalAlignment', 'left', ...
    'backgroundColor', this.Window.color, 'ForegroundColor', 'w', ...
    'position', [0 0 1 1]);

this.ui.menu.shortcuts.String = this.getControls();

% --- Actions

this.ui.action = uicontrol('style', 'text', ...
    'FontName', 'Courier New', 'FontSize', 11, 'HorizontalAlignment', 'left', ...
    'backgroundColor', this.Window.color, 'ForegroundColor', 'y', ...
    'position', [0 0 1 1]);

% --- Controls ------------------------------------------------------------

% --- Time

this.ui.time = uicontrol('style','slider', 'position', [0 0 1 1], ...
    'min', 1, 'max', this.Images.N, 'value', 1, 'SliderStep', [1 1]./(this.Images.N-1));

% --- Listeners

this.Viewer.ResizeFcn = @this.updateWindowSize;
this.Viewer.Position = this.Window.position;
this.Viewer.KeyPressFcn = @keyInput;
addlistener(this.ui.time, 'Value', 'PostSet', @this.updateDisplay);

this.updateDisplay();

    % === GUI nested functions ============================================

    function keyInput(varargin)
       
        event = varargin{2};
        
        if ismember(event.Key, {'leftarrow', 'rightarrow', 'uparrow', ...
                'downarrow', 'pageup', 'pagedown', 'delete'})
            this.input(event.Key);
        else
            this.input(event.Character);
        end
        
    end
end
