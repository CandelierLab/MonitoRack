function video

clc

% === Parameters ==========================================================

% Images
W = 640;
H = 512;

% === Figure ==============================================================

% --- General 

fig = figure(1);
fig.MenuBar = 'none';
fig.ToolBar = 'none';
fig.Name = 'MonitoRack';
fig.CloseRequestFcn = @closeFigure;

fig.Position = [0 42 980 820];

% --- Image ---------------------------------------------------------------

ax = axes('units', 'pixels');
ax.Position = [10 10 960 768];

% Initialization
Ih = imshow(zeros(512, 640, 'uint8'));

drawnow

% === Image acquisition ===================================================

fprintf("Preparing video acquisition ...");
tic

for i = 1:2
%     try
        
        vid = videoinput('mwspinnakerimaq', 1, 'Mono8');
        src = getselectedsource(vid);
        
%         src.AcquisitionMode = 'True';
%         src.AcquisitionFrameCount = 5000;
%         
%         src.ExposureAuto = 'Off';
%         src.ExposureTime = 40001;
        
        src.AcquisitionFrameRateEnable = 'True';
        src.AcquisitionFrameRate = 25.0011800556986;
        
        src.BinningHorizontal = 2;
        src.BinningVertical = 2;
        
        % vid = videoinput('mwspinnakerimaq', 1, 'Mono8', 'Source', src);
        
        vid.FramesPerTrigger = Inf;
        vid.FramesAcquiredFcnCount = 1;
        vid.FramesAcquiredFcn = @newframe;
        
        break;
%     catch
%         fprintf(" 2nd attempt ...");
%     end
    
end

fprintf(' %.02f sec\n', toc);

% src
vid

% keyboard

% === Acquire =============================================================

t0 = [];
T = [];
frameNumber = 0;
start(vid);

% ### Inner Functions #####################################################

% === Figure ==============================================================

    function closeFigure(hObj, varargin)
        
        try
            
            stop(vid);
            clear vid
            
        catch
        end
        
        delete(hObj);
        
    end

% === Video ===============================================================

    function newframe(~, obj)
        
        warning('off', 'imaq:getdata:infFramesPerTrigger');
        
        % --- Get data
        
        D = getdata(vid);

        if isempty(D), return; end
        
        updateImage(D(:,:,:,1));
        
        if isempty(t0)
            t0 = obj.Data.AbsTime;
        end
%         size(D)
        for k = 1 %:size(D,4)
        
            frameNumber = frameNumber + 1;
            
            % Time
            T(frameNumber) = etime(obj.Data.AbsTime, t0);
            
        end
        
        
    end

    function updateImage(Img)
        
        set(Ih, 'CData', Img);
        caxis([0 255]);
        
        f = 1/mean(diff(T(max(1, numel(T)-100):end)));
        
        title("Frame " + frameNumber + " - " + num2str(f,'%.01f') + "Hz");
        
        drawnow limitrate
        
    end

end