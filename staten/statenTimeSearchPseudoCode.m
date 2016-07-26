
% make an empty variable searchResults

searchResults = [];

for loop through each metaData structure


    if thisDataSetContainsMatchingData
        
           make a temporary searchResult structure
           
               populate metaData field
               populate pathToData field
               populate matchingFDlist field
               
           append temporary searchResult structure to searchResults
           
    end
           

end loop



%% Subfunction to test for matching times

function trueOrFalse = thisDataSetContainsMatchingData ( thisDataSetTimeRange, searchTimeRange )

    Do all your tests here :)

end