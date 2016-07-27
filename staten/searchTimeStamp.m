function [foundDataToSearch] = searchTimeStamp( timeStamp )
%% searchTimeStamp()

% Purpose: Provides a means of searching through dataToSearch file by 
% timestamp input of a single day or a span of time.

% Function input timeStamp takes 1 or 2 numerical calendar day values. 

% Function output foundDataToSearch is every structure within dataToSearch
% that matches timestamp input appended to include metadata fd list.

% Example output:
%       foundDataToSearch =

%                           metaData: [1x1 struct]
%                         pathToData: 'C:\Users\Staten\Deskt…'
%                     matchingFDList: {289x2 cell}

% Subfunctions:
%     isTimeStampWithinRange - checks if time stamp input is within range of existing timespan found in metadata files of dataToSearch
%     dateWarningDialog displays warning message: "No data found within this time range."
%     metaDataWarningDialog displays warning message: "No time span found to compare with input."

% Supporting functions:
%     dataIndexer - parses through metadata files in current data repository
%     dataIndexForSearching - creates dataToSearch file of all metadata files found and places file in data repository

% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


% set file path
dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; 

% load variables from dataToSearch file
load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') );


% checks length of input (is input 1 or 2 values?)
timeSpanInput = length( timeStamp ); 

% empty cell array of structures - will hold found data matches
foundDataToSearch = []; 

% index over length of dataToSearch file
for i = 1:length(dataToSearch)

    % switch/case statement to test if there are 1,2, or neither inputs
    switch timeSpanInput

        case 1 % input is 1 value, iterate over 24 hour single day period
            
            % create a second timestamp input
            timeStamp(2) = timeStamp(1) + 1; 

            % if dataToSearch file contains a timespan to compare input with
            if ~isempty( dataToSearch(i).metaData.timeSpan )
                
                % call subfunction: isTimeStampWithinRange
                % if time stamp input is within compared range in metadata
                if isTimeStampWithinRange( dataToSearch(i).metaData.timeSpan, timeStamp )
                
                    % create temporary searchResult structure:

                    % populate metaData field
                    tempFoundDataToSearch.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field (right now this is
                    % only taking the fdList from the existing metadata
                    % structure; this may later contain only the fds within the time search)
                    tempFoundDataToSearch.matchingFDList = dataToSearch(i).metaData.fdList;

                    % append temporary searchResult structure to searchResults
                    foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);
                    
                end % close second if loop, isTimeStampWithinRange
                
                
            else % timespan in metadata is empty and isTimeStampWithinRange
                 % cannot run because there is nothing to compare the input with
                
                 % call subfunction: metaDataWarningDialog
                 % display error message to user: "No time span found to compare with input."
                 metaDataWarningDialog
                
            end % close first if loop, does timespan exist in metadata
            
            
        case 2 % input is 2 values, iterate over period between 2 days given
            
            % if dataToSearch file contains a timespan to compare input with
            if ~isempty( dataToSearch(i).metaData.timeSpan )
                
                % call subfunction: isTimeStampWithinRange
                % if time stamp input is within compared range in metadata
                if isTimeStampWithinRange( dataToSearch(i).metaData.timeSpan, timeStamp )
                
                    % create temporary searchResult structure:

                    % populate metaData field
                    tempFoundDataToSearch.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field (right now this is
                    % only taking the fdList from the existing metadata
                    % structure; this may later contain only the fds within the time search)
                    tempFoundDataToSearch.matchingFDList = dataToSearch(i).metaData.fdList;

                    % append temporary searchResult structure to searchResults
                    foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);
                    
                end % close second if loop, isTimeStampWithinRange
                  
                
            else % timespan in metadata is empty and isTimeStampWithinRange
                 % cannot run because there is nothing to compare the input with
                
                 % call subfunction: metaDataWarningDialog
                 % display error message to user: "No time span found to compare with input."
                 metaDataWarningDialog
               
            end % close first if loop, does timespan exist in metadata
            
            
        otherwise % otherwise no input was given
            
            % return all dataToSearch with fd list
            
            % create temporary searchResult structure:

                % populate metaData field
                tempFoundDataToSearch.metaData = dataToSearch(i).metaData;

                % populate pathToData field
                tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;

                % TODO: populate matchingFDlist field (right now this is
                % only taking the fdList from the existing metadata
                % structure; this may later contain only the fds within the time search)
                tempFoundDataToSearch.matchingFDList = dataToSearch(i).metaData.fdList;

                % append temporary searchResult structure to searchResults
                foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);
     
    end % end timeSpanInput switch/case statement
    
end % end for loop iterating over dataToSearch structures


% if no data is found over timestamp input
if isempty(foundDataToSearch)
    
    % call subfunction: dateWarningDialog
    % display error message to user: "No data found within this time range."
    dateWarningDialog
    
end % end if loop checking if foundDataToSearch is empty

    
end % end function searchTimeStamp
    

% =========================================================================

%% Subfunctions:

% -------------------------------------------------------------------------
% Function:
    % isTimeStampWithinRange compares input timestamp values to the
    % existing timespans found in the metadata structures of the 
    % dataToSearch file
    
% Input:
    % timeExisting is the timespan existing in the metadata structures of
    % the dataToSearch file (dataToSearch.metaData.timeSpan)
    % timeInput is the user input timestamps provided in the
    % main function searchTimeStamp
    
% Output: 
    % timeStampIsWithinRange returns boolean value (true/1 if timeInput is
    % within range of timeExisting, or false/0) if timeInput is outside of
    % range of timeExisting
    
function timeStampIsWithinRange = isTimeStampWithinRange( timeExisting, timeInput )

