%% Metadata Indexer
% looks at existing data archive and returns fd/timespan matrix to metaDataStructure

% Existing
% Data Archive: Folders containing metadata structures

% Need to step through existing data folders -> find timespans -> find all fds

function [FD, timestamp1, timestamp2] = metaDataIndexer(path,fileType)

% FD output is string value (call from availFD in getDataSetRange?)
% timestamp1 is minimum value, timestamp 2 is maximum value

%% check each file -> if file is FD: populate output fields with FD string value, and UTC timespan (timestamp1 and timestamp2)
if
	timestamp1 == min(%returned timestamp)
	timestamp2 == max(%returned timestamp)
	
%% if single timestamp exists, populate both timestamp1 and timestamp2 fields with same value

elseif % returned timestamp is single value
	timestamp1 == %returned timestamp
	timestamp2 == %returned timestamp
	% or can write as timestamp1 == timestamp2 cleaner?
	
%% compile results in matrix with columns for each output field 
%[FD timestamp1 timestamp2]
% save matrix to metaDataStructure
dataMetaData.metaDataIndexer


