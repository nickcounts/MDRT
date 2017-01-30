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
fdIndexFileName_str = 'AvailableFDs.mat'; % Should this come from a project
                                          % configuration file?
metaDataFileName_str = 'metadata.mat';
dataIndexFileName_str = 'dataIndex.mat';
dataFoldersLevelsDeepInArchive = 2;

%% STEP 0: Select data directory to update/refresh

rootPath = uigetdir;

if rootPath == 0
    % User pressed cancel
    return
end

%% STEP 1: rename all files in data set

% Temporarily disabled
% updateDataFileNamesInDirectory(rootPath);


%% STEP 2: re-index data files

[ FDList, timespan ] = indexTimeAndFDNames( rootPath );


%% STEP 3: Update AvailableFDs.mat

writeFdFile = false;

if ~exist(fullfile(rootPath, fdIndexFileName_str), 'file')
	% Ask if you want to create a new file
    qString = sprintf('%s does not exist. Do you want to create one?', ...
                        fdIndexFileName_str);
    titleString = ['Create ' fdIndexFileName_str];
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            writeFdFile = true;
        otherwise            
	end
    
end

if writeFdFile
	save( fullfile(rootPath, fdIndexFileName_str), 'FDList');
end



%% STEP 4: update/create metadata.mat

writeMetadataFile = false;

% Generate metadata
metadata = newMetaDataStructure;
    
if ~exist(fullfile(rootPath, metaDataFileName_str), 'file')

	% Ask if you want to create a new file
    qString = sprintf('%s does not exist. Do you want to create one?', ...
                        metaDataFileName_str);
    titleString = ['Create ' metaDataFileName_str];
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            writeMetadataFile = true;
        otherwise            
	end

else

    % Found existing metadata file
    m = load( fullfile(rootPath, metaDataFileName_str));
    
    % use existing metadata variable if it exists
    if isfield(m, 'metadata')
        metadata = m.metadata;
        writeMetadataFile = true;
    else
    end

end


metadata.timeSpan = timespan;


if writeMetadataFile
	save( fullfile(rootPath, metaDataFileName_str), 'metadata');
end


%% STEP 5: Find and update dataIndex.mat

higherLevels = rootPath;

% get path 2 directories 'up'
for i = 1:dataFoldersLevelsDeepInArchive
	[higherLevels, currentDirectory, ~] = fileparts(higherLevels);
end

archiveRootPath = higherLevels;

dataIndexFullFile = fullfile(archiveRootPath, dataIndexFileName_str);

if exist(dataIndexFullFile, 'file')
    
    % Try to find the relevant metadata entry
    d = load(dataIndexFullFile);
    
    if isfield(d, 'dataIndex')
        dataIndex = d.dataIndex;
    end
    
    matchingEntries = [];
    
    for i = 1:numel(dataIndex)
        if strcmp(dataIndex(i).pathToData, rootPath)
            % Found a dataIndex enry that points to this data set
            matchingEntries = vertcat(matchingEntries, i);
        end
    end
    
    writeToIndex = true;
    
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
            writeToIndex = false;
            error('Multiple dataIndex entries found for data set.');
            
    end
    
    
    if writeToIndex
        
        dataIndex(indexIndex).metaData = metadata;
        dataIndex(indexIndex).FDList = metadata.fdList;
        dataIndex(indexIndex).pathToData = rootPath;
        
    end
    
    writeDataIndexFile = false;
    
    % Ask if you want to write new dataIndex
    qString = 'Commit updated dataIndex.mat to disk?';
    titleString = 'Save dataIndex.mat';
    choice = questdlg(  qString, ...
                        titleString, ...
                        'Yes', 'No', 'No');
	switch choice
        case 'Yes'
            writeDataIndexFile = true;
        otherwise            
    end
    
    if writeDataIndexFile
        
        backupFileName_str = sprintf('dataIndex-%s.bak', ...
                                     datestr(now, 'mmmddyyyy-hhmmss') );
                                 
        backupFullFile = fullfile(archiveRootPath, backupFileName_str);
        
        copyfile(dataIndexFullFile, backupFullFile, 'f');
        
        save(dataIndexFullFile, 'dataIndex', '-mat');
                                 
    end
    
    
    
else
    % Didn't find the data index
    
    % Prompt user to locate index
    
    
end

