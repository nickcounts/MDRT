function [] = metaDataIndexer()
%% metaDataIndexer()
% 
% Purpose: Checks existing data archive for metadata files and fixes 
% existing files to include all desired fields and values for fdList and 
% timeSpan, returning them back to their current locations.
%
% No function input of output requirements.
%
% Supporting functions:
%     indexTimeAndFDNames - obtains values for fdList and timeSpan
%
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


% set file path
dataRepositoryDirectory = 'C:\Users\Paige\Documents\MARS Matlab\Data Repository'; 

% load variables from dataToSearch file
load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') );

% create new metaDataStructure with all necessary fields
desiredMetaDataStructure = newMetaDataStructure;
    
% create list of fieldnames in blank structure
desiredFieldnames = fieldnames(desiredMetaDataStructure);


% index over length of dataToSearch file
for i = 1:length(dataToSearch)
    
    % create list of fieldnames in existing structure
    existingFieldnames = fieldnames(dataToSearch(i).metaData);
    
    % set metaData in dataToSearch equal to value
    metaData = dataToSearch(i).metaData;
     
    % for each fieldname within the blank structure
    for j = 1:numel(desiredFieldnames)

        % if the desired fieldname is not found in the current metadata structure
        if ~isfield(metaData, desiredFieldnames{j})
            
            % add the desired field and its empty value to the existing metaData structure
            metaData = setfield(metaData, desiredFieldnames{j}, ( getfield(desiredMetaDataStructure, desiredFieldnames{j} ) ) )
            
        end % end if loop finding desired fieldnames to add to existing structure
       
    end % end for loop iterating over list of desired fieldnames 

    % list of new fieldnames in metaData
    metaDataFieldnames = fieldnames(metaData);
    
    % set pathToData in dataToSearch equal to value
    pathToData = dataToSearch(i).pathToData;

    % set the current data folder to search through
    currentPathToData = dir( pathToData );

    % for each file in the current data folder
    for field = 1:length( metaDataFieldnames )

        % create switch/case statement to fill new fieldnames with real values
        switch metaDataFieldnames{field}

            case 'fdList'
                
                % if field fdList is empty
                if isempty(getfield(metaData, 'fdList') )

                    % obtain fdList values
                    [availFDs, ~] = indexTimeAndFDNames(pathToData);
                    
                    % append new values to metaData structure
                    metaData.fdList = availFDs;
                    
                end % end if loop checking if fdList is empty
                
            case 'timeSpan'
                
                % if field timeSpan is empty
                if isempty(getfield(metaData, 'timeSpan') )
                
                    % obtain timeSpan values
                    [~, timespan] = indexTimeAndFDNames(pathToData);
                    
                    % append new values to metaData structure
                    metaData.timeSpan = timespan;
                    
                end % end if loop checking if timeSpan is empty

        end % switch/case statement

    end % for loop iterating over each file in current data folder

    % save these metadata files back into their original locations
    save( fullfile(dataToSearch(i).pathToData, 'fixedMetaData.mat'), 'metaData' );
 
end % end for loop iterating over length of dataToSearch file

end % end function metaDataIndexer

  
%% fd list - construct from each file in data folders
% column 1: fd.FullString
% column 2: filename.mat

%% fdTimeSpan: [ min(fd.ts) max(fd.ts) ]

%% metaData.timeSpan: [ min(FDtimeSpan) max(FDtimeSpan) ]

% =========================================================================
% garbage

