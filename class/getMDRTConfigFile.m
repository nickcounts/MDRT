function fid = getMDRTConfigFile
%getMDRTConfigFile
%
% finds the configuration file in a platform independent manner, creates a
% default if it's missing. Opens the file and returns the fid.
%
%




% % 1. Instead of the default path that the deployed application chooses to store the config file, you could use an OS specific location.
% % For example on Windows you could use the APPDATA environment -
% % myprefs = fullfile(getenv('appdata'),'myApplication','setting.cfg')
% % 
% % And on Mac/Linux
% % myprefs = '~/.myApplication/settings.cfg'
% % 
% % Here is the brief algorithm:
% % 
% % if isdeployed
% %  if File present at OS specific location
% %     Read/Update settings from there
% %  if File is not present at OS specific location
% %    Copy the file from MCR path and paste it in OS specific location
% % end
% % 
% % Please note that the user should have the write permissions to the folder/file.
% % 
% % 2. With respect to the use of environment variables suggested before, the users of the deployed application would have to set the environment variable manually before running the tool. This is because the 'setenv' function used to set the environment variables in MATLAB is valid only for a particular session of MATLAB. 

%% Define Constants for configuration file getting/setting

    applicationName = 'mdrt';

    linuxPrefix = '.';
    configFileName = 'config.txt';

    macConfigFile = 'config_mac.txt';
    winConfigFile = 'config_windows.txt';


    pathToConfig = '';
    defaultConfigFile = '';

%% Environment Check

    if ispc
        pathToConfig = fullfile(getenv('appdata'), applicationName );
        defaultConfigFile = winConfigFile;

    elseif ismac
        pathToConfig = fullfile('~', [linuxPrefix, applicationName] );
        defaultConfigFile = macConfigFile;

    elseif isunix
        pathToConfig = fullfile('~', [linuxPrefix, applicationName] );
        defaultConfigFile = macConfigFile;

    end


%% Check for folder existance and make if required

    if ~exist(pathToConfig, 'dir')
        % TODO: Should this be converted to a try/catch?

        [status, message, id] = mkdir(pathToConfig);

        if ~status
           % mkdir failed - maybe a premissions issue? 
            warndlg(message);

            warning('MDRT configuration directory not found. Unable to create directory:');
            warning( pathToConfig );

        end

    end

%% Check for configuration File existance and copy a blank if required.

    if ~exist( fullfile(pathToConfig, configFileName), 'file')
        % TODO: Should this be converted to a try/catch?

        [status, message, id] = copyfile( defaultConfigFile, fullfile( pathToConfig, configFileName ) );

        if ~status
            % Copy failed!
            warndlg(message);

            warning('MDRT could not write configuration file to the following directory:');
            warning( pathToConfig );
        end


    end

%% Open the config file and read in the contents


    fid = fopen( fullfile( pathToConfig, configFileName) );


