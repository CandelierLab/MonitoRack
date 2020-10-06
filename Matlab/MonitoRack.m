function MonitoRack()

clc

% === Parameters ==========================================================

% Record duration (s)
recTime = 200;

% Images
W = 640;
H = 512;

% Audio
sampleRate = 44100;

% -------------------------------------------------------------------------

tv = datevec(now);

% Number of images
recNimg = recTime*25;

% Number of audio samples
recNsamples = recTime*sampleRate;

% Errors
Errors = {};

% === Figure ==============================================================

% --- General

fig = figure(1);
fig.MenuBar = 'none';
fig.ToolBar = 'none';
fig.Name = 'MonitoRack';
fig.CloseRequestFcn = @closeFigure;

fig.Position = [500 50 800 1000];

% --- Status

tStatus(1) = uicontrol('Style', 'text');
tStatus(1).Units = 'pixels';
tStatus(1).Position = [10 875 780 75];
tStatus(1).FontName = 'Lucida Sans Unicode';
tStatus(1).FontSize = 45;
tStatus(1).HorizontalAlignment = 'center';
tStatus(1).String = "PREPARING";

tStatus(2) = uicontrol('Style', 'text');
tStatus(2).Units = 'pixels';
tStatus(2).Position = [10 800 780 75];
tStatus(2).FontName = 'Lucida Sans Unicode';
tStatus(2).FontSize = 35;
tStatus(2).HorizontalAlignment = 'center';
tStatus(2).String = "...";

% --- Output

tOut = uicontrol('Style', 'text');
tOut.Units = 'pixels';
tOut.Position = [10 10 780 700];
tOut.BackgroundColor = [1 1 1];
tOut.FontName = 'Monospaced';
tOut.FontSize = 10;
tOut.HorizontalAlignment = 'left';
output = "";

drawnow

% === Indicator ===========================================================

try
    instrreset;
    p = serialportlist("available");
    sInd = serial(p);
    set(sInd,'BaudRate', 115200);
    fopen(sInd);
    cout("Serial connection to indicator ... established.\n");
    pause(3)
catch
    Errors{end+1} = 'Could not establish serial connection.';
    sInd = [];
end

% === Directories and files ===============================================

% Set preparation indicator
if ~isempty(sInd)
    fprintf(sInd, 'p');
end

% --- Data directory

dataDir = 'D:\MonitoRack\Data\';
if ~exist(dataDir, 'dir')
    dataDir = 'C:\Users\Jean Perrin\Documents\Science\Projects\MonitoRack\Data\';
end

cout("Data directory:      " + dataDir + "\n");

% --- Recording directory

recDir = [dataDir num2str(tv(1), '%04i') filesep ...
    num2str(tv(2), '%02i') filesep ...
    num2str(tv(3), '%02i') filesep];

cout("Recording directory: " + recDir + "\n");

if ~exist(recDir, 'dir')
    cout('Creating recording directory\n');
    mkdir(recDir);
end

% --- Creating video file

fname = [recDir 'video_' num2str(tv(4), '%02i') '.dat'];
if exist(fname, 'file')
    
    cout("Existing: " + fname + "\n");
    
else
    
    cout('Creating video file ... ');
    tic
    
    fid = fopen(fname, 'w');
    for j = 1:recNimg
        fwrite(fid, zeros(1, 1), 'double');
        fwrite(fid, zeros(H, W), 'uint8');
    end
    fclose(fid);
    
    cout(sprintf(' %.02f sec\n', toc));
    
    cout("Created: " + fname + "\n");
end

% Memory mapping

cout('Video memory mampping ... ');
tic

mmvideo = memmapfile(fname, ...
    'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' },  ...
    'Repeat', recNimg, 'Writable', true);

cout(sprintf(' %.02f sec\n', toc));

% --- Creating audio file

fname = [recDir 'audio_' num2str(tv(4), '%02i') '.dat'];
if exist(fname, 'file')
    
    cout("Existing: " + fname + "\n");
    
else
    
    cout('Creating audio file ... ');
    tic
    
    fid = fopen(fname, 'w');
    fwrite(fid, zeros(recNsamples, 1), 'double');
    fclose(fid);
    
    cout(sprintf(' %.02f sec\n', toc));
    
    cout("Created: " + fname + "\n");
end

cout('Audio memory mampping ... ');
tic

mmaudio = memmapfile(fname, 'format', 'double', 'Writable', true);

cout(sprintf(' %.02f sec\n', toc));

% === Image acquisition ===================================================

cout("Preparing video acquisition ...");
tic

for i = 1:2
    try
        
        vid = videoinput('mwspinnakerimaq', 1, 'Mono8');
        
        src = getselectedsource(vid);
        src.AcquisitionFrameRateEnable = 'True';
        src.AcquisitionFrameRate = 25.0011800556986;
        src.BinningHorizontal = 2;
        src.BinningVertical = 2;
        
        vid.FramesPerTrigger = Inf;
        vid.FramesAcquiredFcnCount = 1;
        vid.FramesAcquiredFcn = @newframe;
        
        break;
    catch
        switch i
            case 1
                cout(" 2nd attempt ...");
            case 2
                Errors{end+1} = 'Could not initialize camera.';
        end
    end
    