% % search current directory and put results in structures
% currentDirectoryList = dir(currentPath); 
% 
% foundFilenames = {}; % empty cell array of strings - will hold list
% foundFilePaths = {}; % empty cell array of strings - will hold list
% 
% % for loop to iterate over entire length of current directory
% for i = 1:length(currentDirectoryList);
% 
%     % call subfunction: isValidFilename to check if filename is useable (does not contain ._ characters)
%     % if the dataRepositoryStructure at this index does NOT have ._ then continue loop
%     if isValidFilename( currentDirectoryList(i).name )
%     
%         % call subfunction: isTheFileWeWant
%         % if index in repository structure is NOT in current directory/ NOT a folder,
%         % AND if regular expression string (dataRepositoryStructure(i).name) does NOT match searchExpression 'metadata'
%         if isTheFileWeWant( currentDirectoryList(i) , searchExpression)
%             
%             % We found a file we want to remember:
%            
%             % adds new filename to list of found filenames
%             foundFilenames{length(foundFilenames)+1} = currentDirectoryList(i).name; 
%             
%             % add new filepath to list of filepaths
%             foundFilePaths{length(foundFilePaths)+1} = fullfile(currentPath,currentDirectoryList(i).name);
%            
%         % call subfunction: isDirectoryToSearch    
%         % elseif index in repository structure is in directory/ is a folder
%         % AND string comparison is NOT in current folder or folder above
%         elseif isDirectoryToSearch( currentDirectoryList(i) )
%             
%             % RECURSION CALL: main function calling itself (*magic*)
%             
%             % creates full file name for metadata file
%             placeWeWantToLook = fullfile(currentPath,currentDirectoryList(i).name);
%             
%             % runs dataIndexer function for each metadata full file name and search expression 'meta data'
%             [magicFilenames magicFilePaths] = dataIndexer(placeWeWantToLook,searchExpression); 
%  
%                 % append all filenames found before and after recursion call
%                 foundFilenames = vertcat(foundFilenames, magicFilenames);
%                 
%                 % append all filepaths found before and after recursion call
%                 foundFilePaths = vertcat(foundFilePaths, magicFilePaths);
%             
%         end % end if loop isTheFileWe Want
%         
%     end % end if loop isValidFilename
%     
% end % end for loop iterating over current directory
% 
% end % end function dataIndexer
% 
% 
% 
% %% Subfunctions:
% 
% % -------------------------------------------------------------------------
% % Function:
%     % isValidFilename checks filename string input for '._' characters 
%     % (hidden files) and returns logical value true/1 or false/0
%     
% % Input:
%     % filenameString input takes a filename string to check for '._' characters
%     
% % Output: 
%     % fileIsOK returns logical value true/1 if file is useable
%     % or false/0 if file is not useable
% 
% function fileIsOK = isValidFilename(filenameString)    
% 
% % Use strfind to look for weird characters: if empty, then not found
% % and filename is good!
% 
%     fileIsOK = isempty( strfind( filenameString, '._') );
% 
% end % end subfunction isValidFilename
% 
% % -------------------------------------------------------------------------
% % Function:
%     % isDirectoryToSearch checks if the item in the current directory is 
%     % searchable and returns logical value true/1 or false/0
%     
% % Input:
%     % directoryItem input takes a current directory path to check whether
%     % or not input is actually a directory and whether or not the filename
%     % is in the current directory or the directory above
%     
% % Output: 
%     % directoryIsSearchable returns logical value true/1 if directory item 
%     % is searchable or false/0 if directory item is not searchable
%     
% function directoryIsSearchable = isDirectoryToSearch( directoryItem )
% 
% directoryIsSearchable = true;
% 
% % checks if the item is in a directory
% directoryIsSearchable = directoryIsSearchable * directoryItem.isdir;
% 
% % checks if filename is in current directory '.' or a directory above '..'
% directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '.');
% directoryIsSearchable = directoryIsSearchable * ~strcmp(directoryItem.name, '..');
% 
% end % end subfunction isDirectoryToSearch
%     
% % -------------------------------------------------------------------------
% % Function:
%     % isTheFileWeWant checks if the item in the current directory is 
%     % not a directory and contains a match to the search expression
%     % and returns logical value true/1 or false/0
%     
% % Input:
%     % directoryItem input takes a current directory path to check whether
%     % or not input is actually a directory and whether or not the directory
%     % item name contains a match to the search expression
%     % searchString input takes a search expression to compare to the
%     % directoryItem input name
%     
% % Output: 
%     % foundFile returns logical value true/1 if directory item is not a 
%     % directory and contains a match, or false/0 if directory item is a
%     % directory or does not contain a match
%     
% function foundFile = isTheFileWeWant( directoryItem, searchString )
%     
%     foundFile = true;
%     
%     % checks if directory item is not a directory
%     foundFile = foundFile * ~directoryItem.isdir; 
%     
%     % look for a match that isn't a directory
%     foundFile = foundFile * ~isempty(regexp(directoryItem.name,searchString,'match'));
% 
% end % end subfunction isTheFileWeWant       
% % ------------------------------------------------------------------------- 
% 
% % =========================================================================
% 
% 
% % FD output is string value (call from availFD in getDataSetRange?)
% % timestamp1 is minimum value, timestamp 2 is maximum value
% 
% %% check each file -> if file is FD: populate output fields with FD string value, and UTC timespan (timestamp1 and timestamp2)
% if
% 	timestamp1 == min(%returned timestamp)
% 	timestamp2 == max(%returned timestamp)
% 	
% %% if single timestamp exists, populate both timestamp1 and timestamp2 fields with same value
% 
% elseif % returned timestamp is single value
% 	timestamp1 == %returned timestamp
% 	timestamp2 == %returned timestamp
% 	% or can write as timestamp1 == timestamp2 cleaner?
% 	
% %% compile results in matrix with columns for each output field 
% %[FD timestamp1 timestamp2]
% % save matrix to metaDataStructure
% dataMetaData.metaDataIndexer
% 
% %            % for each matching fieldname 
%            for matches = 1:length(matchingFieldnames)
% 
%                % if the blank structure fieldname matches the existing fieldname
%     %            if matchingFieldnames(j) == true
% 
%     %                 % fill blank structure with existing structure information
%     %                 blankMetaDataStructure.fieldnamesBlank = dataToSearch(i).metaData
%     %   keyboard          
%     %                 % edit array structure of metaData
%     %                 dataToSearch(i).metaData = blankMetaDataStructure.fieldnamesBlank; 
% 
% 
% %                 % not a fieldname match
% %                 if matchingFieldnames(matches) == false
% 
% 
% %                     newFieldname = fieldnamesBlank(matches);
% %                     newFieldnameValue = getfield(blankMetaDataStructure, fieldnamesBlank{matches});
% % 
% %                     newField = struct;
% %                     newField.newFieldname = newFieldnameValue;
%                     newStruct = struct;
%                     newStruct =  setfield(newStruct, desiredFieldnames{j}, ( getfield(desiredMetaDataStructure, desiredFieldnames{j} ) )
% 
%                     % add new fieldname to dataToSearch structure
%                     dataToSearch(i).metaData.newStruct = 

            
%             if strcmp(fieldnamesBlank{j}, fieldnamesExisting) ...
%                     || strcmp(fieldnamesExisting{k}, fieldnamesBlank)
%             matchingFieldnames = strcmp(fieldnamesBlank,fieldnamesExisting);

        
%         % for each fieldname within the existing structure
%         for k = 1:numel(fieldnamesExisting)

% get name for current fd in list
%                     fdName = fd.FullString;
% 
%                     % get file name for current fd
%                     [PATHSTR, NAME, EXT] = fileparts( currentFile );
%                     fdFilename = strcat( NAME,EXT );
%                     
%                     % listAvailableFDs(currentPathToData)
% 
%                     % generate timespan for each individual fd
%                     fdTimeSpan = [ min(fd.ts.Time) max(fd.ts.Time) ]
% 
%                     % HOW DO WE WANT TO INCORPORATE fdTimeSpan INTO METADATA STRUCTURES
%                     % metaData.fdList.fdTimeSpan = fdTimeSpan
% 
%                     % something like this? can't convert double to cell though so issues
%                     metaData.fdList = [fdName fdFilename fdTimeSpan];
% 
%                      % load all contents of this file
%         currentFile = load( fullfile( currentPathToData, currentPathToData(fd) ) );

            