function [ masterFDList ] = newMasterFDListStruct
%A structure that is outputted from statenSearch that returns desired
% reuslt as a list of matching fd's, a filepath, and the corresponding
% metaData structure of selectd data.
%           
%
%       masterFDList: 
%
%                    names: [nx1] cell array of string names
%                           ('A230 Hot Fire RP1 DCVN/C 1001')
%                    paths: [nx1] cell array of full file path names 
%                           'C:/Documents/Data Repository/A230 Stage Test/0004.mat'
%           pathsToDataSet: [nx1] cell array of full file paths to data set
%                           'C:/Documents/Data Repository/A230 Stage Test'
%
% Pruce 8-2-16 VCSFA

masterFDList = struct;

masterFDList.names = []; 
masterFDList.paths = []; 
masterFDList.pathsToDataSet = []; 

end

