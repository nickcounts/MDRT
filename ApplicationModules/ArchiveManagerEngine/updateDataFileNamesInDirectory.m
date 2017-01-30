function updateDataFileNamesInDirectory(pathToData)
%% updateDataFileNamesInDirectory
% updateDataFileNamesInDirectory()
% updateDataFileNamesInDirectory(pathToData)
%
% If no path is supplied, prompts user for directory, backs up all data 
% files, renames using the 'makeFileNameForFD' function. Places problem 
% data files in an 'error' directory for visibility.

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
    
    
directoryList = dir(rootDir_path);

originalFiles = {directoryList(~[directoryList.isdir]).name}';

% remove items beginning with "."
originalFiles(~cellfun(@isempty, regexpi(originalFiles, '^\.'))) = [];

% ignore special files: metadata.mat timeline.mat AvailableFDs.mat
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'metadata.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'timeline.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'AvailableFDs.mat'))) = [];


%% Make temporary directories

tempDir_path   = fullfile(rootDir_path, 'temp');
backupDir_path = fullfile(rootDir_path, 'backup');
issuesDir_path = fullfile(rootDir_path, 'issues');
errorDir_path  = fullfile(rootDir_path, 'error');

mkdir(tempDir_path);
mkdir(backupDir_path);
mkdir(issuesDir_path);
mkdir(errorDir_path);

% Prepare UI Progress Indicator
numberOfFiles = numel(originalFiles);
totalLoops = numberOfFiles * 3;

progressbar('Data Directory Update - Overall', ...
            'Backing up data directory', ...
            'Preparing data directorty', ...
            'Updating Data File Names');

%% Copy entire rootPath into backupDir
for i = 1:numberOfFiles
    copyfile(fullfile(rootDir_path, originalFiles{i}), backupDir_path);
    totalFrac = i/totalLoops;
    progressbar(totalFrac, i/numberOfFiles, [], []);
end

%% Move entire rootPath into tempDir (the working directory)
for i = 1:numberOfFiles
    movefile(fullfile(rootDir_path, originalFiles{i}), tempDir_path);
    totalFrac = (numberOfFiles + i)/totalLoops;
    progressbar(totalFrac, [], i/numberOfFiles, []);
end

%% Open each file, and build a new name based on fd.FullString

for i = 1:numberOfFiles
    
    % Select a file on which to operate:
    thisFullFile = fullfile(tempDir_path, originalFiles{i});

    % Error handling for non-existant variables. Must be a better way to do
    % this, but it seems expedient and is relatively fast.
    try
        loadedVar = load(thisFullFile, '-mat', 'fd');
        
        % Does the file have an FD structure?
        if isfield(loadedVar, 'fd')
            
            % Make the new filename
            newFileName_str = makeFileNameForFD(loadedVar.fd);
            
            renamedFullFile = fullfile(rootDir_path, strcat(newFileName_str, '.mat') );
            
            % Check for Filename Collisions
            if ~exist(renamedFullFile, 'file')

                % rename the file in place
                [status, ~, ~] = movefile(thisFullFile, renamedFullFile);
                
                % Someday I will check this status and do something smart
                
            else
                % There was a collison
                
                % put the offending file in issues directory and leave
                % the original alone. Move on
                copyfile(thisFullFile, issuesDir_path);
                
            end
            
        else
            % Doesn't contain fd structure
            % Do nothing to ignore?
        end
            
    catch
        % Assume unable to load variable 'fd'
        % Could have been errors in file handling.
        % Copy file to error directory for visibility
        copyfile(thisFullFile, errorDir_path);
    end
    
    totalFrac = ( (2*numberOfFiles) + i)/totalLoops;
    progressbar(totalFrac, [], [], i/numberOfFiles);
    
end





