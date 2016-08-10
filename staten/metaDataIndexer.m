function [] = metaDataIndexer()
%% metaDataIndexer()
% 
% Purpose: Checks existing data archive for metadata files and fixes 
% existing files to include all desired fields and values for fdList and 
% timeSpan, returning them back to their current locations.
%
% No function input or output requirements.
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