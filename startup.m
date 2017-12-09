% Startup script for MDRT.
%
% This script should run prior to executing any MDRT code. It handles path
% definition, and is important for the proper function of some overloaded
% MATLAB functions.
%
% For production use, use MATLAB setings and set your starting directory to
% the MDRT folder. This will ensure the startup.m script runs.
%
% MDRT checks for a 'hasRunStartup' flag and will attempt to recover if
% this is missed. Having the starting directory set in preferences is
% preferred.

%% Clean up paths in case a user saved them

[MDRTpath, ~, ~] = fileparts(mfilename('fullpath'));

warning('off', 'MATLAB:rmpath:DirNotFound')

    rmpath( genpath(fullfile(MDRTpath,'overloads')))
    rmpath( genpath(fullfile(MDRTpath,'developerArea')))
    rmpath( genpath(fullfile(MDRTpath,'Documentation')))
    rmpath( genpath(fullfile(MDRTpath,'Snippets')))
    rmpath( genpath(fullfile(MDRTpath,'unused')))
    
warning( 'on', 'MATLAB:rmpath:DirNotFound')

%% Set function handles to any overloaded standard functions.
% This must be done before the /overloads/ directory is added to the path

warning('off', 'MATLAB:rmpath:DirNotFound')
    rmpath('overloads') % So important we do it twice
warning( 'on', 'MATLAB:rmpath:DirNotFound')

setappdata(groot,'realcla',@cla)

%% Set all the paths and subfolders required for MDRT here

addpath(genpath(fullfile(MDRTpath,'overloads')));
addpath(genpath(fullfile(MDRTpath,'ApplicationModules')));
addpath(genpath(fullfile(MDRTpath,'ClassDefinitions')));
addpath(genpath(fullfile(MDRTpath,'comparison')));
addpath(genpath(fullfile(MDRTpath,'extensions')));
addpath(genpath(fullfile(MDRTpath,'helpers')));
addpath(genpath(fullfile(MDRTpath,'resources')));
addpath(genpath(fullfile(MDRTpath,'Review_App_Files')));
addpath(genpath(fullfile(MDRTpath,'SpecialTopics')));
addpath(genpath(fullfile(MDRTpath,'Structures')));

%% Set a flag in groot that MDRT can check on startup

setappdata(groot, 'hasRunStartup', true)