function [foundDataToSearch] = searchOperationName( searchExpression )
%% searchOperationName


% set file path
dataRepositoryDirectory = 'C:\Users\Paige\Documents\MARS Matlab\Data Repository'; 

% load variables from dataToSearch file
load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') );


% empty cell array of structures - will hold found data matches
foundDataToSearch = []; 

% manipulate input search expression to be case insensitive,
% and ignore all spaces (concatenate characters) and non-letter/number characters
newSearchExpression = regexprep( lower(searchExpression), '\s*\W', '', 'ignorecase' );


% index over length of dataToSearch file
for i = 1:length(dataToSearch)

	% set temporary variable to operation name in each metadata structure
    tempOpName = dataToSearch(i).metaData.operationName;
    
    % manipulate metadata operation name to be case insensitive,
	% and ignore all spaces (concatenate characters) and non-letter/number characters
    newOperationName= regexprep( lower(tempOpName), '\s*\W', '', 'ignorecase' );

    % if operation name matches search expression (OR accounts for whichever is the longer string value)
    if ~isempty( regexpi( newOperationName, newSearchExpression ) ) || ~isempty( regexpi( newSearchExpression, newOperationName ) )
  
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
            
    end % end if loop
    
end % end for loop iterating over dataToSearchFiles

end % function searchOperationName




% =========================================================================
% poo

% index over the input string for each character
% for character = 1:length(searchExpression)
%     
%     % manipulate input search expression to be case insensitive,
%     % and ignore all spaces (concatenate characters) and non-letter/number characters
%     if regexpi(dataToSearch(5).metaData.operationName(character), '\s', '') ...
%             || regexpi(dataToSearch(5).metaData.operationName(character), '\W')
%         
%         horzcat(regexprep(dataToSearch(5).metaData.operationName(character), '\s', '', 'ignorecase'))
%     
%     newSearchExpression = regexprep( searchExpression, 'RP(\W+)1', 'RP1', 'ignorecase' )
% 
%  for character = 1:length(dataToSearch(5).metaData.operationName)
%         regexpi(dataToSearch(5).metaData.operationName(character), '\s')
%         regexpi(dataToSearch(5).metaData.operationName(character), '\W')
%     end

%=========================================================================

