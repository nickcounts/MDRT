function [foundFilenames, foundFilePaths] = findFilesInDirectory(rootSearchPath, searchExpression)
%% findFilesInDirectory()
%
%   findFilesInDirectory is a utility that returns the filename/paths of
%   all matching files in a specified directory and its subdirectories.
%   
%   
%
%   This function is based on dataIndexer, written by Staten Longo for
%   VCSFA Aug 2016.
%
%

% Purpose: Provides a means of indexing through a folder for a specific
% expression in the name of each file by running a recursive search.

% Function output [foundFilenames, foundFilePaths] creates a two cell
% arrays of string values including the matching filenames and paths to
% those files where the actual data lives.

% Subfunctions:
%     fileIsOK -                checks filename string input for '._' 
%                               characters, returns logical value
%     directoryIsSearchable  -  checks if the item in the current directory 
%                               is searchable, returns logical value
%     isTheFileWeWant -         checks if the item is not a directory and 
%                               contains, returns logical value

% Supporting functions:
%     dataIndexForSearching - creates dataToSearch file of all metadata files found to place in data repository
    
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)

% Argument Parsing
% ------------------------------------------------------------------------

defaultSearchExpression = 'metadata';
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

foundFilenames = {}; % empty cell array of strings - will hold list
foundFilePaths = {}; % empty cell array of strings - will hold list

% for loop to iterate over entire length of current directory
for i = 1:length(currentDirectoryList);
    
    % call subfunction: isValidFilename to check if filename is useable (does not contain ._ characters)
    % if the dataRepositoryStructure at this index does NOT have ._ then continue loop
    if isValidFilename( currentDirectoryList(i).name )
    
        % call subfunction: isTheFileWeWant
        % if index in repository structure is NOT in current directory/ NOT a folder,
        % AND if regular expression string (dataRepositoryStructure(i).name) does NOT match searchExpression 'metadata'
        if isTheFileWeWant( currentDirectoryList(i) , searchExpression)
            
            % We found a file we want to remember:
           
            % adds new filename to list of found filenames
            foundFilenames{length(foundFilenames)+1} = currentDirectoryList(i).name; 
            
            % add new filepath to list of filepaths
            foundFilePaths{length(foundFilePaths)+1} = fullfile(rootSearchPath,currentDirectoryList(i).name);
           
        % call subfunction: isDirectoryToSearch    
        % elseif index in repository structure is in directory/ is a folder
        % AND string comparison is NOT in current folder or folder above
        elseif isDirectoryToSearch( currentDirectoryList(i) )
            
            % RECURSION CALL: main function calling itself (*magic*)
            
            % creates full file name for metadata file
            placeWeWantToLook = fullfile(rootSearchPath,currentDirectoryList(i).name);
            
            % runs dataIndexer function for each metadata full file name and search expression 'meta data'
            [magicFilenames magicFilePaths] = findFilesInDirectory(placeWeWantToLook,searchExpression); 
 
                % append all filenames found before and after recursion call
                foundFilenames = vertcat(foundFilenames, magicFilenames);
                
                % append all filepaths found before and after recursion call
                foundFilePaths = vertcat(foundFilePaths, magicFilePaths);
            
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

% Use strfind to look for weird characters: if empty, then not found
% and filename is good!

    fileIsOK = isempty( strfind( filenameString, '._') );

end % end subfunction isValidFilename

% -------------------------------------------------------------------------
% Function:
    % isDirectoryToSearch checks if the item in the current directory is 
    % searchable and returns logical value true/1 or false/0
    
% Input:
    % directoryItem input takes a current directory path to check whether
    % or not input is actually a directory and whether or not the filename
    % is in the current directory or the directory above
    
% Output: 
    % directoryIsSearchable returns logical value true/1 if directory item 
    % is searchable or false/0 if directory item is not searchable
    
function directoryIsSearchable = isDirectoryToSearch( directoryItem )

directoryIsSearchable = true;

% checks if the item is in a directory
directoryIsSearchable = directoryIsSearchable * directoryItem.isdir;

% checks if filename is in current directory '.' or a directory above '..'
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '.');
directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '..');

end % end subfunction isDirectoryToSearch
    
% -------------------------------------------------------------------------
% Function:
    % isTheFileWeWant checks if the item in the current directory is 
    % not a directory and contains a match to the search expression
    % and returns logical value true/1 or false/0
    
% Input:
    % directoryItem input takes a current directory path to check whether
    % or not input is actually a directory and whether or not the directory
    % item name contains a match to the search expression
    % searchString input takes a search expression to compare to the
    % directoryItem input name
    
% Output: 
    % foundFile returns logical value true/1 if directory item is not a 
    % directory and contains a match, or false/0 if directory item is a
    % directory or does not contain a match
    
function foundFile = isTheFileWeWant( directoryItem, searchString )
    
    foundFile = true;
    
    % checks if directory item is not a directory
    foundFile = foundFile * ~directoryItem.isdir; 
    
    % look for a match that isn't a directory
    foundFile = foundFile * ~isempty(regexp(directoryItem.name,searchString,'match'));

end % end subfunction isTheFileWeWant       
% -------------------------------------------------------------------------    