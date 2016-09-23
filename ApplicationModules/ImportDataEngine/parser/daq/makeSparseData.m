% fileList = {...
%             'STE PT.mat';
%             '8020 Open.mat';
%             '8020 Close.mat';
%             '8030 Open.mat';
%             '8030 Close.mat';
%             '8020 Command.mat';
%             '8030 Command.mat'};
        
fileList = {...
            'MARDAQ STE PT.mat';
            'MARDAQ 8020 Open.mat';
            'MARDAQ 8020 Close.mat';
            'MARDAQ 8030 Open.mat';
            'MARDAQ 8030 Close.mat';
            'MARDAQ 8020 Command.mat';
            'MARDAQ 8030 Command.mat'};
        
% pathToData = '/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-06 - HSS Testing ITR-1448 - Day 1/data'
% pathToData = '/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data'
pathToData = uigetdir('~/Documents/Spaceport/Data');

sampleHz = 30;
sampleTimeDelta = 1/24/60/60/sampleHz;

for i = 1:numel(fileList)
    
    disp(sprintf('Loading data file: %s', fileList{i}));
    f = load( fullfile( pathToData, fileList{i}) );
    
	newTs = f.fd.ts.resample(f.fd.ts.Time(1):sampleTimeDelta:f.fd.ts.Time(end))
    
    newName = strjoin({newTs.Name, '-', 'Filtered'});
    [garbage, fname, ext] = fileparts(fileList{i});
    
    newFileName = strjoin({fname, '-', 'Filtered'});
    newFileName = [newFileName, ext];
    
    disp(sprintf('Saving data file: %s', newFileName));
    
    newTs.Name = newName;
    f.fd.ts = newTs
    f.fd.FullString = newName;
    fd = f.fd;
    
    save( fullfile( pathToData, newFileName), 'fd' );
    
end