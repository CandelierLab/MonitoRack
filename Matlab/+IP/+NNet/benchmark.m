clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0;

Nt = [10 20 50 100 200 500 1000 2000];

ws = 21;

force = false;

% -------------------------------------------------------------------------

DS = DataSource;

Str = IP.Images(year, month, day, hour);

% =========================================================================

% --- Load labels ---------------------------------------------------------

if ~exist('L', 'var') || force
    
    fprintf('Loading labels ...');
    tic
    
    tmp = load([Str.Files.label(1:end-4) '_GT.mat'], 'L');
    L = tmp.L;
    
    fprintf(' %.02f sec\n', toc);
    
end

% --- Prepare feature data (sub images) -------------------------------

if ~exist('Sfd', 'var') || force
    
    fprintf('Prepare features ');
    tic
    
    % Preallocate
    Sfd = zeros(ws, ws, 1, numel(L), 'uint8');
    
    for i = 1:numel(L)
        
        Sfd(:,:,1,i) = Str.getSub(L(i).t, L(i).x, L(i).y, ws);        
        
        if ~mod(i, 2000), fprintf('.'); end
        
    end
    
    fprintf(' %.02f sec\n', toc);
    
end

% --- Prepare network -----------------------------------------------------

fprintf('Prepare network ...');
tic

nCat = numel(unique([L(:).l]));

layers = [
    imageInputLayer([ws ws 1])
    
    convolution2dLayer(3, 8, 'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 16,'Padding','same')
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
    'InitialLearnRate', 0.1, ...
    'MaxEpochs', 5, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', false, ...
    'Plots', 'none');

imageAugmenter = imageDataAugmenter('RandRotation',[-180,180]);

% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',5, ...
%     'MiniBatchSize',64, ...
%     'Plots','training-progress');

fprintf(' %.02f sec\n', toc);

% === Iterations ==========================================================

% ppm = NaN(numel(Nt),1);

% % % for iter = 1:numel(Nt)
% % %     
% % %     fprintf('--- Iteration %i -----------------\n', iter);
% % %     
% % %     Nf = nnz([L(:).t]<=Nt(iter));
% % %     
% % %     % ---  Train network --------------------------------------------------
% % %     
% % %     fprintf('Train ...');
% % %     tic
% % %     
% % %     cat = categorical( [L(1:Nf).l]);
% % %     net = trainNetwork(Sfd(:,:,1,1:Nf), cat, layers, options);
% % %     
% % % %     augimds = augmentedImageDatastore([ws ws], Sfd(:,:,1,1:Nf), cat,'DataAugmentation',imageAugmenter);    
% % % %     net = trainNetwork(augimds, layers, options);
% % %     
% % %     fprintf(' %.02f sec\n', toc);
% % % 
% % %     % --- Save neural network
% % %     
% % %     % save(netname, 'net');
% % % 
% % %     % --- Classify --------------------------------------------------------
% % %     
% % %     fprintf('Predict ...');
% % %     tic
% % %     
% % %     pred = predict(net, Sfd(:,:,1,Nf+1:end));
% % %     
% % %     l = pred(:,2)>=0.5;
% % %     
% % %     fprintf(' %.02f sec\n', toc);
% % %     
% % %     % --- Compare
% % %     
% % %     Np = numel(L)-Nf;
% % %     Nok = nnz([L(Nf+1:end).l]'==l);
% % %     
% % %     ppm(iter) = (Np-Nok)/Np*numel(L);
% % %     
% % %     fprintf('Result: %i\n', round(ppm(iter)));
% % %     
% % % end

% IP.NNet.GUI.checkNet(L(Nf+1:end), l);

clf
hold on

plot(Nt, ppm, '.-')

ylim([0 2500])
set(gca, 'XScale', 'log')

box on
grid on

xlabel('Training set size (number of images)')
ylabel('Numbre of errors per movie')

