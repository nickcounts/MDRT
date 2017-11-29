% function hs = makeArchiveManagerGUI( varargin )
% %makeArchiveManagerGUI creates the MARS DRT archive management panel.
% %
% % Called by itself, it generates a stand-alone gui.
% % Pass a handle to a parent object, and the settings panel will populate
% % the parent object.
% %
% % makeArchiveManagerGUI returns a handle structure
% %
% % Counts, 2016 VCSFA
% 
% if nargin == 0
%     % Run as standalone GUI for testing
%     % Run as standalone GUI for testing

    hs.fig = figure;
        guiSize = [672 387];
        hs.fig.Position = [hs.fig.Position(1:2) guiSize];
        hs.fig.Name = 'Archive Manager GUI';
        hs.fig.NumberTitle = 'off';
        hs.fig.MenuBar = 'none';
        hs.fig.ToolBar = 'none';
        hs.fig.Tag = 'archiveManagerFigure';
%         hs.fig.DeleteFcn = @windowCloseCleanup;

% elseif nargin == 1
%     % Populate a UI container
%     
%     hs.fig = varargin{1};
%     
% end






config = MDRTConfig.getInstance;




[mtree, container]  = uitree('v0', 'Root',config.dataArchivePath, ... 
                             'Parent',       hs.fig, ...
                             'SelectionChangeFcn',    @nodeSelected ...
                             );

container.Units     = 'normalized';
container.Position = [0 0 0.35 0.90];

% Expand the root!!!
mtree.expand(mtree.Root)

hlabel = uicontrol(hs.fig, ...
                   'style',                     'text', ...
                   'units',                     'normalized', ...
                   'position',                  [0.5 0.4, 0.5, 0.1], ...
                   'String',                    'Default Label Test', ...
                   'horizontalalignment',       'left');

               
hs.button_fixSelectedSet = uicontrol(hs.fig, ...
        'style',            'pushbutton', ...
        'Units',            'pixels', ...
        'Position',         [500 50 150 30], ...
        'String',           'Fix Selected Data Set', ...
        'Tag',              'FixSelectedSetButton', ...
        'Callback',         @(hobj,event)updateRepositoryDataSet(getappdata(gcf, 'SelectedPathFF')) ...
        );








