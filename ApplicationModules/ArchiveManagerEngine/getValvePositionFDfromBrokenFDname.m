function goodName = getValvePositionFDfromBrokenFDname(badName)
%% getValvePositionFDfromBrokenFDname(badName)
%
% getValvePositionFDfromBrokenFDname returns a string containing the UGFCS
% Valve Position FD when passed any FD string for the same valve.
%
% Example:
%
%   getValvePositionFDfromBrokenFDname('ECS PCVNC-5259 State')
% 
%   ans =
% 
%   ECS PCVNC-5259 Position Mon
%
% Returns a string
% Accepts a string or a cell array containing a single string.
% No functionality to accept a cell array of multiple strings at this time
%
% Counts, VCSFA 2017


%% List of valid FCS Valve position monitor FDs
% Update this list to update the function as FCS changes are made
% This list MUST contain UNIQUE strings.

        FCSPositionFDStrings = {
            'AIR RV-0003 Position  Mon';
            'AIR RV-0004 Position  Mon';
            'ECS PCVNC-5256 Globe Valve  Mon';
            'ECS PCVNC-5258 Globe Valve  Mon';
            'GAAS POS-103 Angular Position  Mon';
            'GAAS POS-104 Angular Position  Mon';
            'Ghe PCVNC-4168 Globe Valve  Mon';
            'LN2 PCVNC-3021 Globe Valve  Mon';
            'LN2 PCVNC-3055 Globe Valve  Mon';
            'LN2 PCVNC-3070 Globe Valve  Mon';
            'LN2 PCVNC-3086 Globe Valve  Mon';
            'LO2 PCVNC-2059 Globe Valve  Mon';
            'LO2 PCVNC-2069 Globe Valve  Mon';
            'LO2 PCVNC-2221 Globe Valve  Mon';
            'LO2 PCVNO-2013 Globe Valve  Mon';
            'LO2 PCVNO-2014 Globe Valve  Mon';
            'LO2 PCVNO-2029 Globe Valve  Mon';
            'LO2 PCVNO-2220 Globe Valve  Mon';
            'RP1 PCVNC-1014 Globe Valve  Mon';
            'RP1 PCVNC-1015 Globe Valve  Mon';
            'RP1 PCVNC-1049 Globe Valve  Mon';
            'WDS BV-0009 Valve Positioner  Mon';
            'WDS BV-0010 Valve Positioner  Mon';
            '__SIM LO2 PCVNO-2013 Globe Valve  Mon';
            '__SIM LO2 PCVNO-2014 Globe Valve  Mon';
            '__SIM RP1 PCVNC-1014 Globe Valve  Mon';
            '__SIM RP1 PCVNC-1015 Globe Valve  Mon';
        };



%% Input processing

% Unwrap cell input
if iscell(badName)
    badName = badName{1};
end


%% Make a search string for the find number using regular expresions
% Will yield a result of the form 'PCVNC-3055'

    searchString = regexp(badName, '[A-Za-z]*-[0-9]{4}','match');
    searchString = searchString{1};

% Find the index for a match. This is a nested mess, but I'm too lazy
matchingIndex = find(not(cellfun('isempty', ...
                                 strfind(FCSPositionFDStrings, ...
                                         searchString) ) ) );

%% Basic error checking - try to recover if no match is found

if matchingIndex
    
    debugout('Matched old FD string to known FCS FD')
    goodName = FCSPositionFDStrings{matchingIndex};
    
    debugout(goodName)
    
else
    
    debugout('No match found for FD. Appending "Position Mon" for clarity')
    
    % No error checking - if there's no 'State'
    % TODO: Check this so we don't break everything ever
    startReplaceIndex = strfind(badName, 'State') - 1;
    
    % Strip old 'State' stuff from name
    goodName = badName(1:startReplaceIndex);
    
    % Add the correct ' Mon' to the end
    goodName = strcat(goodName, ' Position Mon');
    
    debugout(sprintf('Renamed %s to %s', badName, goodName))

end