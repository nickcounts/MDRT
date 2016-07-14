function [ cfg ] = newConfig( )
%makeConfig Summary of this function goes here
%   generate a new config structure - populate all paths with the user path
%
%     config.outputFolderPath
%     config.dataFolderPath
%     config.delimFolderPath
%     config.graphConfigFolderPath
%

% Counts 2016 VCSFA

    cfg.outputFolderPath        = fullfile(userpath);
    cfg.dataFolderPath          = fullfile(userpath);
    cfg.delimFolderPath         = fullfile(userpath);
    cfg.graphConfigFolderPath 	= fullfile(userpath);
