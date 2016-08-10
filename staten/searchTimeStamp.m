function [foundDataToSearch] = searchTimeStamp( timeStamp )
%% searchTimeStamp()
%
% Purpose: Provides a means of searching through dataToSearch file by 
% timestamp input of a single day or a span of time.
%
% Function input timeStamp takes 1 or 2 numerical calendar day values. 
%
% Function output foundDataToSearch is every structure within dataToSearch
% that matches timestamp input appended to include metadata fd list.
%
% Example output:
%       foundDataToSearch =
%
%                           metaData: [1x1 struct]
%                         pathToData: 'C:\Users\Staten\Deskt…'
%                     matchingFDList: {289x2 cell}
%
% Subfunctions:
%     isTimeStampWithinRange - checks if time stamp input is within range of existing timespan found in metadata files of dataToSearch
%     dateWarningDialog displays warning message: "No data found within this time range."
%     metaDataWarningDialog displays warning message: "No time span found to compare with input."
%
% Supporting functions:
%     dataIndexer - parses through metadata files in current data repository
%     dataIndexForSearching - creates dataToSearch file of all metadata files found and places file in data repository
%
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


% set file path
dataRepositoryDirectory = 'C:\Users\Paige\Documents\MARS Matlab\Data Repository'; 

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