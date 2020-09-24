function DS = DataSource()

DS = struct('root', '');

% --- Root

switch computer
    
    case 'PCWIN64'
        test = {'D:\MonitoRack\' ...
            'C:\Users\Jean Perrin\Documents\Science\Projects\MonitoRack\'};
        
    case 'GLNXA64'
        test = {'/home/ljp/Science/Projects/Behavior/MonitoRack/' ...
            '/home/raphael/Science/Projects/Behavior/MonitoRack'};
end

for i = 1:numel(test) 
    if exist(test{i}, 'dir')
        DS.root = test{i};
        break;
    end
end

if isempty(DS.root)
    return
end

% --- Data

DS.Data = [DS.root 'Data' filesep];

% --- Programs

DS.Programs = [DS.root 'Programs' filesep];