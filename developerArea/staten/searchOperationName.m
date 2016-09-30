function [foundDataToSearch] = searchOperationName( searchExpression )
%% searchOperationName
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
%
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


% set file path
dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; 

% load variables from dataToSearch file
load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') );

% empty cell array of structures - will hold found data matches
foundDataToSearch = []; 

% searchToks = {'RP1';'Tur'};
searchToks = strsplit(searchExpression);

    % remove stray whitespace
    searchToks = strtrim(searchToks);
    searchToks(strcmp('',searchToks)) = [];

    % start with empty match index variable
    ind = [];
    
    % manipulate input search expression to be case insensitive,
    % and ignore non-letter/number characters
    newSearchExpression = regexprep( lower(searchToks), '\W', '', 'ignorecase' );

    % initialize boolean as true
    booleanNoMatch = true;

% index over length of dataToSearch file
for i = 1:length(dataToSearch);

	% set temporary variable to operation name in each metadata structure
    tempOpName = dataToSearch(i).metaData.operationName;
    
    % manipulate metadata operation name to be case insensitive,
    % and ignore non-letter/number characters
    newOperationName = regexprep( lower(tempOpName), '\s*\W', '', 'ignorecase' );
    
        % create an index of matches for each token
        for j = 1:numel(newSearchExpression);
           
            % check if match between searchToks and operation names inmetadata
            if cellfun(@(x)( ~isempty(x) ), regexpi({newOperationName}, newSearchExpression{j}));

                % create temporary searchResult structure:

                    % populate metaData field
                    tempFoundDataToSearch.metaData = dataToSearch(i).metaData;

                    % populate pathToData field
                    tempFoundDataToSearch.pathToData = dataToSearch(i).pathToData;

                    % TODO: populate matchingFDlist field (right now this is
                    % only taking the fdList from the existing metadata
                    % structure; this may later contain only the fds within the time search)
                    tempFoundDataToSearch.matchingFDList = dataToSearch(i).metaData.fdList;
              
                % if foundDataToSearch contains a file
                if isstruct(foundDataToSearch);
                     
                    % for each file in foundDataToSearch
                    for k = 1:length(foundDataToSearch)

                        % if file does not already exist in foundDataToSearch
                        if ~strcmp(foundDataToSearch(k).metaData.operationName, tempFoundDataToSearch.metaData.operationName);
                            
                            % there is no match
                            booleanNoMatch = booleanNoMatch*true;
                            
                        else
                            
                            % this is a match; don't add same file again
                            booleanNoMatch = booleanNoMatch*false;

                        end % end if loop checking if output already contains temp file
                        
                    end % for loop iterating over foundDataToSearch
                    
                    % if there is no match to current foundDataToSearch list
                    if booleanNoMatch

                        % append temporary searchResult structure to searchResults
                        foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);

                    end % end if loop checking if no match for any existing file in foundDataToSearch

                else % else add files

                % append temporary searchResult structure to searchResults
                foundDataToSearch = vertcat(foundDataToSearch, tempFoundDataToSearch);

                end % if loop checking foundDataToSearch for files

            end % if loop checking for searchToks matches
            
        end % end for loop iterating over each searchToks

end % end for loop iterating over dataToSearchFiles

end % function searchOperationName