%% gridMaker is a script that allows generating a matrix of sensor values
% from existing MDRT data sets.
%
% gridMaker launches a gui with a data set selection dropdown and a
% filterable list of available FDs for the selected data set.
%
% Double clicking a data set adds or removes it from the selected list.
% Clicking the "generate" button creates a big matrix of values centered on
% T0. These values are displated in a GUI that can be copied and pasted
% into MS Excel.
%
% You're welcome, Stevens.
%
% Counts, 2017 VCSFA



hs.fig = figure;
            guiSize = [672 387];
            hs.fig.Position = [hs.fig.Position(1:2) guiSize];
            hs.fig.Name = 'Data Grid Generator';
            hs.fig.NumberTitle = 'off';
            hs.fig.MenuBar = 'none';
            hs.fig.ToolBar = 'none';
            
            
%% MDRTConfig is now a singleton handle class!
    
    config = MDRTConfig.getInstance;
            
%% Debugging Tasks - variable loading, etc...

    dataIndexName = 'dataIndex.mat';
    dataIndexPath = config.dataArchivePath;
    
    
    % Load the data index using the environment variable and the specified
    % filename.
    if exist(fullfile(dataIndexPath, dataIndexName), 'file')
        load(fullfile(dataIndexPath, dataIndexName) );
    else
        warning(['Data Repository Index file not found.' ,...
                 'Check MDRTdataRepositoryPath environment variable. ', ...
                 'Verify there is a ' dataIndexName ' file.']);
        return
    end
    
    debugout(dataIndex)
    
    setappdata(hs.fig, 'dataIndex', dataIndex);
    setappdata(hs.fig, 'selectedList', {});
            
            
%% List Box Generation

hs.lb_available = uicontrol('style',        'list', ...
                            'units',        'normalized',...
                            'position',     [0.05, 0.05, 0.4, 0.7],...
                            'tag',          'listSearchResults',...
                            'callback',     @listClickCallback)
                        
hs.lb_selected = uicontrol('style',        'list', ...
                            'units',        'normalized',...
                            'position',     [0.55, 0.05, 0.4, 0.7],...
                            'tag',          'selectedList',...
                            'callback',     @listClickCallback)                        

%% Search Box Generation

 hs.edit_searchField =   uicontrol(hs.fig,...
            'Style',        'edit',...
            'String',       '',...
            'HorizontalAlignment' , 'left',...
            'units',        'normalized', ...
            'KeyReleaseFcn',@updateSearchResults,...
            'Position',     [0.05, 0.8, 0.4, 0.075],...
            'tag',          'searchBox');

%% Popup Menu Generation
    
    hs.popup_dataSetMain =  uicontrol(hs.fig,...
            'Style',        'popupmenu',...
            'String',       {'A230 Stage Test','A230 WDR'},...
            'units',        'normalized', ...
            'Position',     [0.05, 0.85, 0.90, 0.1],...
            'Tag',          'selectDataList', ... 
            'callback',     {@updateMatchingFDList, false} );

        
%% Button Generation

    hs.button_graph =       uicontrol(hs.fig,...
            'String',       'Generate Plot',...
            'Callback',     @makeDataGridFromGUI,...
            'Tag',          'button',...
            'ToolTipString','Plot Data Comparison',...
            'units',        'normalized', ...
            'Position',     [0.55, 0.8, 0.4, 0.075] );
        
        

%% Populate GUI with stuff from dataIndex

allDataSetNames = {};

for i = 1:numel(dataIndex)
    
    allDataSetNames = vertcat(allDataSetNames, ...
         makeDataSetTitleStringFromActiveConfig(dataIndex(i).metaData) );
    
    allDataSetNames = strtrim(allDataSetNames); 
    
end

debugout(allDataSetNames)

% Set appdata
    setappdata(hs.fig, 'dataSetNames', allDataSetNames)
    setappdata(hs.fig, 'fdMasterList', dataIndex(1).FDList(:,1));
    setappdata(hs.fig, 'targetList', hs.lb_selected);

% Populate Data Set selection popups    
    hs.popup_dataSetMain.String = allDataSetNames;    
    
    updateMatchingFDList( hs.popup_dataSetMain, 1, false);
                        
% Populate fd list

    updateSearchResults(hs.edit_searchField);
    
    
    