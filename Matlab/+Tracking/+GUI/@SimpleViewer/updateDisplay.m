function updateDisplay(this, varargin)

% --- Parameters ----------------------------------------------------------

ti = round(get(this.ui.time, 'Value'));
If = this.Visu.intensityFactor;

% --- Image ---------------------------------------------------------------

Img = If*double(this.Images.mmap.Data(ti).frame)/255;


% --- Options -------------------------------------------------------------

set(this.Viewer, 'CurrentAxes', this.ui.image);
cla(this.ui.image);
hold(this.ui.image, 'on');

imshow(Img, 'Parent', this.ui.image);

axis(this.ui.image, 'xy', 'tight');

this.ui.title.String = ['Frame ' num2str(ti, this.Visu.frameFormat) ' / ' num2str(this.Images.N)];

% Request focus
jFig = get(this.Viewer, 'JavaFrame');
jFig.requestFocus;

% --- Draw & play ---------------------------------------------------------

drawnow limitrate

% --- Play / pause
if this.Visu.viewPlay
    if ti==this.ui.time.Max
        this.ui.time.Value = this.ui.time.Min;
    else
        this.ui.time.Value = ti+1;
    end
    pause(1/this.Visu.fps);
    
    this.updateDisplay(varargin{:});
end
