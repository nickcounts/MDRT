

% {ignore this stuff:

%% looks at metaDataStructure to step through existing metadata and return 
%% product of??

%% check metaDataStructure ->
% return output from newMetaDataStructure with available data matrix

% existing metaDataStructure does not currently associate the actual data with other provided information
% need this tool to examine metaDataStructure and provide the FD, timespan, and available data for those parameters
% provide output in matrix form? how best to organize this?
% }



% dataIndexer runs recursive search for search expression (which will be 
% set to metadata) through the base directory (which will be set to the data repository)

function [foundFilenames, foundFilePaths] = dataIndexer(currentPath, searchExpression)

%% go into each folder in data repository

% dataRepositoryDirectory will be set to Data Repository path (this can be 
% changed to a different file path if want to look outside of data repository)

% search expression will be set to string value 'metadata'

currentDirectoryList = dir(currentPath); % searches current directory and puts results in structures

foundFilenames = {}; % empty < array of structures > to compile metadata files into
foundFilePaths = {}; % empty cell array of strings - will hold list

for i = 1:length(currentDirectoryList); % for loop to iterate over entire length of current directory
    
    % If the dataRepositoryStructure at this index does NOT have ._ then do
    % the normal work
    % sub function to check if filename is useable (does not contain ._
    % characters)
    if isValidFilename( currentDirectoryList(i).name )
    
        % if index in repository structure is NOT in current directory/ NOT a folder, and if regular expression string (dataRepositoryStructure(i).name) and searchExpression 'metadata' do NOT match
        if isTheFileWeWant( currentDirectoryList(i) , searchExpression)
            
            % We found a file we want to remember
            
            % Add to file name list
            % Add to file path list
            
            
            % adds new file to list of found files
            foundFilenames{length(foundFilenames)+1} = currentDirectoryList(i).name; 
            
            % TODO: Add to file path list
            foundFilePaths{length(foundFilePaths)+1} = fullfile(currentPath,currentDirectoryList(i).name);
           
            
        % elseif index in repository structure is in directory/ is a folder and string comparison is not in current folder or folder above
        elseif isDirectoryToSearch( currentDirectoryList(i) )
            
            % RECURSION CALL
            placeWeWantToLook = fullfile(currentPath,currentDirectoryList(i).name); % creates full file name for metadata file
            [magicFilenames magicFilePaths] = dataIndexer(placeWeWantToLook,searchExpression); % runs dataIndexer function for each metadata full file name and search expression 'meta data'
        
            % if temporary metadata structures file is NOT empty
            
%             %% CHANGE THIS IF STATEMENT TO BE A FUNCTION CALL TO NICK'S CHECKSTRUCTURETYPE
%             if ~isempty(metaDataStructuresTemp) 
%                 
%                 keyboard
%                 add it to the current list of metadata structures
%                 foundFilenames((length(foundFilenames)+1):(length(foundFilenames)+length(metaDataStructuresTemp))) = metaDataStructuresTemp;
%                 
%                 
%                 NICK PLZ HELP WITH DIS
%                 add file path name to current list of metadata file path names
%                 for some reason I'm getting a random r,s,t at the end of
%                 my file paths? Also need to figure out how to only output
%                 the final file path (not every single file path to get to
%                 the metadata file)
%                 
%                 if the metadata file is added to the structures array,
%                 add the full file name to an array structure of full file
%                 names
%                 foundFilePaths((length(foundFilePaths)+1):(length(foundFilePaths)+length(foundFilePaths))) = foundFilePaths
%                 
                foundFilenames = vertcat(foundFilenames, magicFilenames); % appends all file names found
                foundFilePaths = vertcat(foundFilePaths, magicFilePaths); % appends all file paths found 
            
        end
    end
end
%foundFilenames = foundFilenames';
%foundFilePaths;
end



%% Sub functions

function fileIsOK = isValidFilename(filenameString)    

% Use strfind to look for weird characters: if empty, then not found
% and filename is good!

    fileIsOK = isempty( strfind( filenameString, '._') );

end
    
    
function directoryIsSearchable = isDirectoryToSearch( directoryItem )

directoryIsSearchable = true;

% Is the item a directory?
directoryIsSearchable = directoryIsSearchable * directoryItem.isdir;

% Is the filename . or .. ?
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '.');
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '..');

end
    

function foundFile = isTheFileWeWant( directoryItem, searchString )
    
    foundFile = true;
    
    foundFile = foundFile * ~directoryItem.isdir;
    
    foundFile = foundFile * ~isempty(regexp(directoryItem.name,searchString,'match'));  % look for a match that isn't a directory

end
       
    

% how do I have matlab point to the data repository folder and search expression for meta data (by string?)


%% within each individual data set folder, find metaData file






%% dataIndexForSearching will use this function to take each metaData file and compile into new list < array of structures >
%% search functions will need to look only within dataIndexForSearching with given search parameters and point to the location of file where desired data lives

