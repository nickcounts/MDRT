function newSearchResult
% a structure that is outputted from statenSearch, returns search result of
% fd list, path to the data, and related metaData

searchResult = struct;

searchResult.metaData = []; % [1x1] struct of metaData
searchResult.pathToData = []; % string containing path to data
searchResult.matchingFDList = []; % cell array of strings containing
                                  % ('file string', 'filename.ext')

end

