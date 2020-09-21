function audio

clc

% === Parameters ==========================================================

sampleRate = 44100;

ssi = 250;

ssf = 1;
flim = 2000;

% === Figure ==============================================================

% --- General

fig = figure(1);
fig.CloseRequestFcn = @closeFigure;

% --- Get ID of the ZOOM U-22

aInfo = audiodevinfo;
for i = 1:numel(aInfo.input)
    if ~isempty(regexp(aInfo.input(i).Name, 'ZOOM U-22', 'once'))
        aID = aInfo.input(i).ID;
        break
    end
end

aud = [];

startAcquisition

% ### Inner Functions #####################################################

% === Figure ==============================================================

    function closeFigure(hObj, varargin)
        
        try
            clear aud
        catch
        end
        
        delete(hObj);
        
    end

    function startAcquisition(varargin)
        
        aud = audiorecorder(44100, 16, 1, aID);
        aud.StopFcn = @startAcquisition;
        aud.TimerFcn = @updateAudio;
        aud.TimerPeriod = 0.1;
        
        record(aud, 60);
        
    end

    function updateAudio(varargin)
        
        R = varargin{1};
        
        Li = R.SampleRate*5;
        Lf = R.SampleRate/2;
        
        A = getaudiodata(R);
        
        % --- Intensity
        
        Ai = A(max(1, numel(A)-Li):end);
        t = (0:numel(Ai)-1)/sampleRate;
        
        t = smooth(t, ssi);
        Ai = smooth(Ai, ssi);
        t = t(1:ssi:end);
        Ai = Ai(1:ssi:end);
           
        clf
        
        subplot(2,1,1);
        plot(t, Ai, '-')
        
        axis([0 5 -0.5 0.5]);
        box on
        
        xlabel('t (s)')
        ylabel('Intensity')
        
        % --- Frequencies
        try
        
        Af = A(max(1, numel(A)-Lf):end);
                
        Y = fft(Af);
        P2 = abs(Y/Lf);
        P1 = P2(1:Lf/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        
        f = R.SampleRate*(0:(Lf/2))/Lf;
    
        I = find(f>=flim, 1, 'first');
        f = f(1:ssf:I);
        P1 = P1(1:ssf:I);
        
        subplot(2,1,2)
        plot(f, P1, '-')
        
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
        
        axis([0 flim 0 1e-2])
        
        catch
        end
        
    end
end