function [ output_args ] = processDelimFiles( config )
%% processDelimFiles - 
%
%   processDelimFiles parses .delim files containing a single FD (for
%   valves, all associated FDs can be included in one FD. e.g. Cmd, State,
%   Closed, Open, Position, etc.).
%
%   processDelimFiles sequentially parses each .delim file in the path
%   passed in the config argument as described below. Debugging status
%   reports are printed to the Matlab command window during execution to
%   help the user find problem spots in data files.
%
%   config is a structure variable passed to the function that specifies
%   the location of the .delim files to be processed and the desired
%   storage location for processed .mat files.
%
%   Variable    : config
%   Type        : Struct
%
%   Fields:
%
%           delimFolderPath: string (absolute path with trailing /)
%            dataFolderPath: string (absolute path with trailing /)
%            plotFolderPath: string (absolute path with trailing /)
%
%   NOTE: This has been extended to work on non-*nix operating systems.
%
% N. Counts - Spaceport Support Services. 2013
%

% path = '/Users/nick/Documents/MATLAB/Data Review/12-11-13/delim/';
% savePath = '/Users/nick/Documents/MATLAB/Data Review/12-11-13/data/';

% TODO: Fix this ugly parameter passing!!! GROSS


if isa(config, 'MDRTConfig')
    
    path = config.workingDelimPath;
    savePath = config.workingDataPath;
else
    path = config.delimFolderPath;
    savePath = config.dataFolderPath;
end



delimFiles = dir(fullfile(path, '*.delim'));
filenameCellList = {delimFiles.name};



% Instantiate a progress bar!
progressbar('Processing .delim Files','Parsing File')

% ----------------------------------------------------
% Calculate bytes to process
% ----------------------------------------------------
totalBytes = 0;
bytesProcessed = 0;
for i = 1:length(delimFiles)
    totalBytes = totalBytes + delimFiles(i).bytes;
end

%% iterate through delim files
for i = 1:length(filenameCellList)
    
    skipThisFile = false;
    
    % UI Progress Update
    % ------------------
    frac = 0/5;
    progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac);
    
    
    % Process first file on the list!
    filenameCellList(i)
    
    % Check that file is NOT EMPTY
    if delimFiles(i).bytes ~= 0
        
        % Confirmed that file is not literally empty
        % No checking of contents or form. Errors in file may still crash
        % this routine
        
        % TODO: Add additional error catching for textscan
    
    
        % Check data type
        % Valve (different from sensors)

        % PT - TC - FM - LS
        % For all analog measurement types (I think) we dump into a 
        % timeseries
        
        % Name the time series, add time as UTC ?
        
        %% ----------------------------------------------------------------
        % Open ith File for Parsing
        % -----------------------------------------------------------------
        
        tic;
