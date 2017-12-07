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

warning('off', 'MATLAB:rmpath:DirNotFound')

    rmpath( genpath('overloads'));
    rmpath( genpath('developerArea'))
    rmpath( genpath('Documentation'))
    rmpath( genpath('Snippets'))
    rmpath( genpath('unused'))
    
warning( 'on', 'MATLAB:rmpath:DirNotFound')

%% Set function handles to any overloaded standard functions.
% This must be done before the /overloads/ directory is added to the path

setappdata(groot,'realcla',@cla);

%% Set all the paths and subfolders required for MDRT here

addpath(genpath('overloads'));
addpath(genpath('ApplicationModules'));
addpath(genpath('ClassDefinitions'));
addpath(genpath('comparison'));
addpath(genpath('extensions'));
addpath(genpath('helpers'));
addpath(genpath('resources'));
addpath(genpath('Review_App_Files'));
addpath(genpath('SpecialTopics'));
addpath(genpath('Structures'));

%% Set a flag in groot that MDRT can check on startup

setappdata(groot, 'hasRunStartup', true)