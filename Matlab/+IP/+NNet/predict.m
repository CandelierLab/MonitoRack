clc

% === Parameters ==========================================================

year = 2020;
month = 10;
day = 7;
hour = 0;

ws = 21;

netname = '/home/raphael/Bureau/test/mnet.mat';

force = true;

% -------------------------------------------------------------------------

DS = DataSource;

Str = IP.Images(year, month, day, hour);

% =========================================================================

% --- Load

fprintf('Loading ...');
tic

% Labels
tmp = load(Str.Files.label);
L = tmp.L;

% Neural network
tmp = load(netname);
net = tmp.net;

fprintf(' %.02f sec\n', toc);

% --- Loop on feature data ------------------------------------------------

fprintf('Predicting .');
tic

for i = 1:numel(L)
    
    Sub = Str.getSub(L(i).t, L(i).x, L(i).y, ws);
    pred = predict(net, Sub);
    L(i).p = pred(2);        
    L(i).l = pred(2)>=0.5;
    
    if ~mod(i, 2000), fprintf('.'); end
    
end

fprintf(' %.02f sec\n', toc);

% --- Save labels

save(Str.Files.label, 'L');