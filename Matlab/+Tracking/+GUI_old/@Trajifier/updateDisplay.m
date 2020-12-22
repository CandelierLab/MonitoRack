function updateDisplay(this, varargin)

warning('off', 'MATLAB:ui:javaframe:PropertyToBeRemoved');

% --- Parameters

ti = round(get(this.ui.time, 'Value'));
If = this.Visu.intensityFactor;

% --- Image ---------------------------------------------------------------

Img = If*double(imread(this.File.images, ti))/255;

set(this.Viewer, 'CurrentAxes', this.ui.image);
cla(this.ui.image);
hold(this.ui.image, 'on');

imshow(Img, 'Parent', this.ui.image);

axis(this.ui.image, 'xy');
this.ui.title.String = ['Frame ' num2str(ti, this.Visu.frameFormat) ' / ' num2str(this.Images.number)];

% --- Points on image -----------------------------------------------------

if this.Visu.viewFrag    
    scatter(this.ui.image, this.Pts.unused(ti).x, this.Pts.unused(ti).y, 30, ...
        'MarkerFaceColor', 'w', ...
        'MarkerEdgeColor', 'k');
end

if this.Visu.viewQuar
    scatter(this.ui.image, this.Pts.quarantine(ti).x, this.Pts.quarantine(ti).y, 30, ...
        'MarkerFaceColor', this.Visu.Color.quarantine, ...
        'MarkerEdgeColor', 'w');    
end

if this.Visu.viewTraj
    scatter(this.ui.image, this.Pts.traj(ti).x, this.Pts.traj(ti).y, 30, ...
        this.Visu.Color.trajs, 'filled', ...
        'MarkerEdgeColor', 'k');    
end

if isstruct(this.zoom)
    axis(this.ui.image, [this.zoom.pos(1)-this.zoom.size ...
        this.zoom.pos(1)+this.zoom.size ...
        this.zoom.pos(2)-this.zoom.size ...
        this.zoom.pos(2)+this.zoom.size]);
else
    axis(this.ui.image, 'tight');
end

% --- Points on 3D view ---------------------------------------------------

set(this.Viewer, 'CurrentAxes', this.ui.view3d);

% --- Fragments

if this.Visu.viewFrag
    delete(this.Visu.hFr3);
    this.Visu.hFr3 = scatter3(this.ui.view3d, ...
        this.Pts.unused(ti).x, this.Pts.unused(ti).y, ...
        ti*ones(numel(this.Pts.unused(ti).x),1), 30, ...
        'MarkerFaceColor', 'w', ...
        'MarkerEdgeColor', 'k');
end

% --- Quarantine

if this.Visu.viewQuar
    delete(this.Visu.hQ3);
    this.Visu.hQ3 = scatter3(this.ui.view3d, ...
        this.Pts.quarantine(ti).x, this.Pts.quarantine(ti).y, ...
        ti*ones(numel(this.Pts.quarantine(ti).x),1), 30, ...
        'MarkerFaceColor', this.Visu.Color.quarantine, ...
        'MarkerEdgeColor', 'w');   
end

% --- Trajectories

if this.Visu.viewTraj
    delete(this.Visu.hTr3);
    this.Visu.hTr3 = scatter3(this.ui.view3d, ...
        this.Pts.traj(ti).x, this.Pts.traj(ti).y, ...
        ti*ones(this.Pts.nTraj,1), 30, this.Visu.Color.trajs, 'filled', ...
        'MarkerEdgeColor', 'k');
end

if isstruct(this.zoom)
    axis(this.ui.view3d, [this.zoom.pos(1)-this.zoom.size ...
        this.zoom.pos(1)+this.zoom.size ...
        this.zoom.pos(2)-this.zoom.size ...
        this.zoom.pos(2)+this.zoom.size ...
        this.Visu.alim3d(5:6)]);
else
    axis(this.ui.view3d, this.Visu.alim3d);
end

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
    
    this.updateDisplay(varargin{:});
end
