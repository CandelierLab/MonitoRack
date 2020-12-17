function prepareDisplay(this, varargin)
%prepareDisplay Prepare the display

% --- Input ---------------------------------------------------------------

p = inputParser;
addRequired(p, 'ti', @isnumeric);
addOptional(p, 'init', false, @islogical);
parse(p, varargin{:});

ti = p.Results.ti;
% init = p.Results.init;

% --- Preparation ---------------------------------------------------------

If = this.Visu.intensityFactor;

% Read raw image
this.Raw.setDirectory(ti);
if isempty(this.Red)
    R = read(this.Raw);
else
    this.Red.setDirectory(ti);
    tmp = double(read(this.Red));
    tmp(tmp<mean(tmp(:))+5*std(tmp(:))) = 0;
    R = read(this.Raw) + uint8(2*tmp);
end
G = read(this.Raw);
B = read(this.Raw);

% --- Shapes

Scm = hsv(numel(this.Blob))*255/If;
Scm = Scm(randperm(size(Scm,1)), :);

for i = 1:numel(this.Blob)

    [~, mi] = max(cellfun(@numel, this.Blob(i).contour.x));
    
    I = sub2ind([this.Images.Height this.Images.Width], ...
        this.Blob(i).contour.y{mi}, this.Blob(i).contour.x{mi});
    
    R(I) = R(I)*0.5 + Scm(i,1)*0.5;
    G(I) = G(I)*0.5 + Scm(i,2)*0.5;
    B(I) = B(I)*0.5 + Scm(i,3)*0.5;
    
end

% --- Cells

Ucm = hsv(numel(this.Unit))*255/If;

for i = 1:numel(this.Unit)
    for k = 1:numel(this.Unit(i).all.contour.x) 
        R(this.Unit(i).all.idx) = R(this.Unit(i).all.idx)*0.7 + Ucm(i,1)*0.3;
        G(this.Unit(i).all.idx) = R(this.Unit(i).all.idx)*0.7 + Ucm(i,2)*0.3;
        B(this.Unit(i).all.idx) = R(this.Unit(i).all.idx)*0.7 + Ucm(i,3)*0.3;
    end
end

% --- Output --------------------------------------------------------------

RGB = cat(3, R, G, B);

if p.Results.init
    setTag(this.Data, this.Visu.tagstruct);
    write(this.Data, RGB);
    writeDirectory(this.Data);
else
    this.Data.setDirectory(ti);
    % setTag(this.Data, this.Visu.tagstruct);
    write(this.Data, RGB);
end