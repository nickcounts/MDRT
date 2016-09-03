%% metaData flags
% check boolean values of flags for isOperation, isVehicleOp,
% isMARSprocedure, hasMARSuid

% input is given from GUI
% if true, output dataToSearch structure for that true value

% switch case statement for each flag?

% searchMetaDataFlag

%% NICKKKKKKKK
% possibility: adding elseif statement to return search results for false
% input?

% how to get these to work in combination with each other?
% i.e. multiple inputs (isOperation == 1 and isMARSuid == 1)

% possible better way to do this: there are 4 metadata flags, can I run
% search based on every combination of true/false values for these 4 flags

% varargin: pair of metadata flag input and boolean value
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
    
%     for j = 1:numel(metaDataFlagFieldsToFilterBy)
%     
%         switch metaDataFlagFieldsToFilterBy{j}
% 
%             case 'isOperation'

                if dataToSearch(i).metaData.isOperation == metaDataFlagFieldAndBooleanInputStructure.isOperation ...
                        && dataToSearch(i).metaData.isVehicleOp == metaDataFlagFieldAndBooleanInputStructure.isVehicleOp ...
                        && dataToSearch(i).metaData.isMARSprocedure == metaDataFlagFieldAndBooleanInputStructure.isMARSprocedure ...
                        && dataToSearch(i).metaData.hasMARSuid == metaDataFlagFieldAndBooleanInputStructure.hasMARSuid

                        % populate metaData field
                        tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                        % populate pathToData field
                        tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                        % TODO: populate matchingFDlist field
                        tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;

                        % append temporary searchResult structure to searchResults
                        metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

    %             % or just else?
    %             % do we actually want this to happen?
    %             elseif metaDataFlagBooleanInput == false && dataToSearch(i).metaData.isVehicleOp == 0

%                 end


        %    case 'isVehicleOp'
% 
%         elseif dataToSearch(i).metaData.isVehicleOp == metaDataFlagFieldAndBooleanInputStructure.isVehicleOp
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
%                         tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);


%                 end


%             case 'isMARSprocedure'

%                 elseif dataToSearch(i).metaData.isMARSprocedure == metaDataFlagFieldAndBooleanInputStructure.isMARSprocedure
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
%                         tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);

%                 end


%             case 'hasMARSuid'
% 
%                 elseif dataToSearch(i).metaData.hasMARSuid == metaDataFlagFieldAndBooleanInputStructure.hasMARSuid
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
%                         tempMetaDataFlagSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
% 
%                 end

%             otherwise

%                 foundDataToSearch = dataToSearch;
    
%         end
        
%     end
    
                end
end
end



% =========================================================================
% in case everything breaks:
% 
% for i = 1:length(dataToSearch)
% 
%         switch metaDataFlagInput
% 
%             case 'isOperation'
% 
%                 if dataToSearch(i).metaData.isOperation == metaDataFlagBooleanInput
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
% 
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
% 
%     %             % or just else?
%     %             % do we actually want this to happen?
%     %             elseif metaDataFlagBooleanInput == false && dataToSearch(i).metaData.isVehicleOp == 0
% 
%                 end
% 
% 
%             case 'isVehicleOp'
% 
%                 if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.isVehicleOp == 1
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
% 
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
% 
% 
%                 end
% 
% 
%             case 'isMARSprocedure'
% 
%                 if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.isMARSprocedure == 1
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
% 
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
% 
%                 end
% 
% 
%             case 'hasMARSuid'
% 
%                 if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.hasMARSuid == 1
% 
%                         % populate metaData field
%                         tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                         % populate pathToData field
%                         tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                         % TODO: populate matchingFDlist field
% 
% 
%                         % append temporary searchResult structure to searchResults
%                         metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
% 
%                 end
% 
%             otherwise
% 
%                 foundDataToSearch = dataToSearch;
%     
%         end
%         
%     end