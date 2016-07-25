function [dataToSearch] = dataIndexForSearching(filenames, filepaths)

%% takes results from dataIndexer and organizes them into a single file in the data archive folder

%% creates index of all available data that is ready to be searched

% dataIndexForSearching calls dataIndexer function with the following parameters:
% dataRepositoryDirectory = path to data repository directory
	% set this variable equal to the file path before calling the function
% searchExpression = 'metadata'

%dataIndexer(baseDir, searchExpression)

% HARDCODED: set this up as a file path to be passed as input from the GUI
% (in the future)
% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository';
dataRepositoryDirectory = 'C:\Users\Paige\Documents\MARS Matlab\Data Repository';

[filenames, filepaths] = dataIndexer(dataRepositoryDirectory, 'metadata');


%% load each file found by dataIndexer
% for index from 1 to the total number of filepaths in array
% for i = 1:numel(filepaths)
%     % load each file found by dataIndexer function
%     load(char(filepaths(i)))
% 
% end

%% for each file, check variable loaded and add to workspace (it's a metadata structure)
% use Nick's checkStructureType function; if it passes, load variable
for i = 1:numel(filepaths);
    
    
    % load each file found by dataIndexer function
    % {i} generates contents of each cell
    variable = load(filepaths{i} );
    metaData = variable.metaData;
    
    % specify path to data folder in data repository
    pathToData = fileparts(filepaths{i} );
    
%% add to array of metadata structures
% make structure array with fields
% add path to directory where metadata.mat files live (check out help for
% command fullfile to look at other helpful functions to straightup give
% path without filename)
% if checkStructureType function returns metadata
    % not entirely sure how this function takes input; tried feeding it
    % filepath but threw errors
    % HARDCODED??
    if strcmp(checkStructureType( metaData ), 'metadata')
%         
%         metaDataArray{i}.metaData = metaData; % creates array structure of metaData
%         pathArray{i}.pathToData = pathToData; % creates array structure of filepaths
%         %newStructureArray = s';
%         
%         dataToSearch = vertcat(metaDataArray,pathArray) % appends metaData and filepaths into same array structure
%         
%        % dataToSearch = [metaData; pathToData]
        
          dataToSearch(i).metaData = metaData; % creates array structure of metaData
          dataToSearch(i).pathToData = pathToData; % creates array structure of filepaths
%         %newStructureArray = s';
%         
%         dataToSearch = vertcat(metaDataArray,pathArray) % appends metaData and filepaths into same array structure
        
          % need to save dataToSearch as file and put this file in root search path
          save( fullfile(dataRepositoryDirectory,'dataToSearch.mat' ) , 'dataToSearch')
        
    end
    
    

end




% two commands to google: 
% load - function: want to use for getting the variables and loading the files
% give path and filename, it will open file take out variable name and put
% into workspace (USE THIS ONE)
% fopen - function: creates pointer to file handler you can write to (DON'T USE THIS ONE)
% check out fopen in Nick's parsing files (processDelimFiles.m)


