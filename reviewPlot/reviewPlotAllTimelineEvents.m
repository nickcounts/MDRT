function reviewPlotAllTimelineEvents ( varargin )
% Accepts the config structure

% Updated to allow plotting without passing a config structure
% If nothing is passed, calls getConfig
% Can also pass timelineStruct, deltaT (for shifting times if desired)
%
%   Updated: Counts, 2016 - VCSFA

deltaT = 0;

if nargin == 0
    config = getConfig;
    
    path = config.dataFolderPath;
    timelineFile = 'timeline.mat';

    load([path timelineFile]);
    
    
elseif nargin == 1
    config = varargin{1};
    
    path = config.dataFolderPath;
    timelineFile = 'timeline.mat';

    load([path timelineFile]);
    
elseif nargin == 2
    timeline = varargin{1};
    deltaT = varargin{2};
end



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
        
        
        % Plot the T-0 time in red
        t0string = [timeline.t0.name, ': ', datestr(timeline.t0.time,'HH:MM.SS'), ' ' timezone];
        vline(timeline.t0.time + deltaT,'r-',t0string,0.5)
        
        % Plot all other milestones in black
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

            vline(timeline.milestone(i).Time + deltaT,  '-k' , eventString,  [0.05,-1]);

        end
        
    else
       
        % Plot events as absolute time
    
        for i = 1:length(timeline.milestone)
            eventTime = timeline.milestone(i).Time;

            eventString = sprintf('%s %s', datestr(eventTime, 'HH:MM:SS'),timeline.milestone(i).String);

            vline(timeline.milestone(i).Time + deltaT,  '-k' , eventString,  [0.05,-1]);

        end
        
    end
        
        
    