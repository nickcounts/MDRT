function debugout( somethingToPrintToConsole )
%debugout will display console output for debugging purposes
%   looks for environment variable 'debugOutput' which is true or false
%
%   Example:
%
%       setenv('debugOutput','true');
%
%       >> debugout('test debugging')
%       test
%
%   Counts, VCSFA 2016


switch getenv('debugOutput')
    case 'true'
        disp( somethingToPrintToConsole )
    otherwise
end

end

