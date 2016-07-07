function varargout = review(varargin)
% REVIEW MATLAB code for review.fig
%      REVIEW, by itself, creates a new REVIEW or raises the existing
%      singleton*.
%
%      H = REVIEW returns the handle to a new REVIEW or the handle to
%      the existing singleton*.
%
%      REVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEW.M with the given input arguments.
%
%      REVIEW('Property','Value',...) creates a new REVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before review_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to review_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%   Modified for cross-platform support
%
%   Counts, Spaceport Support Services 2014
%


% Edit the above text to modify the response to help review

% Last Modified by GUIDE v2.5 27-May-2016 14:09:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @review_OpeningFcn, ...
                   'gui_OutputFcn',  @review_OutputFcn, ...
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


% --- Executes just before review is made visible.
function review_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to review (see VARARGIN)

% Choose default command line output for review
handles.output = hObject;

% This is where I put my initialization code
% -------------------------------------------------------------------------
config = getConfig;
    
    % Add configuration struct to the handles struct
    handles.configuration = config;

    % populate the initial GUI text fields
    set(handles.uiTextbox_outputFolderTextbox, 'String', config.outputFolderPath);
    set(handles.uiTextbox_dataFolderTextbox, 'String', config.dataFolderPath);
    set(handles.uiTextbox_delimFolderTextbox, 'String', config.delimFolderPath);
    set(handles.uiTextbox_graphConfigFolderTextbox, 'String', config.graphConfigFolderPath);
    
    
% Instantiate handles.quickPlotFDs as type cell
handles.quickPlotFDs = cell(1);


% TODO:  Check the data path for a timeline.mat file and set the plotting
% engine flags accordingly (the plotGraphFromGUI function does this
% checking now)

% Looks for the following file to populate the FD List... In the future I
% might store more information here. Possibly valid times:
%
% AvailableFDs.mat

if exist(fullfile(config.dataFolderPath, 'AvailableFDs.mat'),'file')
   
    load(fullfile(config.dataFolderPath, 'AvailableFDs.mat'),'-mat');
    
    % Add the loaded list to the GUI handles structure
    handles.quickPlotFDs = FDList;
    
    % add the list to the GUI menu
    set(handles.uiPopup_FDList, 'String', FDList(:,1));
    
else
    
    % TODO: Should this do something if the file isn't there... maybe do
    % the initial parsing? That might be bad for the user experience...

end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes review wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = review_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function uiTextbox_delimFolderTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_delimFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_delimFolderTextbox as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_delimFolderTextbox as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_delimFolderTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_delimFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiButton_delimFolderBrowse.
function uiButton_delimFolderBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_delimFolderBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delimFolderPath = uigetdir(fullfile(handles.configuration.delimFolderPath,'..'));

% Make sure the user selected something!
if delimFolderPath ~= 0
    % We got a path selection. Now append the trailing / for linux
    % Note, we are not implementing OS checking at this time (isunix, ispc)
    delimFolderPath = [delimFolderPath '/'];
    handles.configuration.delimFolderPath = delimFolderPath;
    set(handles.uiTextbox_delimFolderTextbox, 'String', delimFolderPath);
else
    % oh noes, there was nothing selected!
    % right now I won't do anything... maybe later I will?
end
guidata(hObject, handles);



function uiTextbox_dataFolderTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_dataFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_dataFolderTextbox as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_dataFolderTextbox as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_dataFolderTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_dataFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiButton_dataFolderBrowse.
function uiButton_dataFolderBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_dataFolderBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dataFolderPath = uigetdir(fullfile(handles.configuration.dataFolderPath,'..'));

% Make sure the user selected something!
if dataFolderPath ~= 0
    % We got a path selection. Now append the trailing / for linux
    % Note, we are not implementing OS checking at this time (isunix, ispc)
    dataFolderPath = [dataFolderPath '/'];
    handles.configuration.dataFolderPath = dataFolderPath;
    set(handles.uiTextbox_dataFolderTextbox, 'String', dataFolderPath);
    % Use existing FD list to update GUI on folder change
    populateFDlistFromDataFolder(hObject, handles, dataFolderPath);
else
    % oh noes, there was nothing selected!
    % right now I won't do anything... maybe later I will?
end

guidata(hObject, handles);


function uiTextbox_outputFolderTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_outputFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_outputFolderTextbox as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_outputFolderTextbox as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_outputFolderTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_outputFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiButton_outputFolderBrowse.
function uiButton_outputFolderBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_outputFolderBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

