% function to append temporary search results to final search results
function finalSearchResults = appendNewSearchResult( dataToSearch )

% finalSearchResults = cell(1,5);
finalSearchResults = [];

for i = 1:length( dataToSearch )
    
    % populate metaData field
    tempFinalSearchResults.metaData = dataToSearch(i).metaData;

    % populate pathToData field
    tempFinalSearchResults.pathToData = dataToSearch(i).pathToData;

    % TODO: populate matchingFDlist field (right now this is
    % only taking the fdList from the existing metadata
    % structure - redundant)
    tempFinalSearchResults.matchingFDList = dataToSearch(i).metaData.fdList;


    % append temporary searchResult structure to searchResults
    finalSearchResults = vertcat(finalSearchResults, tempFinalSearchResults);
    
    % finalSearchResults(i) = finalSearchResults + tempFinalSearchResults
    
end


end
