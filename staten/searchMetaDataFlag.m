function [metaDataFlagSearchResults] = searchMetaDataFlag( foundDataToSearch, metaDataFlagFieldAndBooleanInputStructure )
%% searchMetaDataFlag()
%
% Purpose: Provide a means of AND searching through dataToSearch file by 
% metadata flag inputs.
%
% Function input (foundDataToSearch, metaDataFlagFieldAndBooleanInputStructure)
% takes a set of dataToSearch structures and a structure of metadata flags
% and their boolean values from the user.
%
% Function output metaDataFlagSearchResults creates a new list of
% dataToSearch structures for structures with all matching metadata flags
% (AND searching).
%
% Example output:
%           metaDataFlagSearchResults =
%
%                           metaData: [1x1 struct]
%                         pathToData: 'C:\Users\Staten\Deskt…'
%                     matchingFDList: {289x2 cell}
%
% Supporting functions: 
%    searchTimeStamp - narrows search results by time parameters
%
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


% empty cell array of structures - will hold found data matches
metaDataFlagSearchResults = [];

% create cell array of strings of fieldnames in input structure
metaDataFlagFieldsToFilterBy = fieldnames(metaDataFlagFieldAndBooleanInputStructure);

% index over each structure in foundDataToSearch
for i = 1:length(foundDataToSearch)
    
    % index over each metadata flag fieldnames
    for j = 1:numel(metaDataFlagFieldsToFilterBy)
    
        % switch/case statement to accomodate searching through every metadata flag fieldname
        switch metaDataFlagFieldsToFilterBy{j}
        
        % if strcmp(metaDataFlagFieldsToFilterBy{j}, 'isOperation')
 
            case 'isOperation' % metadata flag input = 'isOperation'

                % if the metadata flag value in dataToSearch matches the metadata flap input value
                if foundDataToSearch(i).metaData.isOperation == metaDataFlagFieldAndBooleanInputStructure.isOperation

                    % create a temporary boolean value to set to true
                    tempBoolean = true;

                end % end if loop checking for match
          
         % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'isVehicleOp')
         
            case 'isVehicleOp' % metadata flag input = 'isVehicleOp'

                % if the metadata flag value in dataToSearch matches the metadata flap input value
                if foundDataToSearch(i).metaData.isVehicleOp == metaDataFlagFieldAndBooleanInputStructure.isVehicleOp

                    % keep tempBoolean true
                    tempBoolean = tempBoolean * true;

                else % no match
                    
                    % set tempBoolean to false
                    tempBoolean = tempBoolean * false;

                end % end if loop checking for match
                
        % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'isMARSprocedure')
        
            case 'isMARSprocedure' % metadata flag input = 'isMARSprocedure'

                % if the metadata flag value in dataToSearch matches the metadata flap input value
                if foundDataToSearch(i).metaData.isMARSprocedure == metaDataFlagFieldAndBooleanInputStructure.isMARSprocedure

                    % keep tempBoolean true
                	tempBoolean = tempBoolean * true;
                        
                else % no match
                    
                    % set tempBoolean to false
                    tempBoolean = tempBoolean * false;
                
                end % end if loop checking for match
                
        % elseif strcmp(metaDataFlagFieldsToFilterBy{j}, 'hasMARSuid')
        
            case 'hasMARSuid' % metadata flag input = 'hasMARSuid'

                % if the metadata flag value in dataToSearch matches the metadata flap input value
                if foundDataToSearch(i).metaData.hasMARSuid == metaDataFlagFieldAndBooleanInputStructure.hasMARSuid
                    
                    % keep tempBoolean true
                    tempBoolean = tempBoolean * true;
                        
                else % no match
                    
                    % set tempBoolean to false
                    tempBoolean = tempBoolean * false;
                
                end % end if loop checking for match
                
            otherwise % no metadata flag input
                
                % return all dataToSearch
                metaDataFlagSearchResults = foundDataToSearch;
                
        end % end switch/case statement
        
    end % end for loop iterating over fieldnames

    
    % if tempBoolean value returns true (1)
    if tempBoolean

        % populate metaData field
        tempMetaDataFlagSearchResults.metaData = foundDataToSearch(i).metaData;

        % populate pathToData field
        tempMetaDataFlagSearchResults.pathToData = foundDataToSearch(i).pathToData;

        % TODO: populate matchingFDlist field
        tempMetaDataFlagSearchResults.matchingFDList = foundDataToSearch(i).metaData.fdList;

        % append temporary searchResult structure to searchResults
        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
        
    else % no metadata flag matches
        
        metaDataFlagSearchResults = 'No data found that matches all search criteria input. Please try again.'
        

    end % end if loop checking tempBoolean

         
end % end for loop iterating over dataToSearch structures

end % endFunctionMetaDataFlag

% =========================================================================
% garbage


% what if: set up 4x1 structure of each flag as empty cell to be filled with true/false
% input from Paige and compared to true/false values in metadata
% iterate over each possible combination of these 4 values 
% if all 4 are false, return all output
% return based on all different combinations of output?
