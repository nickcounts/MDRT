function [] = dataIndexForSearching()

%% takes results from dataIndexer and organizes them into a single file in the data archive folder

%% creates index of all available data that is ready to be searched

% dataIndexForSearching calls dataIndexer function with the following parameters:
% dataRepositoryDirectory = path to data repository directory
	% set this variable equal to the file path before calling the function
% searchExpression = 'metadata'

%dataIndexer(baseDir, searchExpression)

dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository';

dataIndexer(dataRepositoryDirectory, 'metadata')'


