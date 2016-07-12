function [ graph ] = getPlotParameters( varargin )
% getPlotParameters returns a graph structure for use in automated plotting
% by makeReviewPlot.m
%
%   graph = getPlotParameters('myPlot.xlsx')
%
%   If called with no arguments, getPlotParameters will open a file picker.
%
%   getPlotParameters reads the following commands from a standard excel
%   document:
%
%       graph   Defines a new figure and is used as the title and filename
%       plot    Defines a plot or subplot in the figure and is used as
%               subtitle
%       data    a numerical argument is used to identify the FCS item to be
%               plotted.
%       event   Defines event markers to be placed (vertical lines)
%       start   Defines the start of the plot (auto, t+, t-, utc) h m s or
%               hh:mm:ss if using utc
%       stop    Defines the end of the plot (auto, t+, t-, utc) h m s or
%               hh:mm:ss if using utc
% 
% Counts, 10-08-13 - Spaceport Support Services



% % if exist([pwd '/' 'review.cfg'],'file')
% if exist(fullfile(pwd, 'review.cfg'),'file')
%    
%     load('review.cfg','-mat');
%     
% end

% Updated Counts, 10-9-14
config = getConfig;




% If no file is specified, open a GUI to choose a plot config file!
% -------------------------------------------------------------------------

if (isempty(varargin))

    [filename, pathname] = uigetfile( ...
    {  '*.xlsx',  'Excel file (*.xlsx)'; ...
       '*.xls',   'Excel file (*.xls)'; ...
       '*.*',  'All Files (*.*)'}, ...
       'Pick a file', fullfile(config.dataFolderPath, '..','*.*'));
   
    pathnameFilename = strcat(pathname, filename);
   
else
    
    pathnameFilename = varargin{1};
    
end

% Read in the plot instructions
% -------------------------------------------------------------------------

% [~,~,a] = xlsread('graphConfig.xlsx');
    [b,c,a] = xlsread(pathnameFilename);


% Ensure all data in first 2 columns are treated as strings
    A = a(:,1:2);
    
    containsNumbers = cellfun(@isnumeric,A);
    
    A(containsNumbers) = cellfun(@num2str,A(containsNumbers), ...
                                 'UniformOutput',false);

    a(:,1:2) = A;

% Parse the plot instructions
% -------------------------------------------------------------------------


% Clean up the command column for parsing
    a(:,1) = lower(a(:,1));


% Initialize variables:
    dataStreams = [];
    streams = [];
    graphName = [];
    graphSubplotNames = [];
    eventsToDisplay = [];
    dataStreamCount = 0;

firstPass = true;

graphNumber = 1;

timeLimits = struct('isStartTimeUTC',[], ...
                    'isStartTimeAuto', true, ...
                    'startTime', [], ...
                    'isStopTimeUTC', [], ...
                    'isStopTimeAuto', true, ...
                    'stopTime',[]);
                
    
% Loop through incoming strings!
for i = 1:size(a,1)
    
    % Define behaviors for each command.
    % Load variables
    switch a{i,1}
        
        case {'title', 'graph'}
            % I found a new plot command!
%             disp(['I want make new a graph called: ' a{i,2}])
            
            % increment my fracking plot counter 
            if (~firstPass)
                % Process all stored data as a graph structure and continue
                % parsing.
                
                graph(graphNumber).name = graphName;
                graph(graphNumber).subplots = graphSubplotNames;
                graph(graphNumber).streams = streams;
                graph(graphNumber).events = eventsToDisplay;
                graph(graphNumber).time = timeLimits;
                
                
                graphNumber = graphNumber + 1;
                
                graphSubplotNames = [];
                eventsToDisplay = [];
                
                dataStreamCount = 0;
                
            else
                % First time through - set up the array of structures
                firstPass = false;
                
            end
            
            graphName = a(i,2);
            dataStreamCount = 0;
            
        
        case {'plot' 'subplot'}
            % I found a new subplot command!
%             disp(['I want a subplot called: ' a{i,2}])
                        
            graphSubplotNames = [graphSubplotNames a(i,2)];

            dataStreamCount = dataStreamCount + 1;
            dataStreams = [];
            
        case {'data' 'fd'}
            % I found a data stream!
%             disp(['I want to plot FCS item: ' a{i,2}])
            dataStreams = [dataStreams a(i,2)];
            
%             streams(dataStreamCount).toPlot = dataStreams;
            streams(dataStreamCount).toPlot = dataStreams;
            
        case {'events' 'event'}
            % I found an events filter!
            eventsToDisplay = [eventsToDisplay a(i,2)];
        
           
        case 'start'
            % I found a start time!
            disp(['I want my graph to start at time: ' a{i,2}])
                        
                        
            switch a{i,2}
                case 't-'
                    timeStart = a{i,3};
                    
                    timeStart = timeStart * -1';
                    
                    timeLimits.isStartTimeUTC = false;
                    timeLimits.isStartTimeAuto = false;
                    
                    timeLimits.startTime = timeStart;
                    
                case {'t', 't+'}
                    
                    timeStart = a{i,3};
                    
                    if (timeStart < 0)
                        disp('T+ time given as - value. Converting to positive time');
                        timeStart = abs(timeStart);
                    end
                    
                    timeLimits.isStartTimeUTC = false;
                    timeLimits.isStartTimeAuto = false;
                    
                    timeLimits.startTime = timeStart;
                    
                case 'utc'
                    
                    timeStart = a{i,3};
                    
                    timeLimits.isStartTimeUTC = true;
                    timeLimits.isStartTimeAuto = false;
                    % in case for some reason I get a negative time?
                    timeLimits.startTime = x2mdate(abs(timeStart));
                    
                case 'auto'
                    timeLimits.isStopTimeAuto = true;
                otherwise
                    % TODO: Implement other time formats
            end
            
            
        
        case 'stop'
            % I found a stop time!
            disp(['I want my graph to stop at time :' a{i,2}])
            try
                timeStop = a{i,3};
            end
            
            switch a{i,2}
                case 't-'
                    timeStop = timeStop * -1';
                    timeLimits.isStopTimeUTC = false;
                    timeLimits.stopTime = timeStop;
                    timeLimits.isStopTimeAuto = false;
                    
                case {'t', 't+'}
                    
                    if (timeStop < 0)
                        disp('T+ time given as - value. Converting to positive time');
                        timeStop = abs(timeStop);
                    end
                    
                    timeLimits.stopTime = timeStop;
                    timeLimits.isStopTimeAuto = false;
                    timeLimits.isStopTimeUTC = false;
                    
                case 'utc'
                    timeLimits.isStopTimeUTC = true;
                    timeLimits.isStopTimeAuto = false;
                    % in case for some reason I get a negative time?
                    timeLimits.stopTime = x2mdate(abs(timeStop));
                case 'auto'
                    timeLimits.isStopTimeAuto = true;
                otherwise
                    % TODO: Implement other time formats
            end
            
        case {'ignore' 'nan'}
        
        otherwise
            % No defined behavior for this command
            
            disp('Sorry, this command has not been implemented')
            
    end % end of switch statement
end % end of iteration through commands




graph(graphNumber).name = graphName;
graph(graphNumber).subplots = graphSubplotNames;
graph(graphNumber).streams = streams;
graph(graphNumber).events = eventsToDisplay;
graph(graphNumber).time = timeLimits;