% if the input range of timestamps is entirely within the metadata timespan
if timeInput(1) >= timeExisting(1) && timeInput(2) <= timeExisting(2)
    
    % return true
    timeStampIsWithinRange = true;

% else if the first input timestamp is outside of metadata timespan
% AND the second input timestamp is within the metadata timespan
elseif timeInput(1) < timeExisting(1) && ( timeInput(2) >= timeExisting(1) && timeInput(2) <= timeExisting(2) )
    
    % return true
    timeStampIsWithinRange = true;
                
% else if the second input timestamp is outside of metadata timespan
% AND the first input timestamp is within the metadata timespan
elseif timeInput(2) > timeExisting(2) && ( timeInput(1) >= timeExisting(1) && timeInput(1) <= timeExisting(2) )
    
    % return true
    timeStampIsWithinRange = true;
   
% else if the metadata timespan is entirely within the input timestamp
elseif timeInput(1) < timeExisting(1) && timeInput(2) > timeExisting(2)
    
    % return ture
    timeStampIsWithinRange = true;
     
else % no matches
    
    % return false
    timeStampIsWithinRange = false;
    
end % end if loop testing all possible timespan match outcomes

end % end function isTimeStampWithinRange


% -------------------------------------------------------------------------
% Function:
    % dateWarningDialog displays warning message:
    % "No data found within this time range."

function dateWarningDialog
    d = dialog('Position',[300 300 250 150],'Name','WARNING');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','No data found within this time range.');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');


end


% -------------------------------------------------------------------------
% Function:
    % metaDataWarningDialog displays warning message:
    % "No time span found to compare with input."

function metaDataWarningDialog
    d = dialog('Position',[300 300 250 150],'Name','WARNING');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','No time span found to compare with input.');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');


end

% -------------------------------------------------------------------------    
   
% =========================================================================
% garbage stuff:

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
%% This is good stuff

% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch
% 
% 
% timeSpanInput = length( timeStampInput ); % is input 1 or 2 values?
% 
% foundDataToSearch = []; % empty cell array of structures from Paige - will hold list
% 
% % 
% %keyboard
% 
% for i = 1:length(dataToSearch)
% 
%     switch timeSpanInput
% 
%         case 1 % input is 1 value, iterate over 24 hour single day period
% 
%             timeStampInput(2) = timeStampInput(1) + 1; % creates a second timestamp input
% %            keyboard
% 
%             % if the input range of timestamps is entirely within the metadata timespan
%             if timeStampInput(1) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) <= dataToSearch(i).metaData.timeSpan(2)
% 
%                 % foundDataToSearch{length(foundDataToSearch)+1} = dataToSearch(i);
%                
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 1')
% 
%             % else if the first input timestamp is outside of metadata
%             % timespan AND the second input timestamp is within the
%             % metadata timespan
%             elseif timeStampInput(1) < dataToSearch(i).metaData.timeSpan(1) && ( timeStampInput(2) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) <= dataToSearch(i).metaData.timeSpan(2) )
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 2')
% 
%             % else if the second input timestamp is outside of metadata
%             % timespan AND the first input timestamp is within the
%             % metadata timespan
%             elseif timeStampInput(2) > dataToSearch(i).metaData.timeSpan(2) && ( timeStampInput(1) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(1) <= dataToSearch(i).metaData.timeSpan(2) )
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 3')
% 
%             % else if the metadata timespan is within the input timestamp
%             elseif timeStampInput(1) < dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) > dataToSearch(i).metaData.timeSpan(2)
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
%             
%             else
%                 disp('no matches')
%                 
%                 %check if structure is empty
%                 % emptyStructure = arrayfun(@(s) isempty(s.metaData) & isempty(s.pathToData), foundDataToSearch);
%                 
%                 % remove empty structures
%                 % foundDataToSearch(emptyStructure) = [];
%             
%             end
% 
%         case 2 % input is 2 values, iterate over period between 2 days given
%           
%             if timeStampInput(1) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) <= dataToSearch(i).metaData.timeSpan(2)
% 
%                 % foundDataToSearch{length(foundDataToSearch)+1} = dataToSearch(i);
%                
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 1')
%             elseif timeStampInput(1) < dataToSearch(i).metaData.timeSpan(1) && ( timeStampInput(2) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) <= dataToSearch(i).metaData.timeSpan(2) )
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 2')
%             elseif timeStampInput(2) > dataToSearch(i).metaData.timeSpan(2) && ( timeStampInput(1) >= dataToSearch(i).metaData.timeSpan(1) && timeStampInput(1) <= dataToSearch(i).metaData.timeSpan(2) )
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
% %                 display('if 3')
%             elseif timeStampInput(1) < dataToSearch(i).metaData.timeSpan(1) && timeStampInput(2) > dataToSearch(i).metaData.timeSpan(2)
%                 
%                 foundDataToSearch(i).metaData = dataToSearch(i).metaData;
%                 foundDataToSearch(i).pathToData = dataToSearch(i).pathToData;
%                 
%             else
%                 disp('no matches')
%                 
%                 %check if structure is empty
%                 emptyStructure = arrayfun(@(s) isempty(s.metaData) & isempty(s.pathToData), foundDataToSearch);
%                 
%                 % remove empty structures
%                 foundDataToSearch(emptyStructure) = [];
%                 
%                 %indices = find(foundDataToSearch(i).pathToData == []);
%                 %foundDataToSearch(indices,:) = [];
%                
%             end
%             
%         otherwise 
%             disp('not working....')
%                
%             
%     end
%  
%     
% end
% 
% keyboard
% 
% 
% 
% end

% ========================================================================
    
    
    
    

    
    
    
