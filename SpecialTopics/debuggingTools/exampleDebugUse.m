function exampleDebugUse
%exampleDebugUse
%
% To see the output, turn on debug messages by using debugmode(true)
% To supress output, turn off debug messages by using debugmode(false)

%   Examples of debugout used inside a function

    % Debug messages:
    debugout('function started executing')

    % variable contents:
    a = magic(3);
    
    debugout(a)
    
    % Calling functions:
    debugout('Calling mySubroutine')
    
    mySubroutine

end

function mySubroutine

    % Inside a subroutine
    debugout('Message from inside a subroutine')

end