outputFolderPath = uigetdir(fullfile(handles.configuration.outputFolderPath,'..'));

% Make sure the user selected something!
if outputFolderPath ~= 0
    % We got a path selection. Now append the trailing / for linux
    % Note, we are not implementing OS checking at this time (isunix, ispc)
    outputFolderPath = [outputFolderPath '/'];
    
    handles.configuration.outputFolderPath = outputFolderPath;
    
    set(handles.uiTextbox_outputFolderTextbox, 'String', outputFolderPath);
    
    
else
    % oh noes, there was nothing selected!
    % right now I won't do anything... maybe later I will?
end
guidata(hObject, handles);


% --- Executes on button press in uiButton_saveProjectConfig.
function uiButton_saveProjectConfig_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_saveProjectConfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This does NO ERROR CHECKING!!!!
config = handles.configuration;
% save('review.cfg','config'); ### modified for cross-platform
% compatability. 
% TODO: Implement path checking and always save in program directory.
% Current implementation could break if browsing the file hiegherarchy with
% MATLAB in the background

if isdeployed
    save('review.cfg','config');
else
    save(fullfile(pwd,'review.cfg'),'config');
end


% --- Executes on button press in uiButton_processDelimFiles.
function uiButton_processDelimFiles_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_processDelimFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

config = handles.configuration;

if ( exist(config.dataFolderPath,'dir') && exist(config.delimFolderPath,'dir') )
    % Confirmed that these folders DO EXIST
    processDelimFiles(config);
    
    % Refresh the FD list
    uiButton_updateFDList_Callback(hObject, eventdata, handles);
    
else
    % Uh-OH!!! One of those folders was bad!
    % TODO: Error handling - popup error dialog?
end
    


% --- Executes on button press in uiButton_quickPlotFD.
function uiButton_quickPlotFD_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_quickPlotFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



index = get(handles.uiPopup_FDList,'Value');
fdFileName = handles.quickPlotFDs{index, 2};


% If there is an events.mat file, then pass and plot t0
if exist([handles.configuration.dataFolderPath 'timeline.mat'],'file')
    load([handles.configuration.dataFolderPath 'timeline.mat'],'-mat')
    
    
    
    figureNumber = reviewQuickPlot( fdFileName, handles.configuration, timeline);

else
    
    figureNumber = reviewQuickPlot( fdFileName, handles.configuration);

end



% --- Executes on selection change in uiPopup_FDList.
function uiPopup_FDList_Callback(hObject, eventdata, handles)
% hObject    handle to uiPopup_FDList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns uiPopup_FDList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from uiPopup_FDList


% --- Executes during object creation, after setting all properties.
function uiPopup_FDList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiPopup_FDList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiButton_updateFDList.
function uiButton_updateFDList_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_updateFDList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls helper function to list the FDs
    FDList = listAvailableFDs(handles.configuration.dataFolderPath, 'mat');
    
    
    
    if ~isempty(FDList)

        % adds to the GUI handles and
            handles.quickPlotFDs = FDList;

        % updates the dropdown.
            set(handles.uiPopup_FDList, 'String', FDList(:,1))

        % Write the new list to disk
            save(fullfile(handles.configuration.dataFolderPath, 'AvailableFDs.mat'),'FDList');
            
    else
        
        % updates the dropdown.
            set(handles.uiPopup_FDList, 'String', ' ');
            set(handles.uiPopup_FDList, 'Value', 1);
    end
        

guidata(hObject, handles);


% --- Executes on button press in uiButton_refreshTimelineEvents.
function uiButton_refreshTimelineEvents_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_refreshTimelineEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reviewRescaleAllTimelineEvents;

% --- Executes on button press in uiButton_toggleTimelineLabelSize.
function uiButton_toggleTimelineLabelSize_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_toggleTimelineLabelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reviewRescaleAllTimelineLabels


% --- Executes on button press in uiButton_saveQuickPlot.
function uiButton_saveQuickPlot_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_saveQuickPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Launch the GUI that saves stuff
reviewSavePlot


% --- Executes on button press in uiButton_plotSetup.
function uiButton_plotSetup_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_plotSetup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

makeGraphGUI;


% --- Executes on button press in uiButton_editTimelineEvents.
function uiButton_editTimelineEvents_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_editTimelineEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eventEditor;

