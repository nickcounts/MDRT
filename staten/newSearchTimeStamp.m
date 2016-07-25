function [foundDataToSearch] = newSearchTimeStamp( timeStamp )

dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path

load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch


timeSpanInput = length( timeStamp ); % is input 1 or 2 values?

foundDataToSearch = []; % empty cell array of structures from Paige - will hold list

% 
%keyboard

for i = 1:length(dataToSearch)

    switch timeSpanInput

        case 1 % input is 1 value, iterate over 24 hour single day period

            timeStamp(2) = timeStamp(1) + 1; % creates a second timestamp input

            if isTimeStampWithinRange( dataToSearch(i).metaData.timeSpan, timeStamp )
                
                % create temporary searchResult structure:
                
                % populate metaData field
                tempFoundDataToSearch.metaData = dataToSearch(i).metaData;
                
                % populate pathToData field
                tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;
                
                % TODO: populate matchingFDlist field
                tempFoundDataToSearch.fdList = dataToSearch(i).metaData.fdList;
                
                % append temporary searchResult structure to searchResults
                foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);
               
            end
            
        case 2 % input is 2 values, iterate over period between 2 days given
          
            if isTimeStampWithinRange( dataToSearch(i).metaData.timeSpan, timeStamp )
            
                % create temporary searchResult structure:
                
                % populate metaData field
                tempFoundDataToSearch.metaData = dataToSearch(i).metaData;
                
                % populate pathToData field
                tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;
                
                % TODO: populate matchingFDlist field
                tempFoundDataToSearch.fdList = dataToSearch(i).metaData.fdList;
                
                % append temporary searchResult structure to searchResults
                foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);
               
            end
            
        otherwise 
            foundDataToSearch = dataToSearch;
               
            
    end
 
    
end


end
    
    
%% subfunctions
% returns 1/0 (true/false)value for each timespan check

% timeStampIsWithinRange returns boolean value (true or false)
% timeStampIsWithinRange if function returns 1 (true)
function timeStampIsWithinRange = isTimeStampWithinRange( timeExisting, timeInput )

% if the input range of timestamps is entirely within the metadata timespan
if timeInput(1) >= timeExisting(1) && timeInput(2) <= timeExisting(2)
    timeStampIsWithinRange = true;

% else if the first input timestamp is outside of metadata
% timespan AND the second input timestamp is within the
% metadata timespan
elseif timeInput(1) < timeExisting(1) && ( timeInput(2) >= timeExisting(1) && timeInput(2) <= timeExisting(2) )
    timeStampIsWithinRange = true;
                
% else if the second input timestamp is outside of metadata
% timespan AND the first input timestamp is within the
% metadata timespan
elseif timeInput(2) > timeExisting(2) && ( timeInput(1) >= timeExisting(1) && timeInput(1) <= timeExisting(2) )
    timeStampIsWithinRange = true;
   
% else if the metadata timespan is within the input timestamp
elseif timeInput(1) < timeExisting(1) && timeInput(2) > timeExisting(2)
    timeStampIsWithinRange = true;
     
else
	% no matches, return false
    timeStampIsWithinRange = false;
    
end


end