end

cout(sprintf(' %.02f sec\n', toc));

% === Audio acquisition ===================================================

cout("Preparing audio acquisition ...");
tic

try
    aInfo = audiodevinfo;
    for i = 1:numel(aInfo.input)
        if ~isempty(regexp(aInfo.input(i).Name, 'ZOOM U-22', 'once'))
            aID = aInfo.input(i).ID;
            break
        end
    end
    
    aud = audiorecorder(sampleRate, 16, 1, aID);
    aud.StopFcn = @saveAudio;
    
    cout(sprintf(' %.02f sec\n', toc));
    
    cout("Audio device id: " + aID + "\n");
    
catch
    Errors{end+1} = 'Could not initialize audio.';
end

% === Record ==============================================================

% --- Display

tStatus(1).ForegroundColor = [203 67 53]/255;
tStatus(2).ForegroundColor = [128 0 32]/255;
tStatus(1).String = "RECORDING";

% --- Audio

try
    record(aud, recTime);
catch
    cout('# ERROR # Unable to record audio. Aborting.\n');
    Errors{end+1} = 'Could not record audio.';
    return
end

% --- Video

% Set recording indicator
if ~isempty(sInd)
    fprintf(sInd, 'r');
end

t0 = [];
frameNumber = 0;
if isempty(Errors)
    start(vid); 
else
    close all
end

% ### Inner Functions #####################################################

% === Figure ==============================================================

    function cout(s)
        
        output = output + string(s);
        tOut.String = replace(output, '\n', newline);
        
        drawnow
    end

    function closeFigure(hObj, varargin)
        
        try
            
            clear mmvideo
            clear mmaudio
            
            stop(vid);
            clear vid
            
            clear aud
            
            % --- Close the serial connection
            fclose(sInd);
            delete(sInd);
            
        catch
        end
        
        % Error handling
        error_handling();
        
        delete(hObj);
        
    end

    function finish()
        
        pause(0.5);
        
        tStatus(1).ForegroundColor = [0 0 0];
        tStatus(2).ForegroundColor = [0 0 0];
        tStatus(1).String = "DONE";
        tStatus(2).String = "^_^";
        
        if ~isempty(sInd)
            fprintf(sInd, 'i');
        end
        
        pause(3)
        close all
        
    end

% === Video ===============================================================

    function newframe(~, obj)
        
        warning('off', 'imaq:getdata:infFramesPerTrigger');
        
        % --- Get data
        
        D = getdata(vid);
        
        if isempty(D), return; end
        
        % --- Save image(s)
        
        if isempty(t0)
            t0 = obj.Data.AbsTime;
        end
        
        for k = 1 %:size(D,4)
            
            frameNumber = frameNumber + 1;
            
            if frameNumber>recNimg
                stop(vid);
                break;
            end
            
            try
                
                % Time
                mmvideo.Data(frameNumber).t = etime(obj.Data.AbsTime, t0);
                
                % Frame
                mmvideo.Data(frameNumber).frame = squeeze(D(:,:,1,k));
                
                tStatus(2).String = [num2str(recNimg-frameNumber) ' frames remaining'];
                
            catch
                cout("Skipped frame " + frameNumber + "\n");
            end
            
        end
        
    end

% === Audio ===============================================================

    function saveAudio(varargin)
        
        cout("Saving audio data ...");
        tic
        
        % Save audio data
        while true
            a = getaudiodata(aud);
            if numel(a)==recNsamples
                mmaudio.Data = a;
                break;
            end
        end
        
        cout(sprintf(' %.02f sec\n', toc));
        
        % Reset audio object
        clear aud;
        
        finish;
        
    end

% === Errors ==============================================================

    function error_handling()
        
        if isempty(Errors)
            return
        end
                
        % --- Log ---------------------------------------------------------
        
        s = "";
        s = s + sprintf('--- %04i-%02i-%02i @ %02ih:%02im:%02is ---\n', round(datevec(now)));
        
        for k = 1:numel(Errors)
            s = s + sprintf('%s\n', Errors{k});
        end
                
        lname = [recDir 'error_log.txt'];
        fid = fopen(lname, 'a');
        fprintf(fid, s.char);        
        fclose(fid);
        
        % --- Email -------------------------------------------------------
        
        % parameters
        mail = 'danionella.translucida@gmail.com';
        password = ['Da@' 'LJP' '@SU'];
        host = 'smtp.gmail.com';
        sendto = 'raphael.candelier.ljp@gmail.com';
        Subject = '[MonitoRack] Error';
        Message = s.char;
        
        % preferences
        setpref('Internet','SMTP_Server', host);
        setpref('Internet','E_mail',mail);
        setpref('Internet','SMTP_Username',mail);
        setpref('Internet','SMTP_Password',password);
        
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        
        % execute
        sendmail(sendto,Subject,Message)
        
    end

end