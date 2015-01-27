function varargout = graphConfig(varargin)
% GRAPHCONFIG MATLAB code for graphConfig.fig
%      GRAPHCONFIG, by itself, creates a new GRAPHCONFIG or raises the existing
%      singleton*.
%
%      H = GRAPHCONFIG returns the handle to a new GRAPHCONFIG or the handle to
%      the existing singleton*.
%
%      GRAPHCONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHCONFIG.M with the given input arguments.
%
%      GRAPHCONFIG('Property','Value',...) creates a new GRAPHCONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graphConfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graphConfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graphConfig

% Last Modified by GUIDE v2.5 03-Oct-2014 08:15:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graphConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @graphConfig_OutputFcn, ...
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


% --- Executes just before graphConfig is made visible.
function graphConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graphConfig (see VARARGIN)






% Load the project configuration (paths to data, plots and raw data)
config = getConfig;

    handles.configuration.outputFolderPath    = config.outputFolderPath;
    handles.configuration.dataFolderPath      = config.dataFolderPath;
    handles.configuration.delimFolderPath     = config.delimFolderPath;

% Generate a default graph structure and add it to the GUI handles
handles.graph = newGraphStructure;

% Populate the list of graph structure elements
graphItemList = {'Subplot','Data Stream','Time Bounds'};
set(handles.ui_popup_graphItem, 'String',graphItemList);

% Display the current graph structure in the list window
updateGraphConfigList(hObject, handles)



% Display the available data streams in the dropdown
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



% Choose default command line output for graphConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graphConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = graphConfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ui_textBox_graphTitle_Callback(hObject, eventdata, handles)
% hObject    handle to ui_textBox_graphTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_textBox_graphTitle as text
%        str2double(get(hObject,'String')) returns contents of ui_textBox_graphTitle as a double


% --- Executes during object creation, after setting all properties.
function ui_textBox_graphTitle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_textBox_graphTitle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ui_listbox_graphConfigList.
function ui_listbox_graphConfigList_Callback(hObject, eventdata, handles)
% hObject    handle to ui_listbox_graphConfigList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_graphConfigList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_graphConfigList


% --- Executes during object creation, after setting all properties.
function ui_listbox_graphConfigList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_listbox_graphConfigList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ui_button_remove.
function ui_button_remove_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ui_popup_graphItem.
function ui_popup_graphItem_Callback(hObject, eventdata, handles)
% hObject    handle to ui_popup_graphItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_popup_graphItem contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_popup_graphItem


% --- Executes during object creation, after setting all properties.
function ui_popup_graphItem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_popup_graphItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Begin GUI Helper Functions 
% These functions provide the basic mechanics of updating the GUI fields as
% the user navigates the fields.

% Update the listbox contents to match the graph structure
function updateGraphConfigList(hObject, handles)

% TODO: Implement error handling for graph structures of invalid form. This
% routine will only handle single figure graph structures. Currently assume
% this is the case, as we are creating the initial structure.


% set(handles.ui_listbox_graphConfigList,'String',{'Unnamed Subplot'})
set(handles.ui_textBox_graphTitle, 'String', handles.graph.name);

graphConfigList = {};

% Steps for unpacking the graph structure
% 1) The .name
graphConfigList{end + 1} = handles.graph.name
% 2) For each .subplot
for sub = 1:size(handles.graph.subplots,1)
    graphConfigList{end + 1} = handles.graph.subplots(sub,:)
% 3) List the appropriate .streams

    if isempty(handles.graph.streams)
        % Special case - no streams assigned. Nothing to add to the configList
    else
        for dat = 1:length(handles.graph.streams(sub))
            % Loop through each stream for the selected subplot
            graphConfigList{end + 1} = handles.graph.streams(sub,dat);
        end
    end
    

% TODO
% 4) Unpack time

end

        

set(handles.ui_listbox_graphConfigList,'String',graphConfigList)






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
