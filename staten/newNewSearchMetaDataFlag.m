function [metaDataFlagSearchResults] = searchMetaDataFlag( metaDataFlagFieldAndBooleanInputStructure,handles )
% 
% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch

metaDataFlagSearchResults = [];


% what if: set up 4x1 structure of each flag as empty cell to be filled with true/false
% input from Paige and compared to true/false values in metadata
% iterate over each possible combination of these 4 values 
% if all 4 are false, return all output
% return based on all different combinations of output?

metaDataFlagFieldsToFilterBy = fieldnames(metaDataFlagFieldAndBooleanInputStructure);

dataToSearch = handles.searchResult;
keyboard
for i = 1:length(dataToSearch)
    
    for j = 1:numel(metaDataFlagFieldsToFilterBy)
    
        switch metaDataFlagFieldsToFilterBy{j}
        
        % if strcmp(metaDataFlagFieldsToFilterBy{j}, 'isOperation')
 
            case 'isOperation' % metadata flag input = 'isOperation'

                % if the metadata flag value in dataToSearch matches the metadata flap input value
                if dataToSearch(i).metaData.isOperation == metaDataFlagFieldAndBooleanInputStructure.isOperation

                    % create a temporary boolean value to set to true
                    tempBoolean = true;

                end % end if loop checking for match
          
                
         % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'isVehicleOp')
         
            case 'isVehicleOp' % metadata flag input = 'isVehicleOp'

                if dataToSearch(i).metaData.isVehicleOp == metaDataFlagFieldAndBooleanInputStructure.isVehicleOp

                    tempBoolean = tempBoolean * true;

                else
                    tempBoolean = tempBoolean * false;

                end % end if loop checking for match
                
                
        % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'isMARSprocedure')
        
            case 'isMARSprocedure' % metadata flag input = 'isMARSprocedure'

                if dataToSearch(i).metaData.isMARSprocedure == metaDataFlagFieldAndBooleanInputStructure.isMARSprocedure

                	tempBoolean = tempBoolean * true;
                        
                else
                    tempBoolean = tempBoolean * false;
                
                end % end if loop checking for match
                
                
        % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'hasMARSuid')
        
            case 'hasMARSuid' % metadata flag input = 'hasMARSuid'

                if dataToSearch(i).metaData.hasMARSuid == metaDataFlagFieldAndBooleanInputStructure.hasMARSuid
                    tempBoolean = tempBoolean * true;
                        
                else
                    tempBoolean = tempBoolean * false;
                
                end % end if loop checking for match
                
                
            otherwise % no metadata flag input
                
                % return all dataToSearch
                foundDataToSearch = dataToSearch;
                
        end % end switch/case statement
        
    end % end for loop iterating over fieldnames

    % if tempBoolean value returns true (1)
    if tempBoolean

        % populate metaData field
        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

        % populate pathToData field
        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

        % TODO: populate matchingFDlist field
        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

        % append temporary searchResult structure to searchResults
        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

    end % end if loop checking tempBoolean

         
end % end for loop iterating over dataToSearch structures

end % endFunctionMetaDataFlag
