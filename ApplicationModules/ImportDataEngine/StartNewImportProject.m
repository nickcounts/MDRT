function StartNewImportProject( filesIn, metaData, varargin )
%StartNewImportProject 
%   Automates the data importing process.
%
%   filesIn is a cell array of path/filenames that make up the raw data to
%   be imported. 
%
%   The function generates file/folder structure, names it, moves the
%   files, and starts the import process.
%
%   Optional Parameters:
%       'noFolderPrompt'    - disables the popup input for folder name
%                             guess. Guesses and prompts are made if this
%                             is omitted

% Testing Variables
% filesIn = {'/Users/nickcounts/Downloads/LOLS-056.delim'};


% How to open multiple files!
% [filename, pathname] = uigetfile('*.*',  'All Files (*.*)','MultiSelect','on')

%% Set Default Variables

doPromptFolderName

switch nargin
    case 3
        switch lower(varargin{1})
            case 'nofolderprompt'


config = MDRTConfig.getInstance;

if ~iscell(filesIn)
    % convert single string input to a single cellstring
    filesIn = {filesIn};
end

if exist(filesIn{1}, 'file')
    fid = fopen(filesIn{1});
    [path, fileName ext] = fileparts(filesIn{1});
else
    warning('The .delim file does not exist')
end


%% Make sure to handle the file type. and EXIT if bad filetype

switch lower(ext)
    case '.delim'
        disp('Pre-processing .delim file')
        textParseString = '%s %*s %*s %*s %*s %*s %*[^\n]';
        rawTime = textscan(fid,textParseString,5,'Delimiter',',');
        startTime = makeMatlabTimeVector(rawTime{1}, false, false);
    case '.csv'
        warning('.csv files are not currently supported for automatic import');
        return
    
    otherwise
        warning('This file type is not currently supported for automatic import');
        fclose(fid);
        return
end

fclose(fid);

%% Build Folder Name String

nameParts = {   metaData.operationName;
                metaData.MARSprocedureName
            };

guessName = strjoin( {  datestr(startTime(1), 'YYYY-mm-dd');
                        '-';
                        strjoin(nameParts);
                        });
                    
guessName = strtrim(guessName);

folderName = inputdlg('Import data into folder:', ...
                      'Import Data Folder Name', 1, {guessName});

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