%         fid = fopen([path filenameCellList{i}]); % ### Commented for
%         cross platform compatability
        
        fid = fopen( fullfile(path, filenameCellList{i}) );
        disp(sprintf('Opening file %s took: %f seconds',filenameCellList{i},toc));
        
        % UI Progress Update
        % ------------------
        frac = 1/5;
        progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac);

        % Read data in one pass... Do i want to check it first?
        tstart = tic;

            % TODO: Assign columns directly to individual varaibles
           
            % -----------------------------------------------------
            % Commented out original textscan that read the entire 
            % structure. Hopefully we save time!            
            % -----------------------------------------------------
            % Q = textscan(fid, '%s %s %s %s %s %s %s %s %s', 'Delimiter', ',');
            %                     1  2  3  4  5  6  7  8  9

            Q = textscan(fid, '%s %*s %*s %s %s %s %*s %s %s', 'Delimiter', ',');
            
        
        
        % UI Progress Update
        % ------------------
        frac = 2/5;
        progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac);
        disp(sprintf('Reading file with textscan took: %f seconds',toc(tstart)));
        
        % Close file after I do my stuff!
        fclose(fid);


        % -----------------------------------------------------------------
        %   Assign important data to their own cell arrays for parsing
        % -----------------------------------------------------------------
        
        tic
        
            % timeCell        = Q{1};
            % shortNameCell   = Q{4};
            % valueTypeCell   = Q{5};
            % longNameCell    = Q{6};
            % valueCell       = Q{8};
            % unitCell        = Q(9);
            
            % We do not use 2 3 7

            timeCell        = Q{1};
            shortNameCell   = Q{2};
            valueTypeCell   = Q{3};
            longNameCell    = Q{4};
            valueCell       = Q{5};
            unitCell        = Q{6};

        
        % UI Progress Update
        % ------------------
        frac = 3/5;
        progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac); 
        disp(sprintf('Assigning cell arrays took: %f seconds',toc));
        
        
        
        % Optional Cleanup
        tic;
            clear Q;
        disp(sprintf('Clearing textscan result took: %f seconds',toc));




        % Process time values
        tic
            timeVect = makeMatlabTimeVector(timeCell, false, false);
        disp(sprintf('Calling makeMatlabTimeVector took: %f seconds',toc));
        
        % UI Progress Update
        % ------------------
        frac = 4/5;
        progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac);

        tic
            clear timeCell
        disp(sprintf('Clearing timeCell result took: %f seconds',toc));

        %   ---------------------------------------------------------------
        %   Grab Important Info About this Data Stream:
        %   --------------------------------------------------------------- 
        %         info = 
        % 
        %                     ID: '5923'
        %                   Type: 'TC'
        %                 System: 'ECS'
        %             FullString: 'ECS TC-5923 Temp Sensor  Mon'

        tic;
            info = getDataParams(shortNameCell{1});
        disp(sprintf('Calling getDataParams took: %f seconds',toc));


        % Different handlings for different retrieval types
        switch upper(info.Type)

            % -----------------------------------------------------------------
            % Process Valve Data
            % -----------------------------------------------------------------

            case {'DCVNC','DCVNO','RV','BV','FV'}
                %% --------------------------------------------------------
                % Process as a Discrete Valve Retrieval
                % ---------------------------------------------------------
                
                %  TODO: Discrete Valve Retrieval parsing - add more than just "state" variable parsing and fold into FD timeseries structure. 

                    
                try
                    
                    disp('Processing state only until further implementation');

                    % Strip out the values that contain 'State' in the descriptor

                    if strcmp(info.Type, 'BV') && ( strcmp(info.ID, '0009') || strcmp(info.ID, '0010'))
                        % Special Exception for WDS proportional valves
                        valvePosition = valueCell(~cellfun('isempty',strfind(shortNameCell, 'Mon')));
                    else
                        valveState = valueCell(~cellfun('isempty',strfind(shortNameCell, 'State')));
                    end



                    if strcmp(info.Type, 'BV') && ( strcmp(info.ID, '0009') || strcmp(info.ID, '0010'))
                        % Special Exception for WDS proportional valves
                        info = getDataParams(shortNameCell{find(~cellfun('isempty',strfind(shortNameCell, 'Mon')),1,'first')});
                    else
                        info = getDataParams(shortNameCell{find(~cellfun('isempty',strfind(shortNameCell, 'State')),1,'first')});
                    end    



                    % Generate time series for state values            
                    tic;

                        % ts = timeseries( sscanf(sprintf('%s', valveState{:,1}),'%f'), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);


                    if strcmp(info.Type, 'BV') && ( strcmp(info.ID, '0009') || strcmp(info.ID, '0010'))
                        % Special Exception for WDS proportional valves
                        ts = timeseries( str2double(valvePosition), timeVect(~cellfun('isempty',strfind(shortNameCell, 'Mon'))), 'Name', info.FullString);
                    else
                        ts = timeseries( str2double(valveState), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);
                    end

                    disp(sprintf('Generating timeseries took: %f seconds',toc));            


                    fd = struct('ID', info.ID,...
                                    'Type', info.Type,...
                                    'System', info.System,...
                                    'FullString', info.FullString,...
                                    'ts', ts, ...
                                    'isValve', true);

                    % write timeSeries to disk as efficient 'mat' format
                    tic;
    %                     save([savePath info.ID '.mat'],'fd','-mat')
                        saveFDtoDisk(fd)
                    disp(sprintf('Writing data to disk took: %f seconds',toc));

                    disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
                    
                catch ME

                    handleParseFailure(ME)

                end

            case {'PCVNO','PCVNC'}
                %% --------------------------------------------------------
                % Process as a Proportional Valve Retrieval
                % ---------------------------------------------------------
                
                disp('Processing state and percent open');
                
                try
                
                    % Strip out the values that contain 'State' in the descriptor
                    valveState = valueCell(~cellfun('isempty',strfind(shortNameCell, 'State')));
                    if ~isempty(valveState)
                        info = getDataParams(shortNameCell{find(~cellfun('isempty',strfind(shortNameCell, 'State')),1,'first')});
                    else
                        disp('NOTE: Valve state not found. No state data added to structure');
                    end

                    valvePosition = valueCell(~cellfun('isempty',strfind(shortNameCell, 'Mon')));

                    % Generate time series for state values            
                    tic;

                        tsState = timeseries( sscanf(sprintf('%s ', valveState{:,1}),'%f'), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);
                        % tsState = timeseries( str2double(valveState), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);
                    disp(sprintf('Generating state timeseries took: %f seconds',toc));

                    % Generate time series for position values



                    tic;
                        tsPos = timeseries( sscanf(sprintf('%s ', valvePosition{:,1}),'%f'), timeVect(~cellfun('isempty',strfind(shortNameCell, 'Mon'))), 'Name', info.FullString);
                        % tsPos = timeseries( str2double(valvePosition), timeVect(~cellfun('isempty',strfind(shortNameCell, 'Mon'))), 'Name', info.FullString);
                    disp(sprintf('Generating position timeseries took: %f seconds',toc));

                    fd = struct('ID', info.ID,...
                                    'Type', info.Type,...
                                    'System', info.System,...
                                    'FullString', info.FullString,...
                                    'ts', tsState, ...
                                    'isValve', true, ...
                                    'isProportional', true, ...
                                    'position', tsPos);

                    % write timeSeries to disk as efficient 'mat' format
                    tic;
    %                     save([savePath info.ID '.mat'],'fd','-mat')
                        saveFDtoDisk(fd)

                    disp(sprintf('Writing data to disk took: %f seconds',toc));

                    disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
                    
                catch ME

                    handleParseFailure(ME)

                end



            case {'RANGE','SETPOINT','SET POINT','BOUND','BOUNDS','BOUNDARY','LIMIT','HTR'}
                %% --------------------------------------------------------
                % Process Flow Control Data
                % ---------------------------------------------------------
                
                % Process data boundary sets
                
                try

                    disp('Processing flow control set-points');


                    % Generate normal time series        
                    tic;
                        % ts = timeseries( sscanf(sprintf('%s', valueCell{:,1}),'%f'), timeVect, 'Name', info.FullString);
                        ts = timeseries( str2double(valueCell), timeVect, 'Name', info.FullString);
                    disp(sprintf('Generating timeseries took: %f seconds',toc));            

                    fd = struct('ID',           info.ID,...
                                'Type',         info.Type,...
                                'System',       info.System,...
                                'FullString',   info.FullString,...
                                'ts',           ts, ...
                                'isLimit',      true);

                    % write timeSeries to disk as efficient 'mat' format
                    tic;
    %                     if isequal(info.Type, 'Set Point')
    %                         % Save happy file name
    %                         save([savePath info.ID '.mat'],'fd','-mat')
    %                     else
    %                         save([savePath info.System ' ' info.ID '.mat'],'fd','-mat')
    %                     end

                            saveFDtoDisk(fd)

                    disp(sprintf('Writing data to disk took: %f seconds',toc));

                    disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
  
                catch (ME)

                    handleParseFailure(ME)

                end
                
  

            otherwise
                %% --------------------------------------------------------
                % Process Standard FD Data
                % ---------------------------------------------------------
                
                %   make timeseries for this data set:
                disp('Processing Standard FD Data')
                
                
                
                tic;
