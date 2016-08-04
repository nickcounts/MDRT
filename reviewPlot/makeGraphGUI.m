function varargout = makeGraphGUI(varargin)
% MAKEGRAPHGUI MATLAB code for makeGraphGUI.fig
%      MAKEGRAPHGUI, by itself, creates a new MAKEGRAPHGUI or raises the existing
%      singleton*.
%
%      H = MAKEGRAPHGUI returns the handle to a new MAKEGRAPHGUI or the handle to
%      the existing singleton*.
%
%      MAKEGRAPHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAKEGRAPHGUI.M with the given input arguments.
%
%      MAKEGRAPHGUI('Property','Value',...) creates a new MAKEGRAPHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before makeGraphGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to makeGraphGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help makeGraphGUI

% Last Modified by GUIDE v2.5 09-Oct-2014 18:46:24

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @makeGraphGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @makeGraphGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before makeGraphGUI is made visible.
function makeGraphGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to makeGraphGUI (see VARARGIN)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Initialization Code - Custom Behavior                  %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save('testGraphStruct.mat','graph')

% Load the project configuration (paths to data, plots and raw data)
    config = getConfig;
   % dataInfo = getDataIndex; % Do i need this if data already indexed? 
   
 
% Store configuration in handles structure    
    handles.configuration = config;

% Instantiate internal variables:
    handles.activeList = 1;
    
    
% --Want to change to passing FdStringNames and Paths instead of from config    
% Display the available data streams in the dropdown
%
% dataFromGUI = guidata(dataSearchToPlot);
% 
% handles.dataFromGUI = dataFromGUI;
% 
% FDList = dataFromGUI.newMasterFDList.names;
%  
% set(handles.ui_dropdown_dataStreamList, 'String', FDList);



if nargin
    if checkStructureType(varargin{1}) == 'masterFDList'
        handles.masterFDList = varargin{1};
    end
end

set(handles.ui_dropdown_dataStreamList, 'String', handles.masterFDList.names);



% Temporarily Assign a graph structure to graph variable for testing
% purposes
% load('testGraphStruct.mat')


% Start GUI with a new graph structure and populate GUI
    handles.graph = newGraphStructure;
    uiNewButton_ClickedCallback(hObject, eventdata, handles);
    handles.graph = returnGraphStructureFromGUI(handles);
    
    
% Update the window title to reflect the working data set
    handles.figure1.Name = makeDataSetTitleStringFromActiveConfig(config);
    handles.figure1.NumberTitle = 'off';

% Choose default command line output for makeGraphGUI
    handles.output = hObject;

    
    
% Update handles structure
    guidata(hObject, handles);

% UIWAIT makes makeGraphGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = makeGraphGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%               Listbox Creation and Callback Functions             %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in ui_listbox_streams1.
function ui_listbox_streams1_Callback(hObject, eventdata, handles)
% hObject    handle to ui_listbox_streams1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_streams1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_streams1
handles.activeList = 1;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ui_listbox_streams1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_listbox_streams1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in ui_listbox_streams2.
function ui_listbox_streams2_Callback(hObject, eventdata, handles)
% hObject    handle to ui_listbox_streams2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_streams2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_streams2
handles.activeList = 2;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ui_listbox_streams2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_listbox_streams2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in ui_listbox_streams3.
function ui_listbox_streams3_Callback(hObject, ~, handles)
% hObject    handle to ui_listbox_streams3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_streams3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_streams3
handles.activeList = 3;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function ui_listbox_streams3_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_graphTitle_Callback(hObject, ~, handles)
% Update graph.name with contents to prevent user frustration later!

    % Contents are a string -> directly assign contents
    handles.graph.name = get(hObject, 'String');
    
    guidata(hObject, handles);
    

% --- Executes during object creation, after setting all properties.
function ui_editBox_graphTitle_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_subplot1Title_Callback(hObject, eventdata, handles)
% % Update graph.name with contents to prevent user frustration later!
%     % Contents are a string -> directly assign contents as cell
%     handles.graph.subplots(1) = {get(hObject, 'String')};
%     guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ui_editBox_subplot1Title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_subplot2Title_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ui_editBox_subplot2Title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_subplot3Title_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ui_editBox_subplot3Title_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Update the GUI based on graph structure                %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function updateGUIfromGraphStructure(hObject, eventdata, handles)

