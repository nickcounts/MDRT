

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

function metaDataStructures = dataIndexer(dataRepositoryDirectory, searchExpression)

%% go into each folder in data repository

% dataRepositoryDirectory will be set to Data Repository path (this can be 
% changed to a different file path if want to look outside of data repository)

% search expression will be set to string value 'metadata'

dataRepositoryStructure = dir(dataRepositoryDirectory); % searches current directory and puts results in structures

metaDataStructures = {}; % empty < array of structures > to compile metadata files into

for i = 1:length(dataRepositoryStructure); % for loop to iterate over entire length of current directory
    
    % If the dataRepositoryStructure at this index does NOT have ._ then do
    % the normal work
    
    if isempty(strfind(dataRepositoryStructure(i).name, '._'))
    
        % if list length in repository structure is NOT in current directory/ NOT a folder, and if regular expression string (dataRepositoryStructure(lengthRepository).name) and searchExpression (metadata) do NOT match
        if ~dataRepositoryStructure(i).isdir && ~isempty(regexp(dataRepositoryStructure(i).name,searchExpression,'match'))  % look for a match that isn't a directory
              
            metaDataStructures{length(metaDataStructures)+1} = dataRepositoryStructure(i).name; % adds new metadata file to list of metaDataStructures
        
        % elseif list length in repository structure is in directory/ is a folder and string comparison is not in current folder or folder above
        elseif dataRepositoryStructure(i).isdir && ~strcmp(dataRepositoryStructure(i).name,'.') && ~strcmp(dataRepositoryStructure(i).name,'..') % if it is a directory (and not current or up a level), search in that (NICK PLZ EXPLAIN DIS)
        
            metaDataName = fullfile(dataRepositoryDirectory,dataRepositoryStructure(i).name); % creates full file name for metadata file
            metaDataStructuresTemp = dataIndexer(metaDataName,searchExpression);
        
            % if temporary metadata structures file is NOT empty
                % add it to the current list of metadata structures    
            if ~isempty(metaDataStructuresTemp)
            
                metaDataStructures((length(metaDataStructures)+1):(length(metaDataStructures)+length(metaDataStructuresTemp))) = metaDataStructuresTemp;
            
            end
        end
    end
end
end


% how do I have matlab point to the data repository folder and search expression for meta data (by string?)


%% within each individual data set folder, find metaData file






%% dataIndexForSearching will use this function to take each metaData file and compile into new list < array of structures >
%% search functions will need to look only within dataIndexForSearching with given search parameters and point to the location of file where desired data lives

