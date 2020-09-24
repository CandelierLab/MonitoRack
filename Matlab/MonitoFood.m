function MonitoFood()

clc
close all

% === Parameters ==========================================================

W = 400;
H = 600;

% -------------------------------------------------------------------------

DS = DataSource;

% === Figure ==============================================================

% --- General

fig = figure(1);
fig.MenuBar = 'none';
fig.ToolBar = 'none';
fig.Name = 'MonitoFood';
fig.CloseRequestFcn = @closeFigure;

sz = get(0,'ScreenSize');
fig.Position = [sz(3)-W-100 sz(4)-H-100 W H];

% --- Food types

ftype = {'GM 100', 'GM 75', 'Algae', 'Rotifers'};
funit = {'mg', 'mg', 'mL', 'mL'};

H1 = 400;

for i = 1:numel(ftype)
    
    tFood(i) = uicontrol('Style', 'text');
    tFood(i).Units = 'pixels';
    tFood(i).Position = [10 H1+i*35-7 175 25];
    tFood(i).FontName = 'Lucida Sans Unicode';
    tFood(i).FontSize = 11;
    tFood(i).HorizontalAlignment = 'right';
    tFood(i).String = ftype{i};
    
    eFood(i) = uicontrol('Style', 'edit');
    eFood(i).Units = 'pixels';
    eFood(i).Position = [200 H1+i*35 50 25];
    eFood(i).FontName = 'Lucida Sans Unicode';
    eFood(i).FontSize = 11;
    eFood(i).HorizontalAlignment = 'center';
    eFood(i).String = '';
   
    uFood(i) = uicontrol('Style', 'text');
    uFood(i).Units = 'pixels';
    uFood(i).Position = [260 H1+i*35-7 25 25];
    uFood(i).FontName = 'Lucida Sans Unicode';
    uFood(i).FontSize = 11;
    uFood(i).HorizontalAlignment = 'left';
    uFood(i).String = funit{i};
    
end

% --- Other

i = numel(ftype)+1;
tFood(i) = uicontrol('Style', 'text');
tFood(i).Units = 'pixels';
tFood(i).Position = [10 H1 175 25];
tFood(i).FontName = 'Lucida Sans Unicode';
tFood(i).FontSize = 11;
tFood(i).HorizontalAlignment = 'Left';
tFood(i).String = "Other";

eFood(i) = uicontrol('Style', 'edit');
eFood(i).Units = 'pixels';
eFood(i).Position = [10 H1-75 W-20 75];
eFood(i).FontName = 'Lucida Sans Unicode';
eFood(i).FontSize = 11;
eFood(i).HorizontalAlignment = 'left';
eFood(i).String = '';
eFood(i).Min = 0;
eFood(i).Max = 5;

% --- Submit

submit = uicontrol('Style', 'pushbutton');
submit.Units = 'pixels';
submit.Position = [W/2-50 H1-120 100 30];
submit.FontName = 'Lucida Sans Unicode';
submit.FontSize = 11;
submit.HorizontalAlignment = 'Center';
submit.String = "Submit";
submit.Callback = @Submit;

% --- Output

tOut = uicontrol('Style', 'edit');
tOut.Units = 'pixels';
tOut.Position = [10 10 W-20 250];
tOut.BackgroundColor = [0 0 0];
tOut.ForegroundColor = [0 1 0];
tOut.FontName = 'Monospaced';
tOut.FontSize = 10;
tOut.HorizontalAlignment = 'left';
tOut.Enable = 'inactive';
tOut.Min = 0;
tOut.Max = 2;
output = "";

drawnow


% ### Inner Functions #####################################################

    function Submit(varargin)
       
        % --- Create text
        
        t = "";
        
        for i = numel(ftype):-1:1
            if ~isempty(eFood(i).String)
                t = t + ftype{i} + ': ' + eFood(i).String + " " + funit{i} + "\n";
            end
        end
        
        i = numel(ftype)+1;
        if ~isempty(eFood(i).String)
            t = t + eFood(i).String + "\n";
        end
        
        % --- Check
        
        if ~t.strlength
            cout("No info to save, aborting.\n");
            return
        end
        
        % --- Save file
        
        tv = datevec(now);
        
        fname = [DS.Data num2str(tv(1), '%04i') filesep ...
        num2str(tv(2), '%02i') filesep ...
        num2str(tv(3), '%02i') filesep 'feeding_'...
        num2str(tv(4), '%02i') 'h' ...
        num2str(tv(5), '%02i') 'm' ...
        num2str(round(tv(6)), '%02i') 's.txt'];
        
        % Check dir        
        ddir = fileparts(fname);
        if ~exist(ddir, 'dir')
            mkdir(ddir);
        end
    
        % Save
        if ~exist(fname, 'file')
            
            fid = fopen(fname, 'w');
            fprintf(fid, t);
            fclose(fid);
            
        end
        
        % --- Display log
        
        % Add timestamp
        t = t + "Saved on " + num2str(tv(1), '%04i') + '/' + ...
            num2str(tv(2), '%02i') + '/' + num2str(tv(3), '%02i') + ...
            " @ " +  num2str(tv(4), '%02i') + 'h' + ...
            num2str(tv(5), '%02i') + 'm' + num2str(round(tv(6)), '%02i') +'s\n';
        
        % Flush
        cout(t + "----------------------------------------------\n");
        
        % --- Clear values
        
        for i = 1:numel(ftype)+1
            eFood(i).String = "";
        end
        
    end

    function cout(s)
        
        output = string(s) + output;
        tOut.String = replace(output, '\n', newline);
        
        drawnow
    end

    function closeFigure(hObj, varargin)
        
        delete(hObj);
        
    end

end