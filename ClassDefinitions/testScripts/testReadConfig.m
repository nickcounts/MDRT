function testReadConfig

    commentSymbol = '#';
    
    configuration = struct;
    
    fid = getMDRTConfigFile;

    % fid = fopen('config.txt');

    % Read all lines, ignoring comments
    % ---------------------------------------------------------------------
    Q = textscan(fid, '%s', 'Delimiter', '\n');

    fclose(fid);

    % Reshape data so it's a columnar cell array
    % ---------------------------------------------------------------------
    Q = Q{1};

    validConfigStrings = { ...
            'graphConfigFolderPath';
            'dataArchivePath';
            'userSavePath';
            'userWorkingPath'};
        
	% Build important structures with empty fields
    % ---------------------------------------------------------------------
    for i = 1:numel(validConfigStrings)
        
        configuration = setfield(configuration, validConfigStrings{i}, '');
        
        configuration.(validConfigStrings{i}).index = [];
        configuration.(validConfigStrings{i}).key = '';
        configuration.(validConfigStrings{i}).value = '';
        
    end

        


    % Read each line and parse it out
    % ---------------------------------------------------------------------
    for i = 1:numel(Q)

        % Exclude all comments
        if ~strcmp(regexp(Q{i},'\W', 'match'), commentSymbol)
            Q{i}

            stuffInQuotes = regexp(Q{i}, '(?<=")[^"]+(?=")', 'match')

            keyName = regexp( Q{i}, '\w+(?==)', 'match')

            readParameter(keyName{1}, stuffInQuotes, i)

            
        end
    end
    
    keyboard
    
    % ---------------------------------------------------------------------
    % ---------------------------------------------------------------------
    % -----
    % -----                     END OF FUNCTION
    % -----
    % ---------------------------------------------------------------------
    % ---------------------------------------------------------------------


function readParameter( name, value, index )

    [isValid, keyNameStr] = isValidParameter(name);
    
    if isValid
        
        % Right now, these are all paths... in the future, maybe other
        % settings will be included. This will have to be moved into each
        % case statement
        
        newValue = cleanPath( value );

        configuration.keyNameStr.index = index;
        configuration.keyNameStr.key = name;
        configuration.keyNameStr.value = newValue;

    end
end

function pathStr = cleanPath( pathStr )
%cleanPath ( pathStr )
%
% Returns a path to an existant directory.
% Malformed or nonexistant directories return an empty string


    if ~isempty( pathStr )
        
        % Un-cell the variable
        % -----------------------------------------------------------------
        while iscell( pathStr )
            pathStr = pathStr{1};
        end
        
        if ~exist(pathStr, 'dir')
            % Path contained an ivalid, non-existant directory
            % return an empty string as a fail state
            pathStr = '';
            return
        else
            % The directory exists - use the passed string
        end
            
        
    else
        % Gave us an empty string, return an empty string as a fail state
        pathStr = '';
        return
    end
end


function [isValid, fixedKeyName] = isValidParameter( keyName )

    matchIndex = cellfun(@(x)( ~isempty(x) ), regexpi(keyName, validConfigStrings) );
    
    fixedKeyName = validConfigStrings{matchIndex};
    
    if isempty(fixedKeyName)
        isValid = false;
    else
        isValid = true;
    end
        
end
    
    
    
    
end

