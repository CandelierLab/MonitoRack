classdef Images < handle
    
    properties
        
        year
        month
        day
        hour
        
        path
        Files
        map
        
        W
        H
        T
        
        Proc
        Bkg
        
    end
    
    
    methods
   
        function this = Images(year, month, day, hour)
        
            % --- Files and folders
            
            DS = DataSource;
            
            % File properties
            this.year = year;
            this.month = month;
            this.day = day;
            this.hour = hour;
            
            % Path
            this.path = [num2str(this.year, '%04i') filesep num2str(this.month, '%02i') filesep  num2str(this.day, '%02i') filesep];
            
            % Files
            this.Files = struct('data', [DS.Data this.path 'video_' num2str(this.hour, '%02i') '.dat'], ...
                'processed', [DS.Files this.path 'processed_' num2str(this.hour, '%02i') '.dat'], ...
                'mlabel', [DS.Files this.path 'mlabel_' num2str(this.hour, '%02i') '.mat'], ...
                'label', [DS.Files this.path 'label_' num2str(this.hour, '%02i') '.mat']);
            
            % Memory mapping
            this.map = struct('data', [], 'processed', []);
            
            if exist(this.Files.data, 'file')
                this.map.data = memmapfile(this.Files.data, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });
            end
            
            if exist(this.Files.processed, 'file')
                this.map.processed = memmapfile(this.Files.processed, 'Format', {'double' [1 1] 't' ; 'uint8' [512 640] 'frame' });
            end
            
            % --- Info
            
            this.W = 640;
            this.H = 512;
            for i = 5000:-1:1
                if this.map.data.Data(i).frame(1)
                    this.T = i; 
                    break
                end
            end
            
            % --- Procedures
            
            this.Proc = struct('IP', struct(), 'Sub', struct());
            
        end
        
    end
    
end