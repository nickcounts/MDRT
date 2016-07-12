function [ timeline ] = newTimelineStructure( varargin )
%newGraphStructure returns a graph structure with default fields
%   newGraphStructure
%
%   newGraphStructure('GraphName')
%
%   VCSFA 2016

%% Handle passed arguments

switch nargin
    case 1
        % Anything worth passing to this function?

    otherwise
        % Use default structure

end

%% ------------------------------------------------------------------------
%                       The timeline event structure
% -------------------------------------------------------------------------
%
% timeline = 
% -------------------------------------------------------------------------
%               t0: [1x1 struct]
%     notPlottable: 1
%        milestone: [1x26 struct]
%            uset0: 1
%
% timeline.t0
% -------------------------------------------------------------------------
%             name: 'T0'
%             time: 735793.702939852
%              utc: 1
%
%
% timeline.milestone(1)
% -------------------------------------------------------------------------
%             String: 'PHS Warm He Charging'
%                 FD: 'GHe-W Charge Cmd'
%               Time: 735793.431111111


%% ------------------------------------------------------------------------
%                       Instantiate the default struct
% -------------------------------------------------------------------------


% Instantiate a default milestone struct
% -------------------------------------------------------------------------
    milestone = struct(     'String',       'Event: Human Readable', ...
                            'FD',           'FD Retriever String', ...
                            'Time',         now);
                        
% Instantiate a default t0 struct
% -------------------------------------------------------------------------
    t0 = struct(            'name',         'T0', ...
                            'time',         now, ...
                            'utc',          true);
                        
% Instantiate a default timeline struct
% -------------------------------------------------------------------------
    timeline = struct(      't0',           t0, ...
                            'notPlottable', true, ...
                            'milestone',    milestone, ...
                            'uset0',        false);
                           


end

