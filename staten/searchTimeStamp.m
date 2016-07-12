function searchtimestamp = datareturn( timestamp )
%% one way to search through dataIndexForSearching (by timespan)


% datareturn loops through existing data and returns only the meta data
% structures (containing the fds) existing over the given timestamp array

% timestamp = array of either 1 or 2 local time/date values


% call localToUTC function to convert local time/date information to UTC

numtimestamp = localtoUTC(timestamp);

% check length of array
% case 1: iterate over single 24 hour time period
% case 2: iterate over duration of time period

timelength = length(timestamp);

    switch length(numtimestamp)
        case 1
            for duration(numtimestamp)
                return newMetaDataStructure(duration(numtimestamp))
        case 2
            for i = numtimestamp(1):numtimestamp(2)
                return newMetaDataStructure(i)
                    
    end
	
%% above is good for a single instance, but need this to look at dataIndexForSearching, which will return a file in data archive folder to be searched

