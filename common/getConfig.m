function [ config ] = getConfig( input_args )
%getConfig returns the config structure



%TODO: Implement error checking - what if the file isn't there!?

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

if exist('review.cfg','file')   
    % Config file exists. Load and populate missing items
    load('review.cfg','-mat');
    config = populateMissingConfigFields(config);
else
    % No config file, oh noes!!!
    config = makeBlankConfigStruct;
end

function config = populateMissingConfigFields(config)
% manually checks for each struct field. If missing, populates with a
% default value

    if ~isfield(config,'outputFolderPath')
         config.outputFolderPath    = fullfile(userpath);
    end

    if ~isfield(config,'dataFolderPath')
        config.dataFolderPath      = fullfile(userpath);
    end

    if ~isfield(config,'delimFolderPath')
        config.delimFolderPath     = fullfile(userpath);
    end

    if ~isfield(config,'graphConfigFolderPath')
        config.graphConfigFolderPath     = fullfile(userpath);
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
