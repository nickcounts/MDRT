function updateDataFileNamesInDirectory(pathToData)
%% updateDataFileNamesInDirectory
% updateDataFileNamesInDirectory()
% updateDataFileNamesInDirectory(pathToData)
%
% If no path is supplied, prompts user for directory, backs up all data 
% files, renames using the 'makeFileNameForFD' function. Places problem 
% data files in an 'error' directory for visibility.
%
% This function also converts old-style valve data files from combined
% position and status to separate data files for State and Position Mon
%
% pathToData is a full system path string to the directory where the data
% files are (normally called 'data') and not the higher level folder,
% typically named by the data and description.


% Find all data files in directory

%% Allow calling as a standalone or with a path;
if nargin == 0
    rootDir_path = uigetdir;
    if rootDir_path == 0
        % User pressed cancel
        return
    end
else
    if exist(pathToData, 'dir')
        rootDir_path = pathToData;
    else
        error('input argument is not a valid directory');
    end
end

debugout('Processing data files in the folder:')
debugout(rootDir_path)
    
directoryList = dir(rootDir_path);

originalFiles = {directoryList(~[directoryList.isdir]).name}';

% remove items beginning with "."
originalFiles(~cellfun(@isempty, regexpi(originalFiles, '^\.'))) = [];

% ignore special files: metadata.mat timeline.mat AvailableFDs.mat
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'metadata.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'timeline.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'AvailableFDs.mat'))) = [];

% AvailableFDs

%% Make temporary directories

tempDir_path   = fullfile(rootDir_path, 'temp');
backupDir_path = fullfile(rootDir_path, 'backup');
issuesDir_path = fullfile(rootDir_path, 'issues');
errorDir_path  = fullfile(rootDir_path, 'error');

mkdir(tempDir_path);
mkdir(backupDir_path);
mkdir(issuesDir_path);
mkdir(errorDir_path);

debugout('Created subdirectories for safe processing')

% Prepare UI Progress Indicator
numberOfFiles = numel(originalFiles);
totalLoops = numberOfFiles * 3;

progressbar('Data Directory Update - Overall', ...
            'Backing up data directory', ...
            'Preparing data directorty', ...
            'Updating Data File Names');

%% Copy entire rootPath into backupDir

debugout('Backing up original data files')

for i = 1:numberOfFiles
    copyfile(fullfile(rootDir_path, originalFiles{i}), backupDir_path);
    totalFrac = i/totalLoops;
    progressbar(totalFrac, i/numberOfFiles, [], []);
end

%% Move entire rootPath into tempDir (the working directory)

debugout('Moving data files to working directory')

for i = 1:numberOfFiles
    movefile(fullfile(rootDir_path, originalFiles{i}), tempDir_path);
    totalFrac = (numberOfFiles + i)/totalLoops;
    progressbar(totalFrac, [], i/numberOfFiles, []);
end

%% Open each file, and build a new name based on fd.FullString

debugout('Looping through each data file')

for i = 1:numberOfFiles
    
    % Select a file on which to operate:
    thisFullFile = fullfile(tempDir_path, originalFiles{i});
    
    debugout(sprintf('Processing file %s', thisFullFile))

    % Error handling for non-existant variables. Must be a better way to do
    % this, but it seems expedient and is relatively fast.
    try
        loadedVar = load(thisFullFile, '-mat', 'fd');
                        
        % Does the file have an FD structure?
        if isfield(loadedVar, 'fd')
            
            debugout('Found fd variable')
            
            % Handle old combined valve data
            wasProcessedAsValve = fixOldValveFile();
            
            % Make the new filename
            newFileName_str = makeFileNameForFD(loadedVar.fd);
            
            renamedFullFile = fullfile(rootDir_path, strcat(newFileName_str, '.mat') );
            
            % Check for Filename Collisions
            if ~exist(renamedFullFile, 'file') && ~wasProcessedAsValve

                % rename the file in place
                [status, ~, ~] = movefile(thisFullFile, renamedFullFile);
                
                % Someday I will check this status and do something smart
                
            elseif wasProcessedAsValve
                % Nohing to do, just catching the condition where
                % everything worked and we skipped the file moving dance
                % becasue we already sorted it out in the valve function
            else
                % There was a collison
                
                % put the offending file in issues directory and leave
                % the original alone. Move on
                copyfile(thisFullFile, issuesDir_path);
                
            end
            
        else
            % Doesn't contain fd structure
            % Do nothing to ignore?
            
            debugout('No fd variable found')
            
        end
            
    catch ME
        % Assume unable to load variable 'fd'
        % Could have been errors in file handling.
        % Copy file to error directory for visibility
        copyfile(thisFullFile, errorDir_path);
        
        debugout('error in processing data file:');
        debugout(ME)
    end
    
    totalFrac = ( (2*numberOfFiles) + i)/totalLoops;
    progressbar(totalFrac, [], [], i/numberOfFiles);
    
    
    

    
