function makeGraphBundle ( varargin )
% makeGraphBundle ( varargin )
%   Conctanates multiple graph structures into a single structure. The
%   combined structure can then be submitted to 
%   VARARGIN - currently undefined or unused

%   This tool serves as part of report generation development. It
%   simplifies and concentrates the need for combining graphs and
%   submitting them to plot. Structures themselves must be created in the
%   plot setup tool.
%
% August 2017, Patel - Mid-Atlantic Regional Spaceport

disp('<a href="makeGraphBundleHelpScript.html">Graph Bundle Help Page</a>')

%% GUI Setup

    r.fig = figure; % creates handle for the GUI window
    r.fig.Resize = 'off';
    guiSize = [125 28];
    r.fig.Units = 'characters';
    r.fig.Position = [75 20 guiSize];
    r.fig.Name = 'Combine Graph Structures';
    r.fig.NumberTitle = 'off';
    r.fig.MenuBar = 'none';
   
%% GUI Layout

% The gui uicontrol is set up within the function, and the function is
% called later. This is just to make the code seem less cluttered.

    function guiOpeningFcn( varargin )
        r.availableText = uicontrol(r.fig, ...
                        'Style',    'Text', ...
                        'String',   'Available Configurations', ...
                        'FontSize', 10, ...
                        'FontUnits', 'points',...
                        'Units',    'characters',...
                        'Position', [23, 24.5, 30, 2]);

        r.selectedText = uicontrol(r.fig, ...
                        'Style',    'Text', ...
                        'String',   'Selected Configurations', ...
                        'FontSize', 10, ...
                        'Units',    'characters',...
                        'Position', [89, 24.5, 30, 2]);

        r.browseButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @browseCallback, ...
                        'String',   'Browse',...
                        'Tag',      'browse', ...
                        'Units',    'characters',...
                        'Position', [6, 25, 14, 1.5]);

        r.clearButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @clearCallback, ...
                        'String',   'Clear All',...
                        'Tag',      'clear', ...
                        'Units',    'characters',...
                        'Position', [72, 25, 14, 1.5]);  

        r.contentsList = uicontrol('Parent', r.fig, ...
                        'Style',    'listbox', ...
                        'String',   'Select',...
                        'Tag',      'contents', ...
                        'Units',    'characters',...
                        'Position', [6, 6, 47, 18]);   

        r.selectedList = uicontrol('Parent', r.fig, ...
                        'Style',    'listbox', ...
                        'Tag',      'select', ...
                        'Units',    'characters',...
                        'Position', [72, 6, 47, 18]);     

        r.rightButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @toggleCallback, ...
                        'String',   'Add >', ...
                        'Tag',      'add', ...
                        'Units',    'characters',...
                        'Position', [57.5, 16, 10, 2]);   

        r.leftButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @toggleCallback, ...
                        'String',   'Delete', ...
                        'Tag',      'delete', ...
                        'Units',    'characters',...
                        'Position', [57.5, 12, 10, 2]);                

        r.nameText = uicontrol(r.fig, ...
                        'Style',    'Text', ...
                        'String',   'Name', ...
                        'Units',    'characters',...
                        'Position', [6, 2, 8, 1.5]); 

        r.editText = uicontrol(r.fig, ...
                        'Style',    'edit', ...
                        'String',   '(e.g. RP-1 Post Launch Data Review)', ...
                        'Tag',      'name', ...
                        'Units',    'characters', ...
                        'Position', [16, 2, 53, 2]);

        r.generateButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @generateCallback, ...
                        'String',   'Generate Structure', ...
                        'FontSize', 10, ...
                        'Tag',      'generate', ...
                        'Units',    'characters',...
                        'Position', [75, 2, 23, 2]); 
                    
        r.plotButton = uicontrol('Parent', r.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @plotCallback, ...
                        'String',   'Plot Graphs', ...
                        'FontSize', 10, ...
                        'Tag',      'toPlot', ...
                        'Units',    'characters',...
                        'Position', [102, 2, 20, 2]);                     
    end

guiOpeningFcn()
handles = guihandles(r.fig); 
handles.pathnames = {}; % Create empty handles fields to be populated in the callbacks
handles.filenames = {};
handles.graph = [];

guidata(r.fig, handles);

