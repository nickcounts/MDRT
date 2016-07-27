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
function [metaDataFlagSearchResults] = searchMetaDataFlag( metaDataFlagInput, metaDataFlagBooleanInput )
% 
% dataRepositoryDirectory = 'C:\Users\Paige\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch

metaDataFlagSearchResults = [];


for i = 1:length(dataToSearch)

    switch metaDataFlagInput

        case 'isOperation'
            
            if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.isOperation == 1
                
                    % populate metaData field
                    tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field


                    % append temporary searchResult structure to searchResults
                    metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
            
%             % or just else?
%             % do we actually want this to happen?
%             elseif metaDataFlagBooleanInput == false && dataToSearch(i).metaData.isVehicleOp == 0
%                 
%                     % populate metaData field
%                     tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;
% 
%                     % populate pathToData field
%                     tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;
% 
%                     % TODO: populate matchingFDlist field
% 
% 
%                     % append temporary searchResult structure to searchResults
%                     metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
%                
%                     
            end
            
            
        case 'isVehicleOp'
            
            if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.isVehicleOp == 1
                
                    % populate metaData field
                    tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field


                    % append temporary searchResult structure to searchResults
                    metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
       
                    
            end
         
            
        case 'isMARSprocedure'
            
            if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.isMARSprocedure == 1
                
                    % populate metaData field
                    tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field


                    % append temporary searchResult structure to searchResults
                    metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
         
            end
            
            
        case 'hasMARSuid'
            
            if metaDataFlagBooleanInput == true && dataToSearch(i).metaData.hasMARSuid == 1
                
                    % populate metaData field
                    tempMetaDataFlagSearchResults.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempMetaDataFlagSearchResults.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field


                    % append temporary searchResult structure to searchResults
                    metaDataFlagSearchResults = vertcat(metaDataFlagSearchResults, tempMetaDataFlagSearchResults);
            
            end
            
        otherwise
            
            foundDataToSearch = dataToSearch;
            
            
    end
end
end
