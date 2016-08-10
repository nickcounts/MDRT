function [metaDataFlagSearchResults] = searchMetaDataFlag( metaDataFlagFieldAndBooleanInputStructure )

dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path

load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch

metaDataFlagSearchResults = [];


% what if: set up 4x1 structure of each flag as empty cell to be filled with true/false
% input from Paige and compared to true/false values in metadata
% iterate over each possible combination of these 4 values 
% if all 4 are false, return all output
% return based on all different combinations of output?

metaDataFlagFieldsToFilterBy = fieldnames(metaDataFlagFieldAndBooleanInputStructure);


for i = 1:length(dataToSearch)
    
    for j = 1:numel(metaDataFlagFieldsToFilterBy)
    
        switch metaDataFlagFieldsToFilterBy{j}

            case 'isOperation'

                if dataToSearch(i).metaData.isOperation == metaDataFlagFieldAndBooleanInputStructure.isOperation

                        % populate metaData field
                        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                        % populate pathToData field
                        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                        % TODO: populate matchingFDlist field
                        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

                        % append temporary searchResult structure to searchResults
                        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

                end 
                
           case 'isVehicleOp'

                if dataToSearch(i).metaData.isVehicleOp == metaDataFlagFieldAndBooleanInputStructure.isVehicleOp

                        % populate metaData field
                        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                        % populate pathToData field
                        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                        % TODO: populate matchingFDlist field
                        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

                        % append temporary searchResult structure to searchResults
                        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

                end
                
            case 'isMARSprocedure'

                if dataToSearch(i).metaData.isMARSprocedure == metaDataFlagFieldAndBooleanInputStructure.isMARSprocedure

                        % populate metaData field
                        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                        % populate pathToData field
                        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                        % TODO: populate matchingFDlist field
                        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

                        % append temporary searchResult structure to searchResults
                        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

                end
                
            case 'hasMARSuid'

                if dataToSearch(i).metaData.hasMARSuid == metaDataFlagFieldAndBooleanInputStructure.hasMARSuid

                        % populate metaData field
                        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                        % populate pathToData field
                        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                        % TODO: populate matchingFDlist field
                        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

                        % append temporary searchResult structure to searchResults
                        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

                end

            otherwise

                foundDataToSearch = dataToSearch;
    
        end
        
    end
    
                end
end
