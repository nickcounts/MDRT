function [ dataIndex ] = getDataIndex( input_args )
%getConfig returns the config structure

filename = 'dataIndex.mat';

%TODO: This is hacked together from getConfig - fix the error checking and
%populate missing fields section. Does that even apply in this case?

if ~isdeployed
    % If run from Matlab runtime, use current path
%     if exist(fullfile(pwd, 'review.cfg'),'file')   
%         load('review.cfg','-mat');
%     else
%         % No config file, oh noes!!!
%         config = makeBlankConfigStruct;
%     end
else
    % If application is deployed, use ctfroot
%     if exist(fullfile(ctfroot, 'review.cfg'),'file')   
%         load('review.cfg','-mat');
%     else
%         % No config file, oh noes!!!
%         config = makeBlankConfigStruct;
%     end
end

if exist(filename,'file')   
    % Config file exists. Load and populate missing items
    load(filename,'-mat');
%     dataIndex = populateMissingIndexFields(dataIndex);
else
    % No config file, oh noes!!!
%     dataIndex = makeBlankDataIndexStruct;
end

function dataIndex = populateMissingIndexFields(dataIndex)
% manually checks for each struct field. If missing, populates with a
% default value

    if ~isfield(dataIndex,'outputFolderPath')
         dataIndex.outputFolderPath    = fullfile(userpath);
    end

    if ~isfield(dataIndex,'dataFolderPath')
        dataIndex.dataFolderPath      = fullfile(userpath);
    end

    if ~isfield(dataIndex,'delimFolderPath')
        dataIndex.delimFolderPath     = fullfile(userpath);
    end

    if ~isfield(dataIndex,'graphConfigFolderPath')
        dataIndex.graphConfigFolderPath     = fullfile(userpath);
    end


function cfg = makeBlankConfigStruct

%      outputFolderPath: [1x47 char]
%        dataFolderPath: [1x52 char]
%       delimFolderPath: [1x53 char]
% graphConfigFolderPath: [1x46 char]

    cfg.outputFolderPath        = fullfile(userpath);
    cfg.dataFolderPath          = fullfile(userpath);
    cfg.delimFolderPath         = fullfile(userpath);
    cfg.graphConfigFolderPath 	= fullfile(userpath);
