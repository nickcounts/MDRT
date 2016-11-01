function debugout( somethingToPrintToConsole )
%debugout will display console output for debugging purposes
%   looks for environment variable 'debugOutput' which is true or false
%
%   When called from within a function, debugout will display the name of
%   that function in bold, followed by the debugging content.
%
%   debugout produces output similar to that of disp - you can pass
%   code as an argument, and the evaluated output will be displayed.
%
%   Example:
%
%       >> debugmode(true)
%        debugmode: Debugging output is active
%
%       >> debugout('test debugging')
%       test debugging
%
%   Counts, VCSFA 2016

[st, ~] = dbstack;

if numel(st) > 1
    callingFunction = st(2).name;
    S = sprintf( '<strong> %s: </strong>', callingFunction);
    % Needed to fix a strange extra character from displaying after
    % <strong> text
%     reverseStr = repmat(sprintf('\b'), 1, 1);
    reverseStr = '';
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