% %% Shared variabls for GUI
% 
% fileArray = {};
% metaData = newMetaDataStructure;
% 
% 
% 
% 
% 
% 
% %% Button Parameters
% 
% buttonPositions = { [50 321 151 49];
%                     [15 240 101 21];
%                     [500 19 151 49];
%                     };
%                     
% buttonTags          =   {   'button_newSession';
%                             'button_selectFiles';
%                             'button_importFiles';
%                         };
%                     
% 
% buttonStrings       =   {   'New Data Import Session';
%                             'Select Files';
%                             'Import FCS Data'
%                         };
% 
% 
% buttonCallbacks     =   {   @resetGUI;
%                             @selectFiles;
%                             @startImport
%                         };
%                             
%                 
% buttonParents       =   {   'fig';
%                             'panel_files';
%                             'fig'
%                         };
%                     
% 
% %% Checkbox Parameters
% 
% checkboxPositions       = { [300 339 117 23];
%                             [14 114 111 23];
%                             [14 81 111 23];
%                             [14 48 111 23];
%                             [14 15 111 23]
%                             };
% 
%                         
% checkboxTags            = { 'checkbox_autoName';
%                             'checkbox_isOperation';
%                             'checkbox_isMARS';
%                             'checkbox_hasUID';
%                             'checkbox_vehicleSupport'
%                             };
%                             
% 
% checkboxStrings         = { 'Auto-name folder';
%                             'Operation';
%                             'MARS Procedure';
%                             'Has MARS UID';
%                             'Vehicle support'
%                             };
% 
% 
% checkboxParents         =   {   'fig';
%                                 'panel_metaData';
%                                 'panel_metaData';
%                                 'panel_metaData';
%                                 'panel_metaData'
%                             };
%                         
% checkboxValue           =   {   true;
%                                 false;
%                                 false;
%                                 false;
%                                 false
%                             };
%                         
% %% Edit Box Parameters
% 
% editPositions           =   {   [417 339 233 22];
%                                 [150 114 190 22];
%                                 [150  81 190 22];
%                                 [150  48 190 22]
%                             };
% 
% 
% editTags                =   {   'edit_folderName';
%                                 'edit_operationName';
%                                 'edit_procedureName';
%                                 'edit_UID'
%                             };
% 
% 
% editStrings             =   {   '';
%                                 '';
%                                 '';
%                                 '';
%                             };
% 
% 
% editEnabled             =   {   'inactive';
%                                 'off';
%                                 'off';
%                                 'off'
%                             };
%                         
% editParents             =   {   'fig';
%                                 'panel_metaData';
%                                 'panel_metaData';
%                                 'panel_metaData';
%                                 'panel_metaData'
%                             };
%                         
% %% Panel Properties
% 
% panelPositions      =   {   [50   13 234 301];
%                             [300 152 351 156]
%                         };
% 
% panelStrings        =   {   'Raw data file selection';
%                             'Data Set Metadata Entry'
%                         };
%                     
% panelTags           =   {   'panel_files';
%                             'panel_metaData'
%                         };
% 
% 
% 
% %% Listbox Propertiess
%                     
% listboxPosition = [15 16 201 201];
% 
% 
% %% GUI Label Properties
% 
% labelStrings        =   {   'Choose files to import';
%                             'Retrieval files to import'
%                         };
% 
% 
% labelPositions      =   {   [ 14 266 201  13];
%                             [ 15 222 201  13]
%                         };
% 
% 
% labelParents        =   {   'panel_files';
%                             'panel_files'
%                         };
% 
% 
% %% GUI Generation
% 
% % UI Panel Generation
% for i = 1:numel(panelPositions)
%     
%     hs.(panelTags{i}) = uipanel( hs.fig, ...
%                             'Units',            'pixels',...
%                             'Position',         panelPositions{i} ,...
%                             'Title',            panelStrings{i},...
%                             'Tag',              panelTags{i} ...
%                         );
% 
% end
% 
% % Checkbox Generation
% for i = 1:numel(checkboxTags)
%     
%     hs.(checkboxTags{i}) = uicontrol( ...
%                             hs.(checkboxParents{i}), ...
%                             'Style',            'checkbox',...
%                             'Units',            'pixels',...
%                             'Position',         checkboxPositions{i} ,...
%                             'String',           checkboxStrings{i},...
%                             'Tag',              checkboxTags{i}, ...
%                             'Value',            checkboxValue{i}, ...
%                             'Callback',         @controllerDataImportGUI ...
%                         );
% 
% end
% 
% % Edit Box Generation
% for i = 1:numel(editTags)
%     
%     hs.(editTags{i}) = uicontrol( ...
%                             hs.(editParents{i}), ...
%                             'Style',            'edit', ...
%                             'Units',            'pixels', ...
%                             'Position',         editPositions{i}, ...
%                             'String',           editStrings{i}, ...
%                             'Tag',              editTags{i}, ...
%                             'HorizontalAlignment',  'left', ...
%                             'Enable',           editEnabled{i}, ...
%                             'Callback',         @controllerDataImportGUI ...
%                         );
% 
% end
% 
% % Button Generation
% for i = 1:numel(buttonTags)
%     
%     hs.(buttonTags{i}) = uicontrol( ...
%                             hs.(buttonParents{i}), ...
%                             ...
%                             'Units',            'pixels', ...
%                             'Position',         buttonPositions{i}, ...
%                             'String',           buttonStrings{i}, ...
%                             'Tag',              buttonTags{i}, ...
%                             'Callback',         buttonCallbacks{i} ...
%                         );
% 
% end
% 
% % Label Generation
% for i = 1:numel(labelPositions)
%     
%                             uicontrol( ...
%                             hs.(labelParents{i}), ...
%                             'Style',            'text', ...
%                             'Units',            'pixels', ...
%                             'Position',         labelPositions{i}, ...
%                             'HorizontalAlignment', 'left', ...
%                             'String',           labelStrings{i} ...
%                         );
% 
% end
%                             
% % Listbox Generation - for import file list and drag/drop
% 
% flbManager = FileListBox;
% flbManager.makeAndPlaceListBox(     hs.panel_files, ...
%                                     'Units',            'pixels', ...
%                                     'Position',         listboxPosition ...
%                                );
%                            
% %% Add Listeners to GUI properties and flibManager
% 
% addlistener(flbManager, 'fileList', 'PostSet', @updateFolderGuess);
% 
% el(1) = addlistener(hs.edit_folderName,    'String', 'PostSet', @updateFolderGuess);
% el(2) = addlistener(hs.edit_operationName, 'String', 'PostSet', @updateFolderGuess);
% el(3) = addlistener(hs.edit_procedureName, 'String', 'PostSet', @updateFolderGuess);
% el(4) = addlistener(hs.edit_UID,           'String', 'PostSet', @updateFolderGuess);
% el(5) = addlistener(hs.checkbox_autoName,  'Value',  'PostSet', @updateFolderGuess);
% 
% 
% 
% 
% 
%     
%     
% 
% %% Set Initial Value Cell Array from GUI Generation Results
% 
% initialValues =    ...
%     {   'checkbox_autoName',        'Value',    hs.checkbox_autoName.Value;
%         'checkbox_isOperation',     'Value',    hs.checkbox_isOperation.Value; 
%         'checkbox_isMARS',          'Value',    hs.checkbox_isMARS.Value;
%         'checkbox_hasUID',          'Value',    hs.checkbox_hasUID.Value;
%         'checkbox_vehicleSupport',  'Value',    hs.checkbox_vehicleSupport.Value;
%         
%         'edit_folderName',          'String',   hs.edit_folderName.String;
%         'edit_operationName',       'String',   hs.edit_operationName.String;
%         'edit_procedureName',       'String',   hs.edit_procedureName.String;
%         'edit_UID',                 'String',   hs.edit_UID.String;
%         
%         'edit_folderName',          'Enable',   hs.edit_folderName.Enable;
%         'edit_operationName',       'Enable',   hs.edit_operationName.Enable;
%         'edit_procedureName',       'Enable',   hs.edit_procedureName.Enable;
%         'edit_UID',                 'Enable',   hs.edit_UID.Enable
%     };
% 
