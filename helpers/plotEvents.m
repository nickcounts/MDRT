function plotEvents( path, eventFileName, eventFilter, varargin )
%plotAllEvents reads the events.mat variable and plots vertical lines on
%the current graphics context with labels at the correct times.
%
%   path = '/Users/nick/Documents/MATLAB/ORB-D1/Data Files/'
%   eventFile = 'events.mat'
%

% clean up input to make life easier on users!
eventFilter = lower(eventFilter);

events = load([path eventFileName]);
events = events.events; %fix this later = variable loads as a structure


lineStyle = '-r';
if ~isempty(varargin)
    lineStyle = varargin{1};
end
    

t0 = datenum( events{1,4}, events{1,2}, events{1,3}, ...
              events{1,5}, events{1,6}, events{1,7} );

for i = 2:length(events)
    % iterate through remaining events in variable.
    % Remeber to find start AND stop times!
    
    % Event Start
    eStart = datenum(events{1,4},events{1,2},events{1,3}, ...
                     events{1,5}-events{i,2}, ...
                     events{1,6}-events{i,3}, ...
                     events{1,7}-events{i,4});
                 
    eStop  = datenum(events{1,4},events{1,2},events{1,3}, ...
                     events{1,5}-events{i,5}, ...
                     events{1,6}-events{i,6}, ...
                     events{1,7}-events{i,7});
    
    eStartLabel = events{i,1};
    
    eStopLabel  = [events{i,1} ' END'];
    
    % filter out only relavent events
    if (isequal(lower(events{i,1}),eventFilter) || (isequal(lower(events{i,8}),eventFilter)) )
        
        vline(eStart, lineStyle , eStartLabel, [0.05,-1])
        
        % Don't plot over T0
        if (eStop ~= t0)
            vline(eStop,  lineStyle , eStopLabel,  [0.05,-1])
        end
        
    end
    
end