%% Variable Definitions

    plotFlag = false; % flag for checking if graph structure combined properly
    config = getConfig; % pulls configuration path files

%% Callback Functions
    
    function browseCallback( hObject, events, handles )
        handles = guidata(hObject);
        
        % User chooses the folder holding graph configs
        % You can switch browse folders after initial selection
        handles.path = uigetdir;
        handles.folder = fullfile(handles.path, '*.gcf');
        
        % The files and the file names are stored to the guidata and
        % updates the listbox string. 
        handles.files = dir(handles.folder); 
        fileList = string(cellstr({handles.files.name}')); 
        
        set(handles.contents,'String',fileList);
        set(handles.contents,'Value',1);
        drawnow
        
        guidata(hObject, handles)
    end
    
    function clearCallback( hObject, events, handles )
        handles = guidata(hObject);
        
        % Clears the listbox and all associated stored handles
        set(handles.select,'String','');
        handles.pathnames = {};
        handles.filenames = {};
        drawnow
        
        guidata(hObject, handles)
    end

    function toggleCallback( hObject, events, handles )
        handles = guidata(hObject);
        
        switch hObject.Tag
            case 'add'
                
                % Pull index of highlighted selection and pull associated
                % path and filename.
                index = handles.contents.Value; 
                selFileName = char(handles.contents.String(index,:));
                selPath = fullfile(handles.path,selFileName);
                
                % Store selection to guidata and create a list.
                handles.pathnames{end+1} = selPath;
                handles.filenames{end+1} = selFileName;
                
                % Update the listbox selection 
                handles.select.String = handles.filenames;
                
%                 if index == 1 %% is not a number?
%                     set(handles.contents,'Value',1);
%                 end
                
                drawnow
                
                guidata(hObject, handles);
                
            case 'delete'
                index = handles.select.Value;
                
                % Delete index file name and path based on selection.
                % Update the listbox string. 
                handles.pathnames(index) = [];
                handles.filenames(index) = [];
                
                handles.select.String = handles.filenames;
                
                % Reselect the next listbox value right above the deleted
                % object. 
                if index == 1
                    set(handles.contents,'Value',1);
                else
                    set(handles.contents,'Value',index-1);
                end
                
                drawnow
                
                guidata(hObject, handles);
        end
        
    end

    function generateCallback( hObject, events, handles )
        handles = guidata(hObject)
        
        % Load the files based on the pathname and concatenate it to a
        % graph structure. 
        for i = 1:length(handles.pathnames)
            dummy = load(handles.pathnames{i},'-mat');
            if i == 1
                graph = dummy.graph;
            else
                graph = [graph dummy.graph];
            end
        end   
        
        % Check if the graph structure length and # of paths match up 
        if length(handles.pathnames) == length(graph)
           plotFlag = true; 
           handles.graph = graph; % store to guidata
           guidata(hObject, handles)
        end
        
        if plotFlag
            % Pull the inputted string for the file name
            structName = handles.name.String; 
            
            % Following Code pulled from Counts' makeGraphGUI
            % clean up unhappy reserved filename characters
            structName = regexprep(structName,'^[!@$^&*~?.|/[]<>\`";#()]','');
            structName = regexprep(structName, '[:]','-');

            structName = char(structName);         
            
            % Attempt to autopopulate the path
            if isfield(config, 'graphConfigFolderPath')
                % Loads path from configuration
                lookInPath = config.graphConfigFolderPath;
            else
                % Set default path... to graph
                lookInPath = config.dataFolderPath;
            end    

            % Open UI for save name and path
            [file,path] = uiputfile('*.gcf','Save Graph Configuration as:',fullfile(lookInPath, structName));

            % Check the user didn't "cancel"
            if file ~= 0
                save(fullfile(path, file), 'graph', '-mat');
            end            
        end
    end

    function plotCallback ( hObject, events, handles )
        handles = guidata(hObject);
        
        % If there is no graph structure already in the guidata, open and
        % load a new one to plot. 
        if isempty(handles.graph)
            [file, path] = uigetfile('.gcf','Select Graph Structure');
            input = load(fullfile(path, file),'-mat');
            input = input.graph;
            
            plotGraphFromGUI(input);
            
        else
            % If the plotting command is executed with a graph structure
            % present, that structure is plotted. 
            plotGraphFromGUI(handles.graph)
        end
        
    end



end