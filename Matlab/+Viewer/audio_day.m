warning('off', 'images:imshow:magnificationMustBeFitForDockedFigure');

clc

% === Parameters ==========================================================

year = 2020;
month = 11;
day = 01;

rws = 100;            % Resampling window size

force = true;

% -------------------------------------------------------------------------

DS = DataSource;

% =========================================================================

% --- Data ----------------------------------------------------------------

if ~exist('D', 'var') || force
    
    fprintf('Loading data ...')
    tic
    
    D = struct('hour', {}, 'T', {}, 'A', {}, 't', {}, 'a', {});
    
    
    % --- Filesystem
    
    % Data directory
    dDir = [DS.Data num2str(year, '%04i') filesep ...
        num2str(month, '%02i') filesep ...
        num2str(day, '%02i') filesep];
    
    for hour = 0:23
        
        D(hour+1).hour = hour;
        fname = [dDir 'audio_' num2str(hour, '%02i') '.dat'];
        
        % --- Data file
        
        mmf = memmapfile(fname, 'Format', 'double');
        D(hour+1).A = mmf.Data;
        D(hour+1).T = (0:numel(mmf.Data)-1)/44100;
        
    end
    
    fprintf(' %.02f sec\n', toc);
    
    % --- Smoothing
    
    fprintf('smoothing data ...')
    tic

    Ns = numel(D(1).A);
    ns = ceil(Ns/rws);
    
    for i = 1:numel(D)
        
        for j = 1:numel(D(i).A)/rws
        
            J = (j-1)*rws+1:j*rws;
            D(i).t(j) = mean(D(i).T(J));
            
            [~, k] = max(abs(D(i).A(J)));
            D(i).a(j) = D(i).A(J(k));
                        
        end
        
    end
    
    fprintf(' %.02f sec\n', toc);

end

% --- Display -------------------------------------------------------------

figure(1)
set(gcf, 'WindowStyle','docked')
clf
hold on

for i = 1:numel(D)

    plot(D(i).t, 3*D(i).a+D(i).hour, '-')
    
end

box on
axis square

xlabel('t (s)', 'Interpreter', 'Latex');
ylabel('Hour + Amplitude', 'Interpreter', 'Latex');

ylim([-0.5 23.5]);

title([num2str(day, '%02i') '-' num2str(month, '%02i') '-' num2str(year, '%04i')]);