end




%% Sub Functions:
% -------------------------------------------------------------------------

    function isValve = fixOldValveFile
    % fixOldValveFile makes a temporary fd struct, moves the proportional
    % data into the normal 'ts' field, clears all old-system fields that
    % refer to 'isProportional' and 'position', saves the file, and then
    % updates the original FD to remove the proportional data so it can be
    % processed as a normal FD variable.

    %     fd = 
    % 
    %                 ID: '3055'
    %               Type: 'PCVNC'
    %             System: 'LN2'
    %         FullString: 'LN2 PCVNC-3055 State'
    %                 ts: [1x1 timeseries]
    %            isValve: 1
    %     isProportional: 1
    %           position: [1x1 timeseries]
    
    isValve = false;
    
    debugout('Checking for legacy valve data...')

    fd = loadedVar.fd;
    
    debugout('Assigning temporary fd variable')
    debugout(fd)
    
    if isfield(fd, 'position')
        
        debugout('Found a position timeseries')
        debugout(fd)
        
        % Set ouput for file skipping in calling function
        isValve = false;
        
        % Move the positioner data to the ts field
        fd.ts = fd.position;
        
        % Remove legacy fields from FD struct
        fd = rmfield(fd, 'isProportional');
        fd = rmfield(fd, 'position');
        
        % Should we remove the isValve tag? Not right now
        % fd = rmfield(fd, 'isValve');
        
        % Need to fix FullString in case the old parser broke it
        debugout(sprintf('Updating position data file name for %s', fd.ts.Name))
        
        fd.ts.Name = getValvePositionFDfromBrokenFDname(fd.ts.Name);
        
        % Update fullstring from the new ts
        fd.FullString = fd.ts.Name;
        
        debugout('Created new FD for valve position data')
        debugout(fd)
        
        % Save updated data
        % -----------------------------------------------------------------
        
            % Make the new filename
            newFileName_str = makeFileNameForFD(fd);

            renamedFullFile = fullfile(rootDir_path, ...
                                       strcat(newFileName_str, '.mat') );

            saveDataFile(renamedFullFile, newFileName_str, fd);
            
            
        % Update the original FD to remove the proportional data so it can 
        % be processed as a normal FD variable
        % -----------------------------------------------------------------
        
        debugout('Removing position data from originally loaded fd variable')
        
        % Remove legacy fields from FD struct
        loadedVar.fd = rmfield(loadedVar.fd, 'isProportional');
        loadedVar.fd = rmfield(loadedVar.fd, 'position');
        
        % Should we remove the isValve tag? Not right now
        % loadedVar.fd = rmfield(loadedVar.fd, 'isValve');
        
        % Update fullstring from the new ts
        loadedVar.fd.FullString = loadedVar.fd.ts.Name;
        
        debugout('Created new FD for valve state data')        
        debugout(loadedVar.fd)
        
        % Save updated data
        % -----------------------------------------------------------------
        
            % Make the new filename
            newFileName_str = makeFileNameForFD(loadedVar.fd);

            renamedFullFile = fullfile(rootDir_path, ... 
                                       strcat(newFileName_str, '.mat') );

            saveDataFile(renamedFullFile, newFileName_str, loadedVar.fd);
        
        
        debugout('Returning to normal processing loop')
        
    end
    
    

    end

    function saveDataFile (newFullFile, newFileNameStr, fd)
        % Saves the variable 'fd' to a file named newFileNameStr (includes
        % extension) - newFullFile is the fullfile() output. newFileNameStr
        % is for use in error cases.
        
        debugout(sprintf('Saving %s', newFileNameStr))
        debugout(fd)
        
        % Check for Filename Collisions
            if ~exist(newFullFile, 'file')

                % Save the new data file
                save(newFullFile, 'fd');
                
                debugout('Saved valve position data to file')

            else
                % There was a collison

                % put the offending file in issues directory and leave
                % the original alone. Move on
                save( fullfile(issuesDir_path, newFileNameStr), 'fd');
                
                debugout('Filename collision, saving file to issues subdirectory')

            end
        
    end

end % End of Main Function



