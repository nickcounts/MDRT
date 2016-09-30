load('projectConfig.mat')


% path = '/Users/nick/Documents/MATLAB/Data Review/12-11-13/delim/';
% savePath = '/Users/nick/Documents/MATLAB/Data Review/12-11-13/data/';

path = delimPath;
savePath = dataPath;

delimFiles = dir([path '*.delim'])

filenameCellList = {delimFiles.name};
clear delimFiles

% TODO: Fix empty file bug

% iterate through delim files
for i = 1:length(filenameCellList)
    
    % Process first file on the list!
    filenameCellList(i)
    
    % Check data type
    % Valve (different from sensors)
    
    % PT - TC - FM - LS
    % For all analog measurement types (I think) we dump into a timeseries
    % Name the time series, add time as UTC ?
    fid = fopen([path filenameCellList{i}]);
    
    % Read data in one pass... Do i want to check it first?
    tstart = tic;
        Q = textscan(fid, '%s %s %s %s %s %s %s %s %s', 'Delimiter', ',');
    disp(sprintf('Reading file with textscan took %f seconds',toc(tstart)));
    
    % Close file after I do my stuff!
    fclose(fid);
    
    
    
    %   Assign important data to their own cell arrays for parsing
    %
    tic
        timeCell        = Q{1};
        shortNameCell   = Q{4};
        longNameCell    = Q{6};
        valueCell       = Q{8};
        valueTypeCell   = Q{5};
        unitCell        = Q(8);
    disp(sprintf('Assigning cell arrays took %f seconds',toc));
        
    
    % Optional Cleanup
    tic;
        clear Q;
    disp(sprintf('Clearing textscan result took %f seconds',toc));
    
    
    
    
    % Process time values
    tic
        timeVect = makeMatlabTimeVector(timeCell, false, false);
    disp(sprintf('Calling makeMatlabTimeVector took %f seconds',toc));
    
    tic
        clear timeCell
    disp(sprintf('Clearing timeCell result took %f seconds',toc));

    %   Grab important info about this data stream:
%    
%         info = 
% 
%                     ID: '5923'
%                   Type: 'TC'
%                 System: 'ECS'
%             FullString: 'ECS TC-5923 Temp Sensor  Mon'
    
    tic;
        info = getDataParams(shortNameCell{1});
    disp(sprintf('Calling getDataParams took %f seconds',toc));
    
    
    % Different handlings for different retrieval types
    switch upper(info.Type)
        
        % -----------------------------------------------------------------
        % Process Valve Data
        % -----------------------------------------------------------------
        
        case {'DCVNC','DCVNO','RV','BV','FV'}
            % Process as a valve retrieval...
            % TODO: Implement this! otherwise, I'm boned!!!!
            
            disp('Processing state only until further implementation');
            
            % Strip out the values that contain 'State' in the descriptor
            valveState = valueCell(~cellfun('isempty',strfind(shortNameCell, 'State')));
            info = getDataParams(shortNameCell{find(~cellfun('isempty',strfind(shortNameCell, 'State')),1,'first')});

            % Generate time series for state values            
            tic;
                ts = timeseries( str2double(valveState), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);
            disp(sprintf('Generating timeseries took %f seconds',toc));            

            fd = struct('ID', info.ID,...
                            'Type', info.Type,...
                            'System', info.System,...
                            'FullString', info.FullString,...
                            'ts', ts, ...
                            'isValve', true);
                        
            % write timeSeries to disk as efficient 'mat' format
            tic;
                save([savePath info.ID '.mat'],'fd','-mat')
            disp(sprintf('Writing data to disk took %f seconds',toc));

            disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
            
        case {'PCVNO','PCVNC'}
                
            % Process as a valve retrieval...
            
            disp('Processing state and percent open');
            
            % Strip out the values that contain 'State' in the descriptor
            valveState = valueCell(~cellfun('isempty',strfind(shortNameCell, 'State')));
            info = getDataParams(shortNameCell{find(~cellfun('isempty',strfind(shortNameCell, 'State')),1,'first')});
            
            valvePosition = valueCell(~cellfun('isempty',strfind(shortNameCell, 'Mon')));

            % Generate time series for state values            
            tic;
                tsState = timeseries( str2double(valveState), timeVect(~cellfun('isempty',strfind(shortNameCell, 'State'))), 'Name', info.FullString);
            disp(sprintf('Generating state timeseries took %f seconds',toc));
            
            % Generate time series for position values
            tic;
                tsPos = timeseries( str2double(valvePosition), timeVect(~cellfun('isempty',strfind(shortNameCell, 'Mon'))), 'Name', info.FullString);
            disp(sprintf('Generating position timeseries took %f seconds',toc));

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
                save([savePath info.ID '.mat'],'fd','-mat')
            disp(sprintf('Writing data to disk took %f seconds',toc));

            disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
            
        % -----------------------------------------------------------------
        % Process Flow Control Data
        % -----------------------------------------------------------------
        
        case {'RANGE','SETPOINT','SET POINT','BOUND','BOUNDS','BOUNDARY', 'LIMIT'}
             
            % Process data boundary sets
                        
            disp('Processing flow control set-points');
                   

            % Generate normal time series        
            tic;
                ts = timeseries( str2double(valueCell), timeVect, 'Name', info.FullString);
            disp(sprintf('Generating timeseries took %f seconds',toc));            

            fd = struct('ID', info.ID,...
                            'Type', info.Type,...
                            'System', info.System,...
                            'FullString', info.FullString,...
                            'ts', ts, ...
                            'isLimit', true);
                        
            % write timeSeries to disk as efficient 'mat' format
            tic;
                save([savePath info.System ' ' info.ID '.mat'],'fd','-mat')
            disp(sprintf('Writing data to disk took %f seconds',toc));

            disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));
            
        % -----------------------------------------------------------------
        % Process Standard FD Data
        % -----------------------------------------------------------------
        
        otherwise
            %   make timeseries for this data set:
            disp('Processing Standard FD Data')
    
            tic;
                ts = timeseries( str2double(valueCell), timeVect, 'Name', info.FullString);

        %   ts.Name = info.FullString;
            disp(sprintf('Generating timeseries took %f seconds',toc));

            tic;
                fd = struct('ID', info.ID,...
                            'Type', info.Type,...
                            'System', info.System,...
                            'FullString', info.FullString,...
                            'ts', ts,...
                            'isValve', false);

            disp(sprintf('Generating dataStream structure took %f seconds',toc));

            % write timeSeries to disk as efficient 'mat' format
            tic;
                save([savePath info.ID '.mat'],'fd','-mat')
            disp(sprintf('Writing data to disk took %f seconds',toc));

            disp(sprintf('Finished file %i of %i',i,length(filenameCellList)));

            disp(sprintf('Processing file took %f seconds',toc(tstart)));
    end
    
end

% clean up after yourself!!!
clear fid filenameCellList i longNameCell shortNameCell timeCell timeVect valueCell valueTypeCell info