% Updates the GUI elements with the current graph structure from handles

graph = handles.graph;

% Step 1: Graph Title
    set(handles.ui_editBox_graphTitle, 'String', graph.name)

% Step 2: Subplot Titles: (I know this is ugly code)
    if iscell(graph.subplots)
        % If graph.subplots is a cell array of strings, then multiple subplots:
        for i = 1:length(graph.subplots)
            switch i
                case 1
                    set(handles.ui_editBox_subplot1Title, 'String', graph.subplots(i));
                case 2
                    set(handles.ui_editBox_subplot2Title, 'String', graph.subplots(i));
                    set(handles.ui_checkbox_subplot2active, 'Value', true);
                case 3
                    set(handles.ui_editBox_subplot3Title, 'String', graph.subplots(i));
                    set(handles.ui_checkbox_subplot3active, 'Value', true);
            end
        end
    else
        % If graph.subplots is not cell array of strings, then only one subplot:
        set(handles.ui_editBox_subplot1Title, 'String', graph.subplots);
        set(handles.ui_editBox_subplot2Title, 'String', '');
        set(handles.ui_editBox_subplot2Title, 'String', '');
    end
    

% Step 3: Populate Subplot FDs (I know this is ugly code)
    for i = 1:size(handles.graph.streams,2)
        switch i
            case 1
                set(handles.ui_listbox_streams1, 'String', graph.streams(i).toPlot);
            case 2
                set(handles.ui_listbox_streams2, 'String', graph.streams(i).toPlot);
            case 3
                set(handles.ui_listbox_streams3, 'String', graph.streams(i).toPlot);
        end
    end

% Step 4: Clean up listbox selection values to fix display bug
% -------------------------------------------------------------------------

    makeListSelectionsValid(hObject, eventdata, handles);
    
% Step 5: Check for active subplots and disable lists and editboxes for
% inactive GUI sections

    ui_checkbox_subplot2active_Callback(hObject, eventdata, handles);
    ui_checkbox_subplot3active_Callback(hObject, eventdata, handles);




% --- Executes on button press in ui_checkbox_subplot2active.
function ui_checkbox_subplot2active_Callback(hObject, eventdata, handles)

    switch get(handles.ui_checkbox_subplot2active, 'Value')
        case 0
            % Disabled plot!
            % Listbox and Subplot Name to DISABLED
            set(handles.ui_listbox_streams2, 'Enable', 'off');
            set(handles.ui_editBox_subplot2Title, 'Enable', 'off');
            
            % Disable plot-swapping buttons for plot 2
            set(handles.ui_button_1to2, 'Enable', 'off');
            set(handles.ui_button_2to1, 'Enable', 'off');
            
            % Also force subplot 3 inactive, as 3 can't be on without 2
            set(handles.ui_checkbox_subplot3active, 'Value', 0);
            ui_checkbox_subplot3active_Callback(hObject, eventdata, handles);
            
        case 1
            % Enabled plot!
            set(handles.ui_listbox_streams2, 'Enable', 'on');
            set(handles.ui_editBox_subplot2Title, 'Enable', 'on');
            
            % Enable plot-swapping buttons for plot 2
            set(handles.ui_button_1to2, 'Enable', 'on');
            set(handles.ui_button_2to1, 'Enable', 'on');
 
    end

% --- Executes on button press in ui_checkbox_subplot3active.
function ui_checkbox_subplot3active_Callback(hObject, eventdata, handles)
    switch get(handles.ui_checkbox_subplot3active, 'Value')
        case 0
            % Disabled plot!
            % Listbox and Subplot Name to DISABLED
            set(handles.ui_listbox_streams3, 'Enable', 'off');
            set(handles.ui_editBox_subplot3Title, 'Enable', 'off');
            
            % Disable plot-swapping buttons for plot 3
            set(handles.ui_button_2to3, 'Enable', 'off');
            set(handles.ui_button_3to2, 'Enable', 'off');
            
        case 1
            % Enabled plot!
            set(handles.ui_listbox_streams3, 'Enable', 'on');
            set(handles.ui_editBox_subplot3Title, 'Enable', 'on');
            
            % Enable plot-swapping buttons for plot 3
            set(handles.ui_button_2to3, 'Enable', 'on');
            set(handles.ui_button_3to2, 'Enable', 'on');

            % Also force subplot 2 active, as 3 can't be on without 2
            set(handles.ui_checkbox_subplot2active, 'Value', 1);
            ui_checkbox_subplot2active_Callback(hObject, eventdata, handles);
    end




