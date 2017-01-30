%% Script to update a data-set in the data repository
%
%   1) All data files will be renamed with the currently implemented
%   convention.
%
%   2) The data set will be re-indexed for available FDs and timespan.
%
%   3) AvailableFDs.mat will be updated
%
%   4) metadata.mat will be updated (and created if missing)
%
%   5) dataIndex.mat will be updated if found
%
%

% Counts, VCSFA 2017

%% CONSTANT DEFINITIONS
FD_INDEX_FILE_NAME_STR = 'AvailableFDs.mat'; % Should this come from a project
                                          % configuration file?
                                          
                                          
METADATA_FILE_NAME_STR = 'metadata.mat';
DATAINDEX_FILE_NAME_STR = 'dataIndex.mat';
DATA_FOLDERS_LEVELS_DEEP_IN_ARCHIVE = 2;

%% STEP 0: Select data directory to update/refresh

rootDir_path = uigetdir;

if rootDir_path == 0
    % User pressed cancel
    return
end

%% STEP 1: rename all files in data set

% Temporarily disabled
updateDataFileNamesInDirectory(rootDir_path);


%% STEP 2: re-index data files

[ FDList, timespan ] = indexTimeAndFDNames( rootDir_path );


%% STEP 3: Update AvailableFDs.mat

bWriteFdFile = false;

if ~exist(fullfile(rootDir_path, FD_INDEX_FILE_NAME_STR), 'file')
	% Ask if you want to create a new file
    qString = sprintf('%s does not exist. Do you want to create one?', ...
                        FD_INDEX_FILE_NAME_STR);
    titleString = ['Create ' FD_INDEX_FILE_NAME_STR];
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            bWriteFdFile = true;
        otherwise            
	end
    
end

if bWriteFdFile
	save( fullfile(rootDir_path, FD_INDEX_FILE_NAME_STR), 'FDList');
end



%% STEP 4: update/create metadata.mat

bWriteMetadataFile = false;

% Generate metadata
metadata = newMetaDataStructure;
    
if ~exist(fullfile(rootDir_path, METADATA_FILE_NAME_STR), 'file')

	% Ask if you want to create a new file
    qString = sprintf('%s does not exist. Do you want to create one?', ...
                        METADATA_FILE_NAME_STR);
    titleString = ['Create ' METADATA_FILE_NAME_STR];
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            bWriteMetadataFile = true;
        otherwise            
	end

else

    % Found existing metadata file
    m = load( fullfile(rootDir_path, METADATA_FILE_NAME_STR));
    
    % use existing metadata variable if it exists
    if isfield(m, 'metadata')
        metadata = m.metadata;
        bWriteMetadataFile = true;
    else
    end

end


metadata.timeSpan = timespan;


if bWriteMetadataFile
	save( fullfile(rootDir_path, METADATA_FILE_NAME_STR), 'metadata');
end


%% STEP 5: Find and update dataIndex.mat

higherLevels = rootDir_path;

% get path 2 directories 'up'
for i = 1:DATA_FOLDERS_LEVELS_DEEP_IN_ARCHIVE
	[higherLevels, currentDirectory, ~] = fileparts(higherLevels);
end

archiveRootPath = higherLevels;

dataIndexFullFile = fullfile(archiveRootPath, DATAINDEX_FILE_NAME_STR);

if exist(dataIndexFullFile, 'file')
    
    % Try to find the relevant metadata entry
    d = load(dataIndexFullFile);
    
    if isfield(d, 'dataIndex')
        dataIndex = d.dataIndex;
    end
    
    matchingEntries = [];
    
    for i = 1:numel(dataIndex)
        if strcmp(dataIndex(i).pathToData, rootDir_path)
            % Found a dataIndex enry that points to this data set
            matchingEntries = vertcat(matchingEntries, i);
        end
    end
    
    bWriteToIndex = true;
    
    switch length(matchingEntries)
        case 0
            % No matches found
            indexIndex = numel(dataIndex) + 1;
        case 1
            % One match found
            indexIndex = matchingEntries;
        otherwise
            % Multiple matches found.
            % Throw error or launch another tool?
            bWriteToIndex = false;
            error('Multiple dataIndex entries found for data set.');
            
    end
    
    
    if bWriteToIndex
        
        dataIndex(indexIndex).metaData = metadata;
        dataIndex(indexIndex).FDList = metadata.fdList;
        dataIndex(indexIndex).pathToData = rootDir_path;
        
    end
    
    bWriteDataIndexFile = false;
    
    % Ask if you want to write new dataIndex
    qString = 'Commit updated dataIndex.mat to disk?';
    titleString = 'Save dataIndex.mat';
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            bWriteDataIndexFile = true;
        otherwise            
    end
    
    if bWriteDataIndexFile
        
        backupFileName_str = sprintf('dataIndex-%s.bak', ...
                                     datestr(now, 'mmmddyyyy-HHMMSS') );
                                 
        backupFullFile = fullfile(archiveRootPath, backupFileName_str);
        
        copyfile(dataIndexFullFile, backupFullFile, 'f');
        
        save(dataIndexFullFile, 'dataIndex', '-mat');
                                 
    end
    
    
    
else
    % Didn't find the data index
    
    % Prompt user to locate index
    
    
end
