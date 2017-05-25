function fileName = makeFileNameForFD(fdStruct)
%% Generate data filename for an FD based on the fd.fullstring property
%
% makeFileNameForFD(fdStruct)
% makeFileNameForFD(FullString)
%
% function takes an fd structure, a timeseries object, or a string (char).
% There is no support for cell input at this time.
%
% Returns fileName (char) with a MDRT style data filename string. The .mat
% extension is not part of the fileName returned value. 
%
% makeFileNameforFD attempts to prepend the 4-5 digit MARS find number for
% ease of file location in directories.
%
% EXAMPLE:
%
% makeFileNameForFD('GN2 DCVNC-5056 State')
% 
% ans =
% 
% 5056 GN2 DCVNC-5056 State
%

% Counts, VCSFA 2017

%% Handle multiple input styles

    startingString = '';
    fileName = '';

    switch class(fdStruct)
        case 'struct'
            %% TODO - fix non-existant handle issue
            if ~isempty(fdStruct.ts.Name)
                % Prefer the full name of the timeseries for file
                % names.
                startingString = fdStruct.ts.Name;
            else
                startingString = fdStruct.FullString;
            end
            
        case 'timeseries'
            startingString = fdStruct.ts.Name;
            
        case 'char'
            startingString = fdStruct;
            
        otherwise
            return
    end

%% Tokenize the fullstring

    % fullStringTokens = regexp(info.FullString, '\w*','match');
    % keeps ABC-1234 together as one token
    fullStringTokens = regexp(startingString, '\S+','match'); 

    % If fullstring follows ABC-#####, then start filename with #####

    prependFindNumber = '';

    if max( logical( regexp( startingString, '\w-\d{4,5}' ) ))

        reQueryForFindNumber = '(?<=\w+-)(\d{4,5})';

        prependFindNumber = regexp( startingString, ... 
                                    reQueryForFindNumber, 'match' );

    end

    % Build filename, use entire FD Fullstring (do I want to exclude
    % certain terms in the future?)

    fileName = strjoin([prependFindNumber, fullStringTokens]);

end
