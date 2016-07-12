function plotAllEvents( path, eventFileName )
%plotAllEvents reads the events.mat variable and plots vertical lines on
%the current graphics context with labels at the correct times.
%
%   path = '/Users/nick/Documents/MATLAB/ORB-D1/Data Files/'
%   eventFile = 'events.mat'
%

events = load([path eventFileName]);
events = events.events; %fix this later = variable loads as a structure


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

    vline(eStop,  '-r' , eStopLabel,  0.05)
    vline(eStart, '-r' , eStartLabel, 0.05)
    
end

