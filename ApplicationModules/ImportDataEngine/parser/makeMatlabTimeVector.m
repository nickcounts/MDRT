function [ matlabTimeVector ] = makeMatlabTimeVector( timeCellArray , convertUTC2Local, isDST)
%% makeMatlabTimeVector returns a vector of Matlab dates for plotting
%
%       convertUTC2Local and isDST are boolean - use true or false as
%       parameters.
%
% N. Counts - Spaceport Support Services. 2013
%

%% Timestamp Parsing
%
%   Quick parse time data into a matrix

%   Turn cell array of chars into colums of values
    a = textscan(sprintf('%s\n',timeCellArray{:}),'%f/%f/%f:%f:%f');

%   timeMat is of the form [year day hour minute second]
    timeMat = [a{:}];

%   generate a Matlab-style date (without time) by addition
%   extract yyyy mm dd
%   assemble Matlab date using datenum
    rawDate = datenum(timeMat(:,1),1,1) + timeMat(:,2) - 1;
    rawDateN = datevec(rawDate);

        yearM   = rawDateN(:,1)
        monthM  = rawDateN(:,2)
        dayM    = rawDateN(:,3)

%   TIME VARIABLE: time is a matlab-style time value (double)
    matlabTimeVector = datenum(yearM,monthM,dayM,timeMat(:,3),timeMat(:,4),timeMat(:,5));
    
    if convertUTC2Local
        disp('Convert flag is TRUE')
        timeAdjust = - 5; %hours
        if isDST
            timeAdjust + 1;
        end
        matlabTimeVector = matlabTimeVector + (timeAdjust/24);
    end


end

