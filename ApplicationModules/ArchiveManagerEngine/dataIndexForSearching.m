function [dataIndex] = dataIndexForSearching(filenames, filepaths)
%% dataIndexForSearching()

% Purpose: Creates an index of all available data that is ready to be
% searched inside of the current data repository.

% Function input (filenames, filepaths) takes every value obtained by the
% dataIndexer function.

% Function output dataToSearch is a file including every metadata structure
% found within the current data repository by the dataIndexer function.
% This file is then loaded back into the current data repository folder.

% Example output:  
%                     foundDataToSearch = 
% 
%                     5x1 struct array with fields:
% 
%                         metaData
%                         pathToData
%                         fdList

% Supporting functions:
%     dataIndexer - provides input filenames and filepaths
 
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)
 

% dataIndexForSearching calls dataIndexer function with the following parameters:
% dataRepositoryDirectory = path to data repository directory
	% set this variable equal to the file path before calling the function
% searchExpression = 'metadata'
 

% CONSTANT DEFINITIONS:

dataIndexFileName = 'dataIndex.mat';
dataIndexVariableName = 'dataIndex';


% HARDCODED: set this up as a file path to be passed as input from the GUI

config = MDRTConfig.getInstance;

dataRepositoryDirectory = filepaths;
% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository';

% obtain input for dataIndexForSearching from dataIndexer function
[filenames, filepaths] = dataIndexer(dataRepositoryDirectory, 'metadata');

% index each file found by dataIndexer function
for i = 1:numel(filepaths);
    
    % load each file found by dataIndexer function
    % {i} generates contents of each cell
    variable = load(filepaths{i} );
    metaData = variable.metaData;
    
    % specify path to data folder in data repository
    pathToData = fileparts(filepaths{i} );
    
    % if checkStructureType function returns metadata
    if strcmp(checkStructureType( metaData ), 'metadata')

        % create structure array dataToSearch 
            
            % creates array structure of metaData
            dataIndex(i).metaData = metaData; 
            
            % creates array structure of filepaths
            dataIndex(i).pathToData = pathToData; 

        % save dataToSearch as file and put this file in root search path
        
        
        
        save( fullfile(dataRepositoryDirectory, dataIndexFileName) , 'dataIndex');

    end % end if loop checking structure type  

end % end for loop iterating over each filepath

end % end function dataIndexForSearching
