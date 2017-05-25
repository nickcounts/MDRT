function reviewPlotAllTimelineEvents ( varargin )
%reviewPlotAllTimelineEvents
%
%   Plots all timeline milestones for a given data set, as stored in the
%   timeline.mat file.
%
%   Accepts the following arguments:
%
%   reviewPlotAllTimelineEvents( configStruct )
%   reviewPlotAllTimelineEvents( timeLineStruct )
%   reviewPlotAllTimelineEvents( timeLineStruct, timeShift )
%
%   End of support argument: (maintained for legacy support, depricated)   
%
%   reviewPlotAllTimelineEvents( config, handles )
%       written for a specific GUI handle structure in a legacy function.
%       Planned for deprecation.
%
%   reviewPlotAllTimelineEvents() 
%       relys on getConfig(), planned for deprecation.

deltaT = 0;
timelineFileName = 'timeline.mat';

if nargin == 0
    
    config = getConfig;
    path = config.dataFolderPath;
    t = load( fullfile(path, timelineFileName));
    
    timeline = t.timeline;
    
elseif nargin == 1
    
    switch checkStructureType(varargin{1})
        case 'timeline'
            timeline = varargin{1};
            
        case 'config'
            config = varargin{1};
            path = config.dataFolderPath;
            t = load( fullfile(path, timelineFileName));
            
            timeline = t.timeline;
            
        otherwise
            % Someone passed something naughty.
            type1 = class(varargin{1});
            type2 = class(varargin{2});
            
            warnMsg = sprintf('No valid function call for arguments (%s, %s)', type1, type2);
            
            warning(warnMsg);
            
    end
    
elseif nargin == 2
    
    if ishandle(varargin{2}) && isstruct(varargin{2})
                
        % NOTE: This code block is retained as legacy support for the data
        % searching tools developed by MARS interns in the summer of 2016.
        % -----------------------------------------------------------------
        
        % --> Uses handles to get selected value from list and corresponding path
        % to the correct data set, then uses path to data set to load the correct
        % tieline file and plot it in quickPlot (this repaces config)
        
        handles = varargin{2};
        timeline = varargin{1};
        
        index = get(handles.FDList_popupmenu,'Value');
        string = handles.FDList_popupmenu.String{index};

        for i = 1:length(handles.masterFDList.names);

            if strcmp(string,handles.masterFDList.names(i));
                newIndex = i;
            end
        end

        % Now can call the data from "newList" or with "newIndex" from old master
        % list --- these both do the same thing. 

        pathToDataSet = char(handles.masterFDList.pathsToDataSet{newIndex});

        t = load([fullfile(pathToDataSet,filesep,'timeline.mat')],'-mat');
        timeline = t.timeline;
        
        % END OF LEGACY CODE SUPPORT
        % -----------------------------------------------------------------
        
        
    else
        
        %TODO: Add type checking
        timeline = varargin{1};
        deltaT = varargin{2};
        
    end
    
end




% load([path, filesep, timelineFile]);

    % Manual plotting of t0 in red...
    % TODO: Implement timezone conversion
    
    % timeline structure:
    % 
    % notPlottable: bool
    %
    % timeline.t0
    % 
    %    name: 'T0'
    %    time: 735608.754918981
    %     utc: 1
    %
    % timeline.milestone:
    % 
    %     String: 'PHS Warm He Charging'
    %   FD: 'GHe-W Charge Cmd'
    % Time: 735608.504930556
    %
    
    
        

    if timeline.t0.utc
        timezone = 'UTC';
    else
        timezone = 'Local';
    end
    
  
    if timeline.uset0
        
        % Plot events as T-minus times
    
        t0string = [timeline.t0.name, ': ', datestr(timeline.t0.time,'HH:MM.SS'), ' ' timezone];
        vline(timeline.t0.time + deltaT,'r-',t0string,0.5)

        for i = 1:length(timeline.milestone)
            dt = timeline.milestone(i).Time - timeline.t0.time;
            if dt < 0
                % Negative delta means T-
                timeModifier = '-';
            else
                % Positive delta means T+
                timeModifier = '+';
            end

            eventString = sprintf('T%s%s %s', timeModifier, datestr(abs(dt), 'HH:MM:SS'),timeline.milestone(i).String);

            hvl = vline(timeline.milestone(i).Time + deltaT,  '-k' , eventString,  [0.05,-1]);

        end
        
    else
       
        % Plot events as absolute time
    
        for i = 1:length(timeline.milestone)
            eventTime = timeline.milestone(i).Time;

            eventString = sprintf('%s %s', datestr(eventTime, 'HH:MM:SS'),timeline.milestone(i).String);

            hvl = vline(timeline.milestone(i).Time + deltaT,  '-k' , eventString,  [0.05,-1]);

        end
        
    end
        
        
    