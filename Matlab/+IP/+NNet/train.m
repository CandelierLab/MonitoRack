clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0;

trainOn = 'manual';
% trainOn = 'label';

ws = 21;

netname = '/home/raphael/Bureau/test/mnet.mat';

force = true;

% -------------------------------------------------------------------------

DS = DataSource;

Str = IP.Images(year, month, day, hour);

% =========================================================================

% --- Load labels ---------------------------------------------------------

if ~exist('L', 'var') || force
    
    fprintf('Loading labels ...');
    tic
    
    switch trainOn
        case 'manual'
            tmp = load(Str.Files.mlabel, 'L');
        case 'label'
            tmp = load(Str.Files.label, 'L');
    end
    L = tmp.L;
    
    fprintf(' %.02f sec\n', toc);
    
end

% --- Prepare feature data (sub images) -----------------------------------

if ~exist('Sfd', 'var') || force

    fprintf('Prepare features ...');
    tic
    
    % Preallocate
    Sfd = zeros(ws, ws, 1, numel(L), 'uint8');
    
    for i = 1:numel(L)
        
        Sfd(:,:,1,i) = Str.getSub(L(i).t, L(i).x, L(i).y, ws);
        
    end

    fprintf(' %.02f sec\n', toc);
    
end

% === Train network =======================================================

fprintf('Prepare training ...');
tic

cat = categorical( [L(:).l]);

nCat = numel(unique([L(:).l]));

layers = [
    imageInputLayer([ws ws 1])
    
    convolution2dLayer(3, 8, 'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(nCat)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','none');

fprintf(' %.02f sec\n', toc);

% --- Train

fprintf('Train ...');
tic

net = trainNetwork(Sfd, cat, layers, options);

fprintf(' %.02f sec\n', toc);

% --- Save neural network

save(netname, 'net');

