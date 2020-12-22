function prepareDisplay(this, varargin)
%prepareDisplay Prepare the display

% Input: traj='reset'

tic

% --- Parameters ----------------------------------------------------------

nt = this.Images.number;

tI = unique([this.Fr(cellfun(@isnumeric, {this.Fr.status})).status]);
nTraj = max(numel(tI), this.tid);

% --- Trajectories --------------------------------------------------------

this.Visu.Color.trajs = [lines(nTraj-1) ; 1 0.41 0.7];

% --- Local view ----------------------------------------------------------

if ~this.Visu.viewLocal
    this.Visu.crop = struct('x1', 1, 'x2', this.Images.Width, ...
        'y1', 1, 'y2', this.Images.Height);
end
        
% --- 3D view -------------------------------------------------------------

set(this.Viewer, 'CurrentAxes', this.ui.view3d);
cla(this.ui.view3d)
hold(this.ui.view3d, 'on');

% --- Plot trajectories

for i = 1:numel(this.Fr)
    
    % Linewidth
    if i==this.fid 
        lw = 2;
    else
        lw = 0.5;
    end
        
    switch this.Fr(i).status
        
        case 'unused'
            if this.Visu.viewFrag
                pos = [this.Fr(i).soma.pos];
                plot3([pos.x], [pos.y], ...
                    this.Fr(i).t, ...
                    '-', 'Linewidth', lw, ...
                    'color', this.Visu.Color.fragment);
            end
            
        case 'quarantine'
            if this.Visu.viewQuar
                pos = [this.Fr(i).soma.pos];
                plot3([pos.x], [pos.y], ...
                    this.Fr(i).t, ...
                    '-', 'Linewidth', lw, ...
                    'color', this.Visu.Color.quarantine);
            end
            
        otherwise
            if this.Visu.viewTraj
                pos = [this.Fr(i).soma.pos];
                plot3([pos.x], [pos.y], ...
                    this.Fr(i).t, ...
                    '-', 'Linewidth', lw, ...
                    'color', this.Visu.Color.trajs(this.Fr(i).status,:));
            end
            
    end
    
end

grid on
if this.Visu.viewLocal
    axis([this.Visu.crop.x1 this.Visu.crop.x2 this.Visu.crop.y1 this.Visu.crop.y2 this.Visu.alim3d(5:6)]);
else
    axis(this.Visu.alim3d);
end

daspect([1 1 this.Visu.aspRatio])
view(-25,25)
axtoolbar(this.ui.view3d, {'rotate'});
xlabel('x', 'color', 'w')
ylabel('y', 'color', 'w')
zlabel('t', 'color', 'w')

drawnow limitrate

% --- Positions -----------------------------------------------------------

this.Pts = struct('nTimes', nt, 'nTraj', nTraj, ...
    'unused', repmat(struct('x', [], 'y', []), [nt,1]), ...
    'quarantine', repmat(struct('x', [], 'y', []), [nt,1]), ...
    'traj', repmat(struct('x', NaN(nTraj,1), 'y', NaN(nTraj,1)), [nt,1]));

for i = 1:numel(this.Fr)
    
    switch this.Fr(i).status
        
        case 'unused'
            for j = 1:numel(this.Fr(i).t)
                pos = [this.Fr(i).soma.pos];
                this.Pts.unused(this.Fr(i).t(j)).x(end+1) = pos(j).x;
                this.Pts.unused(this.Fr(i).t(j)).y(end+1) = pos(j).y;
            end
               
        case 'quarantine'
            for j = 1:numel(this.Fr(i).t)
                pos = [this.Fr(i).soma.pos];
                this.Pts.quarantine(this.Fr(i).t(j)).x(end+1) = pos(j).x;
                this.Pts.quarantine(this.Fr(i).t(j)).y(end+1) = pos(j).y;
            end
            
        otherwise
            for j = 1:numel(this.Fr(i).t)
                pos = [this.Fr(i).soma.pos];
                if isnan(pos(j).x) || isnan(pos(j).y), continue; end
                this.Pts.traj(this.Fr(i).t(j)).x(this.Fr(i).status) = pos(j).x;
                this.Pts.traj(this.Fr(i).t(j)).y(this.Fr(i).status) = pos(j).y;
            end
    end
    
end

% Display processing time
this.ui.prepareTime.String = round(toc*1000) + " ms";
