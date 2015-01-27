function [ graph ] = newGraphStructure( varargin )
%newGraphStructure returns a graph structure with default fields
%   newGraphStructure
%
%   newGraphStructure('GraphName')
%

switch nargin
    case 1
        % Supplied Graph Name
        graphName = varargin(1);
    otherwise
        % use default name
        graphName = 'Unnamed Graph';
end

subplotTitle = {'Subplot 1'};


% Variable		graph	
% Type          Structure (array)	
% Fields			
%         name		 {'RP1 Transfer Line Pressures'}	
%     subplots		 {'RP1 Line Pressures'}	
%      streams		 [1x1 struct]	
%       events		 {'FLS'}	
%         time		 [1x1 struct]	
% 			
% 			
% Variable		graph(1).streams	
% Type          Structure	
% Fields			
% toPlot		 {'1906'  '1909'  '1902'}	
% 			
% 			
% Variable		graph(1).time	
% Type          Structure	
% Fields			
%      isStartTimeUTC		0               True for UTC, False for "T0" relative
%     isStartTimeAuto		0               True causes the program to auto-fit the data. False requires startTime and isStartTimeUTC
%           startTime		-0.069444444	Matlab time format. Days are integers, time is fractional. Negative implies "T-" when referencing T0
%       isStopTimeUTC		0	
%      isStopTimeAuto		0	
%            stopTime		0.010416667     Matlab time format. Days are integers, time is fractional. Negative implies "T-" when referencing T0
% 



graph = struct(     'name',             cellstr(graphName));


graph.subplots = cellstr(subplotTitle);

streams = struct(   'toPlot', {});
streams(2).toPlot = {};
streams(3).toPlot = {};

time = struct(      'isStartTimeUTC',   1,	...
                    'isStartTimeAuto',  1,	...
                    'startTime',        [],	...
                    'isStopTimeUTC',    1,	...
                    'isStopTimeAuto',   1,	...
                    'stopTime',         []);



graph(1).streams = streams;
graph(1).time = time;


end

