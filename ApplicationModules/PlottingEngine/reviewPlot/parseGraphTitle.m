function [ output_args ] = parseGraphTitle( graphName )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%% Constant definition

metaDataFileName = 'dataMetaData.mat';


%% Function code

config = getConfig;

    if exist(fullfile(config.dataFolderPath, metaDataFileName))

        load(fullfile(config.dataFolderPath, metaDataFileName));

    else

        % Fuck me, there isn't anything to load!?

    end


testString = 'ECS GN2 Purge Performance [metaData=opName]';
commands = regexp(testString,'\[(.*?)\]','tokens');
commands = lower(commands);

strfind(commands{1}, 'metadata')


end

