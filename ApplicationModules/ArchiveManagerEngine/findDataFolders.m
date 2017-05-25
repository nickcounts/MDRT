function [foundFolderNames, foundFolderPaths] = findDataFolders(rootSearchPath, searchExpression)
%% findDataFolders()


defaultSearchExpression = 'data';
defaultDirectory = pwd;

switch nargin
    case 0
        % Default behavior assumes you are looking for metadata.mat and
        % prompts for a directory
        searchExpression = defaultSearchExpression;
        rootSearchPath = uigetdir(defaultDirectory);
        
    case 1
        % Assumes looking for metadata.mat and you passed a directory
        searchExpression = defaultSearchExpression;
        
    case 2
        % You supply everything
    otherwise
        %What on earth did you do?
        warning('findFilesInDirectory does not support these arguments');
end

% Error checking
% ------------------------------------------------------------------------

if ~exist(rootSearchPath, 'dir')
    % Passed an invalid directory
    warning('Invalid search directory specified');
    return
end


% search current directory and put results in structures
currentDirectoryList = dir(rootSearchPath); 

foundFolderNames = {}; % empty cell array of strings - will hold list
foundFolderPaths = {}; % empty cell array of strings - will hold list

% for loop to iterate over entire length of current directory
for i = 1:length(currentDirectoryList);
    
    % call subfunction: isValidFilename to check if filename is useable (does not contain ._ characters)
    % if the dataRepositoryStructure at this index does NOT have ._ then continue loop
    if isValidFilename( currentDirectoryList(i).name )
    
        % call subfunction: isTheFileWeWant
        % if index in repository structure is NOT in current directory/ NOT a folder,
        % AND if regular expression string (dataRepositoryStructure(i).name) does NOT match searchExpression 'metadata'
        if isTheFolderWeWant( currentDirectoryList(i) , searchExpression)
            
            % We found a file we want to remember:
           
            % adds new filename to list of found filenames
            foundFolderNames{length(foundFolderNames)+1} = currentDirectoryList(i).name; 
            
            % add new filepath to list of filepaths
            foundFolderPaths{length(foundFolderPaths)+1} = fullfile(rootSearchPath,currentDirectoryList(i).name);
           
        % call subfunction: isDirectoryToSearch    
        % elseif index in repository structure is in directory/ is a folder
        % AND string comparison is NOT in current folder or folder above
        elseif isDirectoryToSearch( currentDirectoryList(i) )
            
            % RECURSION CALL: main function calling itself (*magic*)
            
            % creates full file name for metadata file
            placeWeWantToLook = fullfile(rootSearchPath,currentDirectoryList(i).name);
            
            % runs dataIndexer function for each metadata full file name and search expression 'meta data'
            [magicFilenames magicFilePaths] = findDataFolders(placeWeWantToLook,searchExpression); 
 
                % append all filenames found before and after recursion call
                foundFolderNames = vertcat(foundFolderNames, magicFilenames);
                
                % append all filepaths found before and after recursion call
                foundFolderPaths = vertcat(foundFolderPaths, magicFilePaths);
            
        end % end if loop isTheFileWe Want
        
    end % end if loop isValidFilename
    
end % end for loop iterating over current directory

end % end function dataIndexer



%% Subfunctions:

% -------------------------------------------------------------------------
% Function:
    % isValidFilename checks filename string input for '._' characters 
    % (hidden files) and returns logical value true/1 or false/0
    
% Input:
    % filenameString input takes a filename string to check for '._' characters
    
% Output: 
    % fileIsOK returns logical value true/1 if file is useable
    % or false/0 if file is not useable

function fileIsOK = isValidFilename(filenameString)    
    % Ignore hidden files and files (start with .)
    fileIsOK = isempty( regexp( filenameString, '\.') );

end

    
function directoryIsSearchable = isDirectoryToSearch( directoryItem )

directoryIsSearchable = true;

% checks if the item is in a directory
directoryIsSearchable = directoryIsSearchable * directoryItem.isdir;

% checks if filename is in current directory '.' or a directory above '..'
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '.');
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '..');

end % end subfunction isDirectoryToSearch
    

    
function foundDirectory = isTheFolderWeWant( directoryItem, searchString )
    
    foundDirectory = true;
    
    % checks if directory item is not a directory
    foundDirectory = foundDirectory * directoryItem.isdir; 
    
    % look for a match that isn't a directory
    foundDirectory = foundDirectory * ~isempty(regexp(directoryItem.name,searchString,'match'));

end % end subfunction isTheFileWeWant       
% -------------------------------------------------------------------------    