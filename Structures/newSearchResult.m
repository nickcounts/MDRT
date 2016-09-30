function [searchResult] = newSearchResult(varagin)
% A structure that is outputted from the searchTimeStamp function that returns desired
% reuslt as a list of matching fd's, a filepath, and the corresponding
% metaData structure of selectd data set.
%           
%
%       searchResult: 
%
%                 metaData: [1x1] struct of metaData
%               pathToData: 'C:/Users/Paige/Documents/MATLAB/MDRT'
%           matchingFDList: ('fd name', 'filename.ext')
%
% Pruce 7-14-16 VCSFA


searchResult = struct;

searchResult.metaData = []; % [1x0] struct of metaData
searchResult.pathToData = []; % string containing path to data
searchResult.matchingFDList = []; % cell array of strings containing
                                  % ('file string', 'filename.ext')

end