% --------------------------------------------------------------------
function menu_review_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_review_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in uiButton_helpButton.
function uiButton_helpButton_Callback(hObject, eventdata, handles)

% popup an "about" dialog with version info.
% TODO: Add a "quickstart" guide

helpDialogTitle = 'About Review Tool';
helpDialogMessage = {'MARS Review Tool beta'; ...
                     '10-8-2014'; ...
                     'Quickstart guide coming soon'};

helpdlg(helpDialogMessage,helpDialogTitle);



function uiTextbox_graphConfigFolderTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_graphConfigFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_graphConfigFolderTextbox as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_graphConfigFolderTextbox as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_graphConfigFolderTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_graphConfigFolderTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiButton_graphConfigFolderBrowse.
function uiButton_graphConfigFolderBrowse_Callback(hObject, ~, handles)
graphConfigFolder = uigetdir(fullfile(handles.configuration.graphConfigFolderPath));

% Make sure the user selected something!
if graphConfigFolder ~= 0
    % We got a path selection. Now append the trailing / for linux
    % Note, we are not implementing OS checking at this time (isunix, ispc)
    graphConfigFolder = fullfile(graphConfigFolder);
    
    % Set the local configuration structure
    handles.configuration.graphConfigFolderPath = graphConfigFolder;
    
    % Populate the textbox
    set(handles.uiTextbox_graphConfigFolderTextbox, 'String', graphConfigFolder);
    
    
else
    % oh noes, there was nothing selected!
    % right now I won't do anything... maybe later I will?
end

% Update the GUI handles object
    guidata(hObject, handles);


% --- Executes on button press in uiButton_splitDelims.
function uiButton_splitDelims_Callback(~, ~, handles)
% hObject    handle to uiButton_splitDelims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

splitDelimFiles(handles.configuration);

function populateFDlistFromDataFolder(hObject, handles, folder)

    if exist(fullfile(folder, 'AvailableFDs.mat'),'file')

        load(fullfile(folder, 'AvailableFDs.mat'),'-mat');

        % Add the loaded list to the GUI handles structure
        handles.quickPlotFDs = FDList;

        % add the list to the GUI menu
        set(handles.uiPopup_FDList, 'String', FDList(:,1));

    else

        % TODO: Should this do something if the file isn't there... maybe do
        % the initial parsing? That might be bad for the user experience...

    end
    
    guidata(hObject, handles);
    


% --- Executes on button press in ui_newDataButton.
function ui_newDataButton_Callback(hObject, eventdata, handles)

    rootGuess = handles.configuration.dataFolderPath;
    
    if exist(fullfile(rootGuess),'dir')
        
    else
        rootGuess = pwd;
    end
    
    rootFolder = uigetdir(fullfile(rootGuess,'..'));

    % Make sure the user selected something!
    if rootFolder ~= 0
        % We got a path selection. Now append the trailing / for linux
        % Note, we are not implementing OS checking at this time (isunix, ispc)
        dataFolderPath = [rootFolder '/'];
        handles.configuration.dataFolderPath = dataFolderPath;
        set(handles.uiTextbox_dataFolderTextbox, 'String', dataFolderPath);
        % Use existing FD list to update GUI on folder change
        populateFDlistFromDataFolder(hObject, handles, dataFolderPath);
    else
        % oh noes, there was nothing selected!
        return
    end
    
    newDataPath  = fullfile(rootFolder, 'data',  filesep);
    newDelimPath = fullfile(rootFolder, 'delim', filesep);
    newPlotPath  = fullfile(rootFolder, 'plots', filesep);

    % Create new directory structure    
    mkdir(newDataPath);
    mkdir(newDelimPath);
    mkdir(fullfile(newDelimPath, 'original'));
    mkdir(fullfile(newDelimPath, 'ignore'));
    mkdir(newPlotPath);
    
    % Update the handles structure
    handles.configuration.dataFolderPath    = newDataPath;
    handles.configuration.delimFolderPath   = newDelimPath;
    handles.configuration.outputFolderPath  = newPlotPath;
    
    % populate the initial GUI text fields
    set(handles.uiTextbox_dataFolderTextbox, 'String', newDataPath);
    set(handles.uiTextbox_delimFolderTextbox, 'String', newDelimPath);
    set(handles.uiTextbox_outputFolderTextbox, 'String', newPlotPath);

    % Refresh the FD list
    uiButton_updateFDList_Callback(hObject, eventdata, handles);
    
    guidata(hObject, handles);