%% searchFunctionMain
function [searchResultsMain] = searchFunctionMain( varargin )

timeStamp = varargin{1};
metaDataFlagInput = varargin{2};
metaDataFlagBooleanInput = varargin{3};
% foundDataToSearchFDList = varargin{4};
% fdTypeInput = varargin{5};

% rolls all search functions into single function

% for i = 1:length(varargin)
switch nargin
    case 1

    % FIRST: search by time; if no time input, outputs entire dataToSearch file
    % sr1 = searchTimeStamp

    sr1 = searchTimeStamp( timeStamp )
    
    searchResultMain = sr1

    case 3
    
    % SECOND: narrow search by metadata flag query
    % sr2 = searchMetaDataFlag( sr1, query )

    sr1 = searchTimeStamp( timeStamp )
    
    sr2 = searchMetaDataFlag( sr1, metaDataFlagInput, metaDataFlagBooleanInput )


    % THIRD: narrow search by commodity fds query
    % sr3 = searchfdListByCommodity( sr2, query )

    sr3 = searchfdListByCommodity( sr2, foundDataToSearchFDList, fdTypeInput );
    
end

end