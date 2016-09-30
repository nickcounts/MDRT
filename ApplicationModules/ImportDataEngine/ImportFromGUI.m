function ImportFromGUI( filesIn, metaData, folderName )
%ImportFromGUI 
%   Automates the data importing process.
%
%   filesIn is a cell array of path/filenames that make up the raw data to
%   be imported. 
%
%   The function generates file/folder structure, names it, moves the
%   files, and starts the import process.
%
%   folderName is a string that is a complete path to the destination root
%   folder
%
%   Optional Parameters:
%       'noFolderPrompt'    - disables the popup input for folder name
%                             guess. Guesses and prompts are made if this
%                             is omitted. Not implemented at this time.

% Testing Variables
% filesIn = {'/Users/nickcounts/Downloads/LOLS-056.delim'};


% How to open multiple files!
% [filename, pathname] = uigetfile('*.*',  'All Files (*.*)','MultiSelect','on')




config = MDRTConfig.getInstance;

if ~iscell(filesIn)
    % convert single string input to a single cellstring
    filesIn = {filesIn};
end

if ~iscell(folderName)
    % convert single string input to a single cellstring
    folderName = {folderName};
end




%% Make sure to handle the file type. and EXIT if bad filetype


%% Build Folder Name String


folderName = strtrim(folderName);

% clean up unhappy reserved filename characters
        folderName = regexprep(folderName,'^[!@$^&*~?.|/[]<>\`";#()]','');
        folderName = regexprep(folderName, '[:]','-');
        
if isempty(folderName)
    % User cancelled
    return
else
    
    rootPath = fullfile(config.importDataPath, folderName);
    
    mkdir( rootPath{1} );
    
    config.userWorkingPath = rootPath{1};
    
    config.makeWorkingDirectoryStructure;
    
    config.writeConfigurationToDisk;
    

    
end


%% Move files to location to process

for i = 1:numel(filesIn)
    
    
    
    [a b c] = fileparts(filesIn{i});
    fileBeingCopied = [b, c];
    
    
    copyWorked = copyfile(filesIn{i}, fullfile(config.workingDelimPath, ...
                                               'original', ...
                                               fileBeingCopied) );
    
	if ~copyWorked
        warningMsg = sprintf('Moving file: %s failed', filesIn{i});
        warning(warningMsg)
%         return
    end
                                           
end


%% Split .delim files

for i = 1:numel(filesIn)
    
    % Eventually add try/catch for error handling?
    splitDelimFiles( filesIn{i}, config )
    
end



%% Parse stripped .delim files

processDelimFiles(config)


%% Start Indexing!

% FDList = listAvailableFDs(config.workingDataPath, 'mat');

[FDList, timeSpan] = indexTimeAndFDNames(config.workingDataPath);
save(fullfile(config.workingDataPath, 'AvailableFDs.mat'), 'FDList');


metaData.fdList = FDList;
metaData.timeSpan = timeSpan;

% % save(fullfile(dataPath, 'metadata.mat'), 'metaData');
save(fullfile(config.workingDataPath, 'metadata.mat'), 'metaData');





