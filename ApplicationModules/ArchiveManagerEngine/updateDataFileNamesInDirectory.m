%% updateDataFileNamesInDirectory
% updateDataFileNamesInDirectory - script
% prompts user for directory, backs up all data files, renames using the
% 'makeFileNameForFD' function. Places problem data files inan 'e rror' 
% directory for visibility.

% Find all data files in directory

rootPath = uigetdir;
directory = dir(rootPath);

originalFiles = {directory(~[directory.isdir]).name}';

% remove items beginning with "."
originalFiles(~cellfun(@isempty, regexpi(originalFiles, '^\.'))) = [];

% ignore special files: metadata.mat timeline.mat AvailableFDs.mat
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'metadata.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'timeline.mat'))) = [];
originalFiles(~cellfun(@isempty, regexpi(originalFiles, 'AvailableFDs.mat'))) = [];

AvailableFDs

%% Make temporary directories

tempDir = fullfile(rootPath, 'temp');
backupDir = fullfile(rootPath, 'backup');
issuesDir = fullfile(rootPath, 'issues');
errorDir = fullfile(rootPath, 'error');

mkdir(tempDir);
mkdir(backupDir);
mkdir(issuesDir);
mkdir(errorDir);

% Prepare UI Progress Indicator
numberOfFiles = numel(originalFiles);
totalLoops = numberOfFiles * 3;

progressbar('Data Directory Update - Overall', ...
            'Backing up data directory', ...
            'Preparing data directorty', ...
            'Updating Data File Names');

%% Copy entire rootPath into backupDir
for i = 1:numberOfFiles
    copyfile(fullfile(rootPath, originalFiles{i}), backupDir);
    totalFrac = i/totalLoops;
    progressbar(totalFrac, i/numberOfFiles, [], []);
end

%% Move entire rootPath into tempDir (the working directory)
for i = 1:numberOfFiles
    movefile(fullfile(rootPath, originalFiles{i}), tempDir);
    totalFrac = (numberOfFiles + i)/totalLoops;
    progressbar(totalFrac, [], i/numberOfFiles, []);
end

%% Open each file, and build a new name based on fd.FullString

for i = 1:numberOfFiles
    
    % Select a file on which to operate:
    thisFile = fullfile(tempDir, originalFiles{i});

    % Error handling for non-existant variables. Must be a better way to do
    % this, but it seems expedient and is relatively fast.
    try
        loadedVar = load(thisFile, '-mat', 'fd');
        
        % Does the file have an FD structure?
        if isfield(loadedVar, 'fd')
            
            % Make the new filename
            newFileName = makeFileNameForFD(loadedVar.fd);
            
            renamedFile = fullfile(rootPath, strcat(newFileName, '.mat') );
            
            % Check for Filename Collisions
            if ~exist(renamedFile, 'file')

                % rename the file in place
                [status, ~, ~] = movefile(thisFile, renamedFile);
                
                % Someday I will check this status and do something smart
                
            else
                % There was a collison
                
                % put the offending file in issues directory and leave
                % the original alone. Move on
                copyfile(thisFile, issuesDir);
                
            end
            
        else
            % Doesn't contain fd structure
            % Do nothing to ignore?
        end
            
    catch
        % Assume unable to load variable 'fd'
        % Could have been errors in file handling.
        % Copy file to error directory for visibility
        copyfile(thisFile, errorDir);
    end
    
    totalFrac = ( (2*numberOfFiles) + i)/totalLoops;
    progressbar(totalFrac, [], [], i/numberOfFiles);
    
end