%                     N = sscanf(sprintf('%s', valueCell{:,1}),'%f');

                    switch valueTypeCell{1}
                        case 'D'
                            % Process as discrete to fix integer conversion
                            % use cellfun isempty with regex to find all
                            % values that do not contain 0. These should
                            % all be true.
                            ts = timeseries( cellfun(@isempty,regexp(valueCell,'^0')), timeVect, 'Name', info.FullString);
                            
                            disp('Discrete data type detected')
                                                        
                        otherwise
                            % Process with optimized floating point
                            % conversion for maximum speed
                            % Remember the space after %s to prevent
                            % concatenating all values from array into one
                            % long string!!!
                            
                            
                            try
                                ts = timeseries( sscanf(sprintf('%s ', valueCell{:,1}),'%f'), timeVect, 'Name', info.FullString);
                            catch ME
                                
                                handleParseFailure(ME)
                                    
                            end
                            
                            % This is the old way and it was REALLY REALLY slow
                            % ts = timeseries( str2double(valueCell), timeVect, 'Name', info.FullString);
                    end
                    
                    
                    
                    
                    
                if skipThisFile
                    disp('SKIPPING THIS FILE');
                    disp(sprintf('Total time spent on this file was: %f seconds',toc(tstart)));
                    
                else

                    %   ts.Name = info.FullString;
                    disp(sprintf('Generating timeseries took: %f seconds',toc));

                    tic;
                        fd = struct('ID', info.ID,...
                                    'Type', info.Type,...
                                    'System', info.System,...
                                    'FullString', info.FullString,...
                                    'ts', ts,...
                                    'isValve', false);

                    disp(sprintf('Generating dataStream structure took: %f seconds',toc));


                    % write timeSeries to disk as efficient 'mat' format
                    tic;
                        saveFDtoDisk(fd)
                    disp(sprintf('Writing data to disk took: %f seconds',toc));



                    disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
                    disp(sprintf('Processing file took: %f seconds',toc(tstart)));
                
                end
        end

    % End of actual processing loop
    else
        % File is literally empty
        disp(sprintf('File %s is empty and will not be processed.',filenameCellList{i}));
    end

    
    % UI Progress Update
    % ------------------
    frac = 5/5;
    progressbar( (bytesProcessed + delimFiles(i).bytes * frac) / totalBytes, frac);
    %update bytesProcessed for next file progress bar
    bytesProcessed = bytesProcessed + delimFiles(i).bytes;
    
