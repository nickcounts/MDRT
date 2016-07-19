function [foundDataToSearch] = searchTimeStamp( timeStamp )
%% one way to search through dataIndexForSearching (by timespan)


% datareturn loops through existing data and returns only the meta data
% structures (containing the fds) existing over the given timestamp array

% timestamp = array of either 1 or 2 local time/date values


% call localToUTC function to convert local time/date information to UTC

% numtimestamp = localtoUTC(timestamp);
% ^unnecessary - Paige will be passing numerical timestamp as input from
% GUI

% check length of array
% case 1: iterate over single 24 hour time period
% case 2: iterate over duration of time period

% timelength = length(timestamp);
% 
%     switch length(numtimestamp)
%         case 1
%             for duration(numtimestamp)
%                 return newMetaDataStructure(duration(numtimestamp))
%         case 2
%             for i = numtimestamp(1):numtimestamp(2)
%                 return newMetaDataStructure(i)
%                     
%     end
	
%% above is good for a single instance, but need this to look at dataIndexForSearching, which will return a file in data archive folder to be searched

% ========================================================================

% timelength = length(timestamp);
% 
%     switch length(timestamp)
%         case 1 % need this to read 24 hour timespan
%             for duration(timestamp) 
%                 return foundFilePaths(duration(numtimestamp))
%         case 2
%             for i = timestamp(1):timestamp(2)
%                 return foundFilePaths(i)
%                     
%     end

% =========================================================================

% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch
% 
% timeSpanInput = length( timeStamp ); % is input 1 or 2 values?
% 
% for i = 1:length(dataToSearch) % index dataToSearch for every structure
%     
%     timeSpan = dataToSearch(i).metaData.timeSpan
%     % ^ can I do this to clean up the code?/ does this work the way I think
%     % it will or will I end up writing over the existing file on accident
%     
%     switch timeSpanInput
%         
%         case 1 % input is 1 value, iterate over 24 hour single day period
%             % this does not work WHY WON'T THIS WORK
%             % I don't think duration does what I think it does/ want it to
%             % do... better matlab function for this?
%             %DURATION IS POO USE INBETWEEN
%             singleDay = duration(timeSpanInput) % sets 24 hour period to iterate over
%             
%             % index to iterate over the metaData timeSpan
%             for j = dataToSearch(i).metaData.timeSpan(1):dataToSearch(i).metaData.timeSpan(2)
%                 % if the 24 hour single day period occurs within a metaData
%                 % timeSpan
%                 if timestamp == dataToSearch(i).metaData.timeSpan(j)
%                 
%                     % return those dataToSearch structures
%                     dataToSearch
%                     break
%                 end
%             end
%             
%                     % also return list of fds over this timespan?
%             
%         case 2 % input is 2 values, iterate over period between 2 days given
%             
%             % index to iterate over the metaData timeSpan 
%             for j = dataToSearch(i).metaData.timeSpan(1):dataToSearch(i).metaData.timeSpan(2)
%                 
%                 % index to iterate over the timeSpanInput given by the GUI
%                 for k = duration( timeSpanInput(1) ):duration( timeSpanInput(2) )
%                     
%                     % if the timeSpanInput given by the GUI is contained
%                     % within OR overlapping ( <- did I accomodate for this?)
%                     if duration( timeSpanInput(k) ) == dataToSearch(i).metaData.timeSpan(j)
%                         
%                         % return those dataToSearch structures
%                         dataToSearch
%                         break
%                     end
%                 end
%             end
%             
%                         % also return list of fds over this timespan?
%     end
% end
% end

% ========================================================================

% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch
% 
% timeSpanInput = length( timeStamp ); % is input 1 or 2 values?
% 
% foundDataToSearch = {}; % empty cell array of structures - will hold list
% 
% 
% for i = 1:length(dataToSearch)
%         
%         
%     switch timeSpanInput
% 
%         case 1 % input is 1 value, iterate over 24 hour single day period
% 
%             timeStampIsValid = isbetween( timeStamp, datetime( dataToSearch(i).metaData.timeSpan(1), 'ConvertFrom', 'datenum' ), datetime( dataToSearch(i).metaData.timeSpan(2), 'ConvertFrom', 'datenum' ) )
%             
%             timeStampIsValid
%             
%             if timeStampIsValid == 1
% 
%                 foundDataToSearch{length(foundDataToSearch)+1} = dataToSearch(i);
%             end
%    
%         case 2 % input is 2 values, iterate over period between 2 days given
% 
% 
%     end
% end
% end


% ========================================================================4


dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path

load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch


timeSpanInput = length( timeStamp ); % is input 1 or 2 values?

foundDataToSearch = newSearchResult; % empty cell array of structures from Paige - will hold list

% 
%keyboard

for i = 1:length(dataToSearch)

    switch timeSpanInput

        case 1 % input is 1 value, iterate over 24 hour single day period

            timeStamp(2) = timeStamp(1) + 1; % creates a second timestamp input
            
            if timeStamp(1) >= dataToSearch(i).metaData.timeSpan(1) && timeStamp(2) <= dataToSearch(i).metaData.timeSpan(2)

                % foundDataToSearch{length(foundDataToSearch)+1} = dataToSearch(i);
               
                foundDataToSearch.metaData = dataToSearch(i).metaData;
                foundDataToSearch.pathToData = dataToSearch(i).pathToData;
                
                i = i + 1;
                
            end

        case 2 % input is 2 values, iterate over period between 2 days given
            if timeStamp(1) >= dataToSearch(i).metaData.timeSpan(1)
                foundDataToSearch.metaData = dataToSearch(i).metaData;
                foundDataToSearch.pathToData = dataToSearch(i).pathToData;
            elseif timeStamp(2) <= dataToSearch(i).metaData.timeSpan(2)
                % foundDataToSearch{length(foundDataToSearch)+1} = dataToSearch(i);
     
                foundDataToSearch.metaData = dataToSearch(i).metaData;
                foundDataToSearch.pathToData = dataToSearch(i).pathToData;
                
                i = i + 1;
            end
           
        otherwise 
            disp('not working....')
    end
end
end

    
    
%% subfunctions?
% function timeStampIsValid = isTimeStampValid( timestamp )

    % timeStampIsValid returns boolean value (true or false)
    % timeStampIsValid if function returns 1 (true)
    
    

    
    
    
    

    
    
    
