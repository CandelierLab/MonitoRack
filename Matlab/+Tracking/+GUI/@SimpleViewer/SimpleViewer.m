classdef SimpleViewer < handle
    %VIEWER Viewer for the data
    
    properties
        
        % Data
        year
        month
        day
        hour
        
        Images = struct('mmap', [], 'N', [])
        
        % GUI
        Viewer
        Window = struct('position', [], 'color', [])
        Visu = struct('intensityFactor', 1, 'frameFormat', '%04i')
        ui = struct()
        
    end
    
    methods
        
        % --- CONTRUCTOR --------------------------------------------------
        
        function this = SimpleViewer(varargin)
            clc
        end
        
    end
end

