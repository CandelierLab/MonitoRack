function [pos, Res] = process(this)

if exist(this.Files.processed, 'file')
    return
end

fprintf('Creating container ...');
tic

% --- Memory mapping

% Copy data file
copyfile(this.Files.data, this.Files.processed);

fprintf(' %.02f sec\n', toc);

fprintf('Processing frames ');
tic

% Memory mapping
this.map.processed = memmapfile(this.Files.processed, ...
    'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' }, ...
    'Writable',true);

% --- Processing

L = struct('t', {}, 'x', {}, 'y', {}, 'l', {});

for t = 1:this.T
    
    % Process single frame
    [pos, Res] = IP.Detection.(this.Proc.IP.name).process(this.getFrame(t), this.Bkg);
    
    % Store frame
    this.map.processed.Data(t).frame = uint8(Res*255);
    
    % Labels
    for i = 1:size(pos,1)
        
        k = numel(L)+1;
        L(k).t = t;
        L(k).x = pos(i,1);
        L(k).y = pos(i,2);
        
    end
    
    % Update display
    if ~mod(t, 300), fprintf('.'); end
    
end

% Save labels
save(this.Files.label, 'L');

fprintf(' %.02f sec\n', toc);