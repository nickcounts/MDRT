function [searchResult] = statenSearchFunction( time, handles )
%Dummy function to input a time array of 1 or 2 datenums and output an
%array of structures containing FDs
% timeRange = time(2) - time(1);

% % Practice Displaying strings in drop down menu
% if timeRange > 7
% display('Oooooh weeee! You searched for MORE than a week! Good 4 u')
% searchResult = { 'Paige' 'Orange';...
%            'Staten' 'Dog';...
%            'Ryan' 'Kite'};
% else
%     display('Oooooh weeee! Here is some dummy data!')
% Want to import data from a single file path

% dummyData= 'C:/Users/Paige/Documents/MARS Matlab/Data Repository/2014-01-09 - ORB-1/data/1014.mat';
dummyData= 'C:/Users/Paige/Documents/MARS Matlab/Data Repository/2014-01-09 - ORB-1/data';
dummyDataName = ('Orb-1 1014');
dummyMetaData = load('C:/Users/Paige/Documents/MARS Matlab/Data Repository/2014-01-09 - ORB-1/data/metadata.mat');
dummyStringFileName = {' 1014' , '1014.mat';...
                       ' 1015' , '1015.mat';...
                       ' 1016' , '1016.mat'};


% FDList = {dummyDataName dummyData};
% config.dataFolderPath = dummyData;

searchResult = newSearchResult;


searchResult.metaData = dummyMetaData.metaData;
searchResult.pathToData = dummyData;
searchResult.matchingFDList = dummyStringFileName;

%
% TODO: ------------------------------------------------------------------ 
% Create 2 structures, one from Orb-1 dataset and one from A230
% WDR (or some other data set). Creat an array of 2 structures and output 3
% files from each, and label accordingly. Use makeStringFromMetaData to
% creat FD string names and store in popupmenu handles and FD list
% structure.
%    



end

