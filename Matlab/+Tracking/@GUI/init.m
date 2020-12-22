function init(this)

DS = DataSource;

% Get years
tmp = dir([DS.Data '20*']);
Years = {tmp(:).name}; 

% === Figure ==============================================================

% --- Create or reuse Viewer

this.Viewer = findobj('type', 'figure', 'name', 'Tracker');

if isempty(this.Viewer)
    this.Viewer = figure('name', 'Tracker');
else
    figure(this.Viewer.Number);
end

% --- Clear Viewer

clf(this.Viewer)
this.Viewer.MenuBar = 'none';
this.Viewer.ToolBar = 'none';

% --- Viewer size

this.Viewer.Units = 'normalized';
this.Viewer.Position = [0 0 1 1];
this.Viewer.Color = [0 0 0];

% === Controls ============================================================

% Years
this.ui.year = uicontrol('style', 'popupmenu', ...
    'Units', 'normalized', 'position', [1 97 3 2]/100, ...
    'string', Years, 'FontName', 'Courier New', 'FontSize', 12, ...
    'Callback', @this.setYear);

this.ui.month = uicontrol('style', 'popupmenu', ...
    'Units', 'normalized', 'position', [5 97 3 2]/100, ...
    'string', '-', 'FontName', 'Courier New', 'FontSize', 12, ...
    'Callback', @this.setMonth);

this.ui.day = uicontrol('style', 'popupmenu', ...
    'Units', 'normalized', 'position', [9 97 3 2]/100, ...
    'string', '-', 'FontName', 'Courier New', 'FontSize', 12, ...
    'Callback', @this.setDay);

this.ui.hour = uicontrol('style', 'popupmenu', ...
    'Units', 'normalized', 'position', [13 97 3 2]/100, ...
    'string', '-', 'FontName', 'Courier New', 'FontSize', 12, ...
    'Callback', @this.setHour);

this.setYear;
this.setMonth;
this.setDay;
this.setHour;