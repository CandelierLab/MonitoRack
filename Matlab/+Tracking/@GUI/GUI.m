classdef GUI < handle
%GUI
    
    % === PROPERTIES ======================================================
    
    properties
        
        Viewer
        ui = struct()
        
        Images
                
    end
    
    % === METHODS =========================================================
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = GUI(varargin)
            
            clc
            
            this.Images = struct('Width', [], 'Height', [], 'mmap', []);
            
            % Close all instances of the tracker
            
            
            % Initialize GUI
            this.init;
            
        end
        
    end
end

