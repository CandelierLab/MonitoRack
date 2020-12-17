function Bkg = background(mmf, varargin)

% === Parameters ==========================================================

p = inputParser;
p.addParameter('step', 100, @isnumeric);
p.addParameter('number', 10, @isnumeric);
p.addParameter('verbose', true, @islogical);
p.parse(varargin{:});

step = p.Results.step;
number = p.Results.number;
verbose = p.Results.verbose;

% =========================================================================

if verbose
    fprintf('Computing background ...');
    tic
end

Bkg = iload(mmf, 1);
for j = step+1:step:step*number+1
    Bkg = min(Bkg, iload(mmf, j));
end

if verbose
    fprintf(' %.02f sec\n', toc);
end

end

% =========================================================================

function Img = iload(mmf, id)

Img = double(mmf.Data(id).frame);
Img = Img/mean(Img(:));

end