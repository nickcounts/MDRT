function [ value ] = getValueAtTime( ts, time, varargin )
%getValueAtTime Summary of this function goes here
%   Detailed explanation goes here

% Define Default behavior variables

behavior = 'mid';

% Define constants

day = 1;
hour = day/24;
minute = day/(24*60);
second = day/(24*60*60);

switch nargin
    case 0
        % no arguments passed, assume default behavior
    case 1
        % argument passed. Check form and modify behavior
        if isstr(varargin{1})
            if isequal(lower(varargin{1}, 'last'))
                behavior = 'last';
            elseif isequal(lower(varargin{1}, 'next'))
                behavior = 'next';
            elseif isequal(lower(varargin{1}, 'interp'))
                behavior = 'interpolate';
            elseif isequal(lower(varargin{1}, 'mid'))
                behavior = 'midpoint';
            end
        end
end



index = findClosestTimeIndex(ts.Time, time);

next = index +1;
last = index -1;

keyboard


        

end

