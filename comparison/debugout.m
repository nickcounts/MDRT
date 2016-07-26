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

[st, ~] = dbstack;

if numel(st) > 1
    callingFunction = st(2).name;
    S = fprintf( '<strong> %s: </strong>', callingFunction);
    % Needed to fix a strange extra character from displaying after
    % <strong> text
    reverseStr = repmat(sprintf('\b'), 1, 1);
else
    S = '';
    reverseStr = '';
end
        

switch getenv('debugOutput')
    case 'true'

        % disp( somethingToPrintToConsole )
        DB = evalc('disp(somethingToPrintToConsole)');
        fprintf([S, reverseStr, DB]);
        % fprintf('%s%s',S, DB);

    otherwise
end

end

