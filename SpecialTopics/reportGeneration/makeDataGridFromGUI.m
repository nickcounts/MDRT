function outputCellArray = makeDataGridFromGUI (hobj, event, varargin) 
%% makeDataGrid
%
%   makeDataGrid is a helper script that takes a list of FDs from the 
%   gridMaker script, interpolates the time series data to conform to a
%   set of supplied timestamps and then writes the values at those
%   timestamps into one large cell array with timestamps as row headers and
%   FD title as column headers.
%
%   Looks for appdata in the calling GUI called:
%       selectedList cell{ 'FD String', 'fullFileName', [dataIndex] }
%
%
%   Counts 10-2017, VCSFA


%% Load app data from calling GUI

    mdrt = getappdata(hobj.Parent);


%% Load Timeline Information from Data Set (with some error checking)

path = mdrt.dataIndex(mdrt.selectedList{1,3}).pathToData;

if exist(fullfile(path, 'timeline.mat'), 'file')
    s = load(fullfile(path, 'timeline.mat'));
    
    if isfield(s, 'timeline') 
        
        if  s.timeline.uset0
            t0 = s.timeline.t0.time;
            
        else
            % No t0 specified. Ask?
            error('No t0 time specified for this data set.');
            
        end
        
    else
        % No timeline variable was found
        error('Loading timeline failed.'); 

    end
    
else
    % No timeline file was present.
    error('Loading timeline failed.');    
end
    
    
% t0 = datenum(2014,10,28,22,22,38.014); % ORB-3 r2
% t0 = datenum(2014,10,27,22,43,03.0); % ORB-3 r1
% t0 = datenum(2014, 7,13,16,52,14);   % ORB-2
% t0 = datenum(2014,1, 9,18,07,06);   % ORB-1


%% Use timeHacks vector to generate the timesteps

% %%%%%%%%%%%%%%%%%%%%%%%%%
% % Grid Setup Parameters %
% %%%%%%%%%%%%%%%%%%%%%%%%%

defaultHoursBefore = 8;
defaultHoursAfter  = 8;
defaultIntervalInMinutes = 15;

    prompt = {  'Grid Interval (minutes):', ...
                'Start Hours before T0:', ...
                'End Hours after T0:'};
            
    dlg_title = 'Input Data Grid Parameters';
    
    num_lines = 1;
    
    defaultans = {  num2str(defaultIntervalInMinutes), ...
                    num2str(defaultHoursBefore), ...
                    num2str(defaultHoursAfter)};

answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

    [intervalInMinutes, hoursBefore, hoursAfter] = deal(answer{:,1});

intervalInMinutes   = str2num(intervalInMinutes);
    if isempty(intervalInMinutes); 
        intervalInMinutes = defaultIntervalInMinutes; 
    end

hoursBefore         = str2num(hoursBefore);
    if isempty(hoursBefore); 
        hoursBefore = defaultHoursBefore; 
    end

hoursAfter          = str2num(hoursAfter);
    if isempty(hoursAfter);  
        hoursAfter  = defaultHoursAfter;
    end

timeHacks = hoursBefore/24: -(1/24/60*intervalInMinutes) : -hoursAfter/24;
datestr(timeHacks, 'HH:MM:SS');
newTimeVector = t0 - timeHacks;


%% Step through each data file

filePaths = cell(size(mdrt.selectedList,1));


for i = 1:length(filePaths)
    
    filePaths{i} = fullfile(path, mdrt.selectedList{i,2});
    dataFileExists(i) = exist(filePaths{i},'file');

end



outputCellArray = cell(length(newTimeVector)+1, length(filePaths)+1);

% Write the first column of timestamps
outputCellArray(2:end,1) = cellstr(datestr(newTimeVector));

progressbar('Processing Launch Data');

for i = 1:length(filePaths)
    if dataFileExists(i)
        % A little error checking before file is loaded.
        % Data that do not exist will be skipped.
        
        load(filePaths{i});
        
        % resampling uses linear interpolation by default. If the time
        % interval extends beyond the original data, resample will return a
        % value of NaN.
        ts1 = resample(fd.ts, newTimeVector);
        
        % make a temporary variable to allow mixing cell arrays and
        % matrices
        data = num2cell(ts1.Data);
        
        % Fill in numerical Data
        outputCellArray(2:end,i+1) = data;
        
        % Fill in column header information
        outputCellArray{1,i+1} = [fd.Type, '-', fd.ID];
        
    else
        outputCellArray{1,i+1} = [mdrt.selectedList{i,1}];
    end
    
    progressbar(i/length(filePaths));
        
end

outputCellArray;

hs.fig = figure;
hs.t = uitable(hs.fig, 'Data', outputCellArray, ...
    'units',        'normalized', ...
    'position',     [0.05 0.05 0.9 0.9]);