% --- Executes on selection change in ui_dropdown_dataStreamList.
function ui_dropdown_dataStreamList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ui_dropdown_dataStreamList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%              Add Data Stream Button Callback Function             %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in ui_button_addDataStream.
function ui_button_addDataStream_Callback(hObject, eventdata, handles)

% Bug Fix - Temporary: update graph structure from GUI first
    handles.graph = returnGraphStructureFromGUI(handles);

% set index for which listbox we are using
    i = handles.activeList;


% Get the selected FD from the dropdown
% Generate FD from filename
% -------------------------------------------------------------------------

    index = get(handles.ui_dropdown_dataStreamList,'Value');
    
%     fdFileName = handles.quickPlotFDs{index, 2}; % where does quickplotFDs come from??
    fdFileName = handles.masterFDList.names{index};
    fdDataSetPath = handles.masterFDList.names{index}
   
    
    newFD = fdFileName(1:end-4);


% Make new streams structure to update graphs structure
% -------------------------------------------------------------------------

    tempStreams = handles.graph.streams;
    
    % This avoids indexing errors for structure array streams(i).toPlot by
    % populating a missing but needed array.
    if length(tempStreams) < i
        tempStreams(i).toPlot = {};
    end
    
    % creates a copy of the streams variable (with an added blank toPlot
    % struct if required.
    oldStreams = tempStreams(i).toPlot;
        if isempty(oldStreams)
            oldStreams = {};
        end
    newStreams = { oldStreams{:} newFD };

    % update graph.streams with the newly constructed newStreams
    handles.graph.streams(i).toPlot = newStreams;

    % update the handles structure
    guidata(hObject, handles);

% Fix GUI selection bug for listboxes
% -------------------------------------------------------------------------

    makeListSelectionsValid(hObject, eventdata, handles);

% refresh the GUI
    updateGUIfromGraphStructure(hObject, eventdata, handles);
    
    
    
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%              Generate Graph Button Callback Function              %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ui_button_generateGraph_Callback(hObject, eventdata, handles)

% Step 1: Check for empty GUI fields and warn


    GUIwarnings = {};

    if isempty(get(handles.ui_editBox_graphTitle, 'String'))
        % main graph title is missing!
        GUIwarnings(end + 1) = {'graph_title'};
    end


    % Validate Subplot 1 GUI is complete
    if isempty(get(handles.ui_editBox_subplot1Title, 'String'))
            % subplot 1 has no title
            GUIwarnings(end + 1) = {'subplot_title'};
    end

    if isempty(get(handles.ui_listbox_streams1, 'String'))
        % subplot 2 has no data to plot
        GUIwarnings(end + 1) = {'subplot_data'};
    end

    % Validate Subplot 2 GUI is complete
    if get(handles.ui_checkbox_subplot2active, 'Value')
        if isempty(get(handles.ui_editBox_subplot2Title, 'String'))
            % subplot 2 is on with no title
            GUIwarnings(end + 1) = {'subplot_title'};
        end

        if isempty(get(handles.ui_listbox_streams2, 'String'))
            % subplot 2 is active but no data to plot
            GUIwarnings(end + 1) = {'subplot_data'};
        end
    end

    % Validate Subplot 3 GUI is complete
    if get(handles.ui_checkbox_subplot3active, 'Value')
        if isempty(get(handles.ui_editBox_subplot3Title, 'String'))
            % subplot 3 is on with no title
            GUIwarnings(end + 1) = {'subplot_title'};
        end

        if isempty(get(handles.ui_listbox_streams3, 'String'))
            % subplot 3 is active but no data to plot
            GUIwarnings(end + 1) = {'subplot_data'};
        end

    end

    GUIwarnings = unique(GUIwarnings);

    if length(GUIwarnings)
        % There are warnings - generate message and deal with them

        mainErrorMessage = {'WARNING: Missing Information Detected'};
        
        for n = 1:length(GUIwarnings)
            switch GUIwarnings{n}
                case 'subplot_data'
                    mainErrorMessage(end + 1) = {'* Subplot has no data to plot.'};
                case 'subplot_title'
                    mainErrorMessage(end + 1) = {'* Subplot title is missing.'};
                case 'graph_title'
                    mainErrorMessage(end + 1) = {'* Main graph title is missing.'};
            end
        end

        % Construct a questdlg with three options
        choice = questdlg(mainErrorMessage, ...
            'Graph Configuration Warning', ...
            'Fix Errors','Ignore','Fix Errors');
        
        % Handle response
        switch choice
            case 'Fix Errors'
                return
            case 'Ignore'
        end

    else
        % There are no warnings - proceed to next step

    end

disp('Still in the GRAPH function')

% Step 2: Validate graph structure
% -------------------------------------------------------------------------
 
    % Call update the graph structure from the GUI - NO ERROR CHECKS
    graph = returnGraphStructureFromGUI(handles);
    
% Step 3: Call plotting engine with graph structure

    % DUMMY OPTIONS VARIABLE TO BE IMPLEMENTED LATER
    options = 5;
    keyboard
    
    % Need to load timeline file to pass to plotGraphFromGui
    
    index = 5 % need to find which index? is this streams?
    pathToDataSet = handles.masterFDList.pathsToDataSet{index};
    
    load(fullfile(pathToDataSet,'timeline.mat'));
%   timeline is loaded, can be passed to plotGraphFromGui

    plotGraphFromGUI(graph, timeline);
    %--> changed from ^^ (graph,options) to (graph,timeline) ^^
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Delete Data Stream Button Callback Function            %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ui_button_deleteDataStream_Callback(hObject, eventdata, handles)

    % set index for which listbox we are using
        i = handles.activeList;
    
    
    % Make new streams structure to update graphs structure
    % -------------------------------------------------------------------------

        tempStreams = handles.graph.streams;

        oldStreams = tempStreams(i).toPlot;
        
        switch i
            case 1
                index = get(handles.ui_listbox_streams1, 'Value');
            case 2
                index = get(handles.ui_listbox_streams2, 'Value');
            case 3
                index = get(handles.ui_listbox_streams3, 'Value');
        end
        
        
            if isempty(oldStreams)
                oldStreams = {};
            else
                oldStreams(index) = [];
            end
            
        newStreams = oldStreams;

        handles.graph.streams(i).toPlot = newStreams;

        guidata(hObject, handles);

    % Fix GUI selection bug for listboxes
    % -------------------------------------------------------------------------

        makeListSelectionsValid(hObject, eventdata, handles);

    % refresh the GUI
        updateGUIfromGraphStructure(hObject, eventdata, handles);

    



% --- Executes on button press in ui_button_moveDataStreamUp.
function ui_button_moveDataStreamUp_Callback(hObject, eventdata, handles)

[list, index]=getActiveListSelection(handles);

if exist('index') && index > 1
    templist = list;
    
    % Swap index and the value above it
    templist(index)     = list(index - 1);
    templist(index-1)   = list(index);
    
    % Change list to the re-ordered templist
    list = templist;
    
    % Shift the index to keep the selected list item
    index = index - 1;
end

setActiveListSelection(handles, list, index)




% --- Executes on button press in ui_button_moveDataStreamDown.
function ui_button_moveDataStreamDown_Callback(hObject, eventdata, handles)
[list, index]=getActiveListSelection(handles);

if exist('index') && index < length(list)
    templist = list;
    
    % Swap index and the value above it
    templist(index)     = list(index + 1);
    templist(index + 1)   = list(index);
    
    % Change list to the re-ordered templist
    list = templist;
    
    % Shift the index to keep the selected list item
    index = index + 1;
end

setActiveListSelection(handles, list, index)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Callbacks for clicking inside listboxes                %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ui_listbox_streams3_ButtonDownFcn(hObject, eventdata, handles)
    handles.activeList = 3;
    disp('inside 3')

function ui_listbox_streams2_ButtonDownFcn(hObject, eventdata, handles)
    handles.activeList = 2;
    disp('inside 2')

function ui_listbox_streams1_ButtonDownFcn(hObject, eventdata, handles)
    handles.activeList = 1;
    disp('inside 1')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Button Callbacks to rearrange FDs in the GUI               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ui_button_1to2_Callback(hObject, eventdata, handles)
    from = 1;
    to = 2;
    swapListItemFromTo(handles, from, to);


function ui_button_2to1_Callback(~, eventdata, handles)
    from = 2;
    to = 1;
    swapListItemFromTo(handles, from, to);


function ui_button_2to3_Callback(hObject, eventdata, handles)
    from = 2;
    to = 3;
    swapListItemFromTo(handles, from, to);


function ui_button_3to2_Callback(hObject, eventdata, handles)
    from = 3;
    to = 2;
    swapListItemFromTo(handles, from, to);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                 Do Cleanup on Listbox Selections                  %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function makeListSelectionsValid(hObject, eventdata, handles)

    for i = 1:3

        switch i
            case 1
                value = get(handles.ui_listbox_streams1, 'Value');
                entries = length(get(handles.ui_listbox_streams1, 'String'));

            case 2
                value = get(handles.ui_listbox_streams2, 'Value');
                entries = length(get(handles.ui_listbox_streams2, 'String'));

            case 3
                value = get(handles.ui_listbox_streams3, 'Value');
                entries = length(get(handles.ui_listbox_streams3, 'String'));
        end
        
        % Fix the selection
        % ---------------------------------------------------------------------

        if entries == 0
            % The only time value = [] is valid is if there are no entries
            value = [];
            
        elseif isempty(value)
            % The valid isempty(value) case is dealt with above. All other
            % instances of isempty(value) are invalid. Setting to default
            % value = 1
            value = 1;
            
        elseif value == 0
            % All value = 0 cases are invalid and are converted to a 
            % default and are converted to a default of value = 1 (with 
            % the value = [] case already explicitley handled.
            value = 1;
            
        elseif value > entries
            % If value is greater than entries, then invalid selection.
            % Setting value to entries results in selecting the last item
            % in the list.
            value = entries;
            
        else
            % All other cases should be valid selections. Nothing to do
        end
                


        % Re-assign listbox Values to clean up selection bug
        % ---------------------------------------------------------------------

        switch i
            case 1
                set(handles.ui_listbox_streams1, 'Value', value);
            case 2
                set(handles.ui_listbox_streams2, 'Value', value);
            case 3
                set(handles.ui_listbox_streams3, 'Value', value);
        end

    end


    % FIX THSISSSSISISISIS !!!!!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                 Return Graph Structure from GUI                   %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function graph = returnGraphStructureFromGUI(handles)
% Does not contain error hadnling or valid structure checks
keyboard
% Initialize variables:
    graph = handles.graph;
    dataStreams = [];
    streams = [];

% Step 1: Update Graph Title and All Subplot Titles

graphName = get(handles.ui_editBox_graphTitle, 'String');
    
    % Subplot 1 Parameters
    % ---------------------------------------------------------------------
            graphSubplotNames = getEditboxContents(handles.ui_editBox_subplot1Title);
            dataStreams = get(handles.ui_listbox_streams1,'String')';
            
            index = get(handles.ui_listbox_streams1,'Value');
            string = handles.ui_listbox_streams1.String{index};
keyboard
            for i = 1:length(handles.masterFDList.names);

                if strcmp(string,handles.masterFDList.names(i));
                    newIndex = i;
                end
            end

            dataStreams = handles.masterFDList.paths{5};
            streams(1).toPlot = dataStreams;
    keyboard
    % Subplot 2 Parameters
    % ---------------------------------------------------------------------
        if get(handles.ui_checkbox_subplot2active, 'Value')
            graphSubplotNames(end + 1) = getEditboxContents(handles.ui_editBox_subplot2Title);
            dataStreams = get(handles.ui_listbox_streams2,'String')'; 
            streams(2).toPlot = dataStreams;
        else
        end
        
    % Subplot 3 Parameters
    % ---------------------------------------------------------------------
        if get(handles.ui_checkbox_subplot3active, 'Value')
            graphSubplotNames(end + 1) = getEditboxContents(handles.ui_editBox_subplot3Title);
            dataStreams = get(handles.ui_listbox_streams3,'String')';
            streams(3).toPlot = dataStreams;
        else
        end
        
        
        
% Step 2: Rebuild graph structure and refresh handles structure

    graph.name = graphName;
    graph.subplots = graphSubplotNames;
    graph.streams = streams;
    % TODO: Implement start/stop time handling.
    % graph.time = timeLimits;
        
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                  Callbacks for Toolbar Buttons                    %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Save Graph Configuration Button Callback               %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function uiSaveButton_ClickedCallback(hObject, eventdata, handles)

    

    % Retrieve graph structure to be saved from GUI elements
    graph = returnGraphStructureFromGUI(handles);
    
    % Generate default filename from graph structure
    defaultName = graph.name;

        % clean up unhappy reserved filename characters
        defaultName = regexprep(defaultName,'^[!@$^&*~?.|/[]<>\`";#()]','');
        defaultName = regexprep(defaultName, '[:]','-');
        
        % Guarantee defaultName is a string
        if iscell(defaultName)
            defaultName = defaultName{1};
        end
        
        
    % Attempt to autopopulate the path
    if isfield(handles.configuration, 'graphConfigFolderPath')
        % Loads path from configuration
        lookInPath = handles.configuration.graphConfigFolderPath;
        disp(lookInPath)
    else
        % Set default path... to graph
        lookInPath = handles.configuration.dataFolderPath;
    end    
    
    % Open UI for save name and path
    [file,path] = uiputfile('*.gcf','Save Graph Configuration as:',fullfile(lookInPath, defaultName));

    % Check the user didn't "cancel"
    if file ~= 0
        save(fullfile(path, file), 'graph', '-mat');
    else
        % Cancelled... not sure what the best behavior is... return to GUI
    end


% -------------------------------------------------------------------------
function uiLoadButton_ClickedCallback(hObject, eventdata, handles)

% Attempt to autopopulate the path


    if isfield(handles.configuration, 'graphConfigFolderPath')
        % Loads path from configuration
        lookInPath = handles.configuration.graphConfigFolderPath;
        disp(lookInPath)
    else
        % Set default path... to graph
        lookInPath = handles.configuration.dataFolderPath;
    end
    
    


    % Open UI Window to Choolse Graph Config File
    [filename, pathname, filterindex] = uigetfile( ...
            {  '*.gcf',         'Graph Config File (*.gcf)'; ...
               '*.xlsx',        'Excel file (*.xlsx)'; ...
               '*.xls',         'Excel file (*.xls)'; ...
               '*.*',           'All Files (*.*)'}, ...
               [fullfile(lookInPath,'*.gcf')], 'Pick a file');
   
  
    switch filterindex
        case 1
            % selected a *.gcf file
            % graph = load(fullfile(pathname, filename),'-mat');
            load(fullfile(pathname, filename),'-mat');
        case 2,3
            % selected an excel file
            % TODO: Implement excel file parsing
        case 4
            % it could be anything, oh no!
            % TODO: Implement file type checking...
            % graph = load(fullfile(pathname, filename),'-mat');
            load(fullfile(pathname, filename),'-mat');
        otherwise
            % graph = load(fullfile(pathname, filename),'-mat');
            load(fullfile(pathname, filename),'-mat');
    end
    
    
    
    % Store new graph structure
    handles.graph = graph;
    
    % Update the GUI data for visibility in other functions
    guidata(hObject, handles);

    % Re-populate the GUI fields with the new graph structure
    updateGUIfromGraphStructure(hObject, eventdata, handles);
    

% -------------------------------------------------------------------------
function uiNewButton_ClickedCallback(hObject, eventdata, handles)

% Start with the default graph structure
    handles.graph = newGraphStructure;
    guidata(hObject, handles);
    
% Clear the current GUI inputs
    clearGUIdata(handles);
% Populate the GUI with graph
    updateGUIfromGraphStructure(hObject, eventdata, handles);




% Blanks all GUI UI Elements
function clearGUIdata(handles)

% Checkboxes cleared
    set(handles.ui_checkbox_subplot2active, 'Value', 0);
    set(handles.ui_checkbox_subplot3active, 'Value', 0);

% Subplot Title Edit Boxes
    set(handles.ui_editBox_subplot1Title, 'String', '');
    set(handles.ui_editBox_subplot2Title, 'String', '');
    set(handles.ui_editBox_subplot3Title, 'String', '');

% Main Graph Title Edit Box
    set(handles.ui_editBox_graphTitle, 'String', '');

% Clear listboxes and fix the selection
    set(handles.ui_listbox_streams1, 'String', '', 'Value', []);
    set(handles.ui_listbox_streams2, 'String', '', 'Value', []);
    set(handles.ui_listbox_streams3, 'String', '', 'Value', []);

% Returns the list and selection from the currently selected list
function [list, index] = getActiveListSelection(handles)
    i = handles.activeList;
    
        switch i
            case 1
                index = get(handles.ui_listbox_streams1, 'Value');
                list = get(handles.ui_listbox_streams1, 'String');

            case 2
                index = get(handles.ui_listbox_streams2, 'Value');
                list = get(handles.ui_listbox_streams2, 'String');

            case 3
                index = get(handles.ui_listbox_streams3, 'Value');
                list = get(handles.ui_listbox_streams3, 'String');
        end

% Populates the active list (last selected) with the supplied list and
% index
function setActiveListSelection(handles, list, index)
i = handles.activeList;
    
        switch i
            case 1
                set(handles.ui_listbox_streams1, 'Value', index);
                set(handles.ui_listbox_streams1, 'String', list);

            case 2
                set(handles.ui_listbox_streams2, 'Value', index);
                set(handles.ui_listbox_streams2, 'String', list);

            case 3
                set(handles.ui_listbox_streams3, 'Value', index);
                set(handles.ui_listbox_streams3, 'String', list);
        end

% returns the list and index of the specified list
function [list, index] = getTargetListSelection(handles, listNumber)
    
        switch listNumber
            case 1
                index = get(handles.ui_listbox_streams1, 'Value');
                list = get(handles.ui_listbox_streams1, 'String');

            case 2
                index = get(handles.ui_listbox_streams2, 'Value');
                list = get(handles.ui_listbox_streams2, 'String');

            case 3
                index = get(handles.ui_listbox_streams3, 'Value');
                list = get(handles.ui_listbox_streams3, 'String');
        end
        
% Populates the specified list with the supplied list and index        
function setTargetListSelection(handles, listNumber, list, index)
    
        switch listNumber
            case 1
                set(handles.ui_listbox_streams1, 'Value', index);
                set(handles.ui_listbox_streams1, 'String', list);

            case 2
                set(handles.ui_listbox_streams2, 'Value', index);
                set(handles.ui_listbox_streams2, 'String', list);

            case 3
                set(handles.ui_listbox_streams3, 'Value', index);
                set(handles.ui_listbox_streams3, 'String', list);
        end
        
% Moves the selected item in list "from" to list "to" with error checking
function swapListItemFromTo(handles, from, to)

selected = handles.activeList;

if selected == from
    % The active list matches the direction of transfer so the swap can
    % proceed. Otherwise, nothing to do.
    
    % Get the relevant lists and indices
    [fromList, fromIndex] = getTargetListSelection(handles, from);
    [toList,   toIndex]   = getTargetListSelection(handles, to);
     
    % Prevents trying to move a nonexistant list item
    if ~isempty(fromList)
        
        % Make temporary copies to modify
        tempToList    = toList;
        tempFromList  = fromList;

        tempToIndex   = toIndex;
        tempFromIndex = fromIndex;

        % Remove the item from the starting list
        tempFromList(fromIndex) = [];

        % Modify the index of the starting list
        if fromIndex > 1 && length(tempFromList)
            tempFromIndex = fromIndex - 1;
        elseif length(tempFromList) == 0
            tempFromIndex = [];
        end


        % Append the item to the target list
        tempToList(end + 1) = fromList(fromIndex)

        % Modify the index of the target list
        tempToIndex = length(tempToList)
        
        % Populate the GUI elements with the new lists and indices
        setTargetListSelection(handles, from, tempFromList, tempFromIndex);
        setTargetListSelection(handles, to,   tempToList,   tempToIndex);
    
    end
    
end


function contents = getEditboxContents(handle)
    contents = get(handle, 'String');
    if ischar(contents)
        contents = {contents};
    end
    
    

        