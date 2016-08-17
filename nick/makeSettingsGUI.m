function hs = makeSettingsGUI( varargin )
%makeSettingsGUI creates the MARS DRT settings panel.
%
% Called by itself, it generates a stand-alone gui.
% Pass a handle to a parent object, and the settings panel will populate
% the parent object.
%
% makeSettingsGUI returns a handle structure
%
% Counts, 2016 VCSFA

if nargin == 0
    % Run as standalone GUI for testing

    hs.fig = figure;
        guiSize = [672 387];
        hs.fig.Position = [hs.fig.Position(1:2) guiSize];
        hs.fig.Name = 'Data Comparison Plotter';
        hs.fig.NumberTitle = 'off';
        hs.fig.MenuBar = 'none';
        hs.fig.ToolBar = 'none';
        
elseif nargin == 1
    % Populate a UI container
    
    hs.fig = varargin{1};
    
end
        
        
        
%% User Interface Locations/Dimensions - variable definitions        
% -------------------------------------------------------------------------

    % Edit box variables
    eb_x_loc = 200;
    eb_y_loc = [315; 265; 215; 165];
    eb_width = 400;
    eb_height= 22;

    % Button variables
    b_x_loc = 50;
    b_y_loc = eb_y_loc;
    b_wide  = 137;
    b_tall  = 21;
    tags    = {'dataArchive';'outputPath';'workingPath';'graphConfig';'saveConfig'};
    
%% Configuration object instantiation
% -------------------------------------------------------------------------

    config = MDRTConfig;    



%% Button Generation
% -------------------------------------------------------------------------
    hs.button_archive =     uicontrol(hs.fig,...
            'String',       'Data Archive Path',...
            'Callback',     @pushButtonCallback,...
            'Tag',          tags{1},...
            'ToolTipString','Set Data Archive Path',...
            'Position',      [b_x_loc, b_y_loc(1), b_wide, b_tall]);

    hs.button_output =      uicontrol(hs.fig,...
            'String',       'Plot Output Path',...
            'Callback',     @pushButtonCallback,...
            'Tag',          tags{2},...
            'ToolTipString','Set Plot Output Path',...
            'Position',      [b_x_loc, b_y_loc(2), b_wide, b_tall]);

    hs.button_working =     uicontrol(hs.fig,...
            'String',       'Working Path',...
            'Callback',     @pushButtonCallback,...
            'Tag',          tags{3},...
            'ToolTipString','Set Working Path',...
            'Position',      [b_x_loc, b_y_loc(3), b_wide, b_tall]);

    hs.button_graphConfig = uicontrol(hs.fig,...
            'String',       'Graph Configuration Path',...
            'Callback',     @pushButtonCallback,...
            'Tag',          tags{4},...
            'ToolTipString','Set Graph Configuration Path',...
            'Position',      [b_x_loc, b_y_loc(4), b_wide, b_tall]);
        
        
    hs.button_saveConfig = uicontrol(hs.fig,...
            'String',       'Save Configuration',...
            'Callback',     @pushButtonCallback,...
            'Tag',          tags{5},...
            'ToolTipString','Save Graph Configuration to Disk',...
            'Position',      [b_x_loc, 50, b_wide, b_tall * 2]);


        
%% Edit Box Generation
% -------------------------------------------------------------------------

    hs.edit_dataArchive =   uicontrol(hs.fig,...
            'Style',        'edit',...
            'String',       '',...
            'HorizontalAlignment' , 'left',...
            'Position',     [eb_x_loc, eb_y_loc(1), eb_width, eb_height],...
            'tag',          'dataArchivePath');
        
    hs.edit_plotOutput =    uicontrol(hs.fig,...
            'Style',        'edit',...
            'String',       '',...
            'HorizontalAlignment' , 'left',...
            'Position',     [eb_x_loc, eb_y_loc(2), eb_width, eb_height],...
            'tag',          'plotOutputPath');
        
    hs.edit_workingPath = 	uicontrol(hs.fig,...
            'Style',        'edit',...
            'String',       '',...
            'HorizontalAlignment' , 'left',...
            'Position',     [eb_x_loc, eb_y_loc(3), eb_width, eb_height],...
            'tag',          'workingPath');
        
    hs.edit_graphConfigPath =   uicontrol(hs.fig,...
            'Style',        'edit',...
            'String',       '',...
            'HorizontalAlignment' , 'left',...
            'Position',     [eb_x_loc, eb_y_loc(4), eb_width, eb_height],...
            'tag',          'graphConfigPath');
        

        
%% Populate GUI from Configuration
% -------------------------------------------------------------------------

    populateEditBoxContents();




    
    function populateEditBoxContents()
        
        hs.edit_dataArchive.String      = config.dataArchivePath;
        hs.edit_plotOutput.String       = config.userSavePath;
        hs.edit_workingPath.String      = config.userWorkingPath;
        hs.edit_graphConfigPath.String  = config.graphConfigFolderPath;
        
    end
    

    function pushButtonCallback(hObj, event)
    
        % get a starting path
        switch hObj.Tag
            case 'dataArchive'
                guessPath = config.dataArchivePath;
            case 'outputPath'
                guessPath = config.userSavePath;
            case 'workingPath'
                guessPath = config.userWorkingPath;
            case 'graphConfig'
                guessPath = config.graphConfigFolderPath;
            case 'saveConfig'
                % TODO - move this to its own callback?
                config.writeConfigurationToDisk;
                return;
            otherwise
                % Something's gone very wrong. soft fail
                return
        end
        
        % Check guess path for validity
        if ~exist(guessPath, 'dir')
            % If the path isn't there, default to a different path
            guessPath = pwd;
        end
        
        % UI Choose Folder Window Title:
        windowTitle = strjoin({'Choose', hObj.String});
        targetPath = uigetdir(guessPath, windowTitle);
        
        % Cancel setting value if user presses cancel
        if ~targetPath
            % Just stop execution
            return
        end
        
        
        
        % Set the appropriate configuration variable
        switch hObj.Tag
            case 'dataArchive'
                config.dataArchivePath = targetPath;
            case 'outputPath'
                config.userSavePath = targetPath;
            case 'workingPath'
                config.userWorkingPath = targetPath;
            case 'graphConfig'
                config.graphConfigFolderPath = targetPath;
            otherwise
                % Something's gone very wrong. soft fail
                return
        end
        
        populateEditBoxContents();
        
    end
        
end