end
progressbar(1,1)

% clean up after yourself!!!
clear fid filenameCellList i longNameCell shortNameCell timeCell timeVect valueCell valueTypeCell info delimFiles



%% Helper Functions for processDelimFiles
%
%       These functions are called by the parsing routine to perform
%       common tasks


    function saveFDtoDisk(fd)
        % This helper function writes the newly parsed FD to disk, after
        % first checking the structure against a list of special cases and
        % updating the FD fields and filename.
        
%% Old Code to hanle file naming
        % Start with default filename
%         fileName = info.ID;
        
        % Adjust file names for special cases for set-point types
            
%         if ismember(upper(info.Type), {'RANGE','SETPOINT','SET POINT','BOUND','BOUNDS','BOUNDARY','LIMIT','HTR'})
%             if isequal(info.Type, 'Set Point')
%                 % default filename is fine
%                 fileName = info.ID;
%             else
%                 % modify fileName for typical FDs
%                 fileName = [info.System ' ' info.ID];
%             end
%         end
        
        
%% New code to fix overloaded FD file names

        fileName = makeFileNameForFD(info);
        
        % Check fullstring against override list
        
        % TODO: Implement error checking for custom FD list file and handle it if this file doesn't exist.
        load('processDelimFiles.cfg','-mat');

        if ismember(fd.FullString,customFDnames(:,1))
            
            % If match is found, update structure
            n = find(strcmp(customFDnames(:,1),fd.FullString));
            
            fd.System       = customFDnames{n,2};
            fd.ID           = customFDnames{n,3};
            fd.Type         = customFDnames{n,4};
            fd.FullString   = customFDnames{n,5};
            
            % If match is found, update filename
            fileName = customFDnames{n,6};
            
        else
            % Don't update anything!
        end
        
        save(fullfile(savePath ,[fileName '.mat']),'fd','-mat')
        
    end


    function fileName = makeFileNameForFD(FDinfo)
        %% Pseudo code for filename generator
        
        % Tokenize the fullstring
        
        % fullStringTokens = regexp(info.FullString, '\w*','match');
        fullStringTokens = regexp(FDinfo.FullString, '\S+','match'); % keeps ABC-1234 together as one token
        
        % If fullstring follows ABC-#####, then start filename with #####
        
            prependFindNumber = '';
        
            if max( logical( regexp( FDinfo.FullString, '\w-\d{4,5}' ) ))
                
                reQueryForFindNumber = '(?<=\w+-)(\d{4,5})';
                
                prependFindNumber = regexp( FDinfo.FullString, reQueryForFindNumber, 'match' );
                
            end
            
        
        % Build filename, use entire FD Fullstring (do I want to exclude
        % certain terms in the future?)
        
            fileName = strjoin([prependFindNumber, fullStringTokens]);
        
    end


    function showDataSampleWindow
        
        dbugWindow = figure('Position',[100 100 400 150], ...
                            'MenuBar',          'none', ...
                            'NumberTitle',      'off', ...
                            'Name', 'Sample Data from Failed Parse');

        % Column names and column format
        % ------------------------------------------------------------------------
        % columnname = {'Short Name', 'Long Name', 'Type','Value','TimeStamp'};
        columnname = {'Short Name', 'Long Name', 'Type','Value','Units'};

        % columnformat = {'numeric','bank','logical',{'Fixed' 'Adjustable'}};

        % Define the data
        % ------------------------------------------------------------------------
        % d = horzcat(valueTypeCell(1:20), valueCell(1:20), timeVect(1:20) );
        % d = [shortNameCell(1:20), longNameCell(1:20), valueTypeCell(1:20), valueCell(1:20), num2cell(timeVect(1:20))];
        d = [shortNameCell(1:20), longNameCell(1:20), valueTypeCell(1:20), valueCell(1:20), unitCell(1:20)];

        % Create the uitable
        % ------------------------------------------------------------------------
        t = uitable(dbugWindow, 'Data', d, ...
                    'ColumnName', columnname );

        % Set width and height
        % ------------------------------------------------------------------------
        t.Position(3) = t.Extent(3);
        t.Position(4) = t.Extent(4);    

        dbugWindow.Position(3) = t.Extent(3) + 40;
        dbugWindow.Position(4) = t.Extent(4) + 25; 
        
    end



    function handleParseFailure(ME)
        
        disp('There was a problem generating a timeseries from these data');
                                
                                % Open a window with some of the data
                                showDataSampleWindow
                                
                                % Pause execution for now
                                
                                skipButton = 'Skip This File';
                                haltButton = 'Halt';
                                
                                ButtonName = questdlg('There was an error parsing this data file. How do you want to proceed?', ...
                                                    'MARS DRT Data Parse Error', ...
                                                    skipButton, haltButton, haltButton);
                                                
                                switch ButtonName
                                    case skipButton
                                        disp('User selected SKIP');
                                        skipThisFile = true;
                                        
                                        
                                    case haltButton
                                        
                                        disp('User selected HALT');
                                        
                                        % Add the offending variables to
                                        % the main workspace to allow power
                                        % users to debug - only if not
                                        % deployed!
                                        if ~isdeployed
                                            disp('Copying data to main workspace for debugging');
                                                                                        
                                            assignin('base' , 'parseValue', valueCell );
                                            assignin('base' , 'parseTime',  timeVect  );
                                            assignin('base' , 'parseUnits', unitCell );
                                            assignin('base' , 'parseShort', shortNameCell );
                                            assignin('base' , 'parseLong',  longNameCell );
                                            
                                        end
                                        
                                        
                                        % Rethrow the exception and exit
                                        error('Parsing data file failed');
%                                         rethrow(ME)

                                        
                                    otherwise
                                        % Assume user did something weird
                                        % Rethrow the exception and exit
                                        rethrow(ME)
                                end
        

        
    end




end