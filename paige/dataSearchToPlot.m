function varargout = dataSearchToPlot(varargin)
% DATASEARCHTOPLOT MATLAB code for dataSearchToPlot.fig
%      DATASEARCHTOPLOT, by itself, creates a new DATASEARCHTOPLOT or raises the existing
%      singleton*.
%
%      H = DATASEARCHTOPLOT returns the handle to a new DATASEARCHTOPLOT or the handle to
%      the existing singleton*.
%
%      DATASEARCHTOPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATASEARCHTOPLOT.M with the given input arguments.
%
%      DATASEARCHTOPLOT('Property','Value',...) creates a new DATASEARCHTOPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataSearchToPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataSearchToPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataSearchToPlot

% Last Modified by GUIDE v2.5 11-Jul-2016 14:34:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataSearchToPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @dataSearchToPlot_OutputFcn, ...
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



% --- Executes just before dataSearchToPlot is made visible.
function dataSearchToPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataSearchToPlot (see VARARGIN)



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%                                                                   %%%%
% %%%%            Initialization Code - Custom Behavior                  %%%%
% %%%%                                                                   %%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 

% Start GUI with a new graph structure and populate GUI
%     handles.graph = newGraphStructure;
% %   uiNewButton_ClickedCallback(hObject, eventdata, handles);
%     handles.graph = returnGraphStructureFromGUI(handles);

% Choose default command line output for dataSearchToPlot
handles.output = hObject;

% Add custum handles
handles.startDateValue = [];
handles.endDateValue = [];

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes dataSearchToPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataSearchToPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%>>>----------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function start_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% displayStartDate

% --- Executes on button press in StartDate_pushbutton3.
function StartDate_pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to StartDate_pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

startDate =  guiDatePicker(now);
handles.startDateValue = startDate;

% Display selected date in edit text box
startDateString = datestr(startDate);

% uh=uicontrol('position',[0.154,0.87,0.226,0.056],'style','edit','string',startDateString);
% startDisplay =uicontrol('position',[104,320,100,30],'style','edit','string',startDateString)

handles.start_textbox.String = startDateString;

% Update handle list ----
guidata(hObject, handles);

function start_edit_Callback(hObject, eventdata, handles)
% hObject    handle to start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_edit as text
%        str2double(get(hObject,'String')) returns contents of start_edit as a double
% displayStartDate

%>>>-----------------------------------------------------------------------


function end_edit_Callback(hObject, eventdata, handles)
% hObject    handle to end_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_edit as text
%        str2double(get(hObject,'String')) returns contents of end_edit as a double


% --- Executes during object creation, after setting all properties.
function end_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in EndDate_pushbutton4.
function EndDate_pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to EndDate_pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


endDate =  guiDatePicker(now);
handles.endDateValue = endDate;

% Display selected date in edit text box
endDateString = datestr(endDate);

% uh=uicontrol('position',[0.154,0.87,0.226,0.056],'style','edit','string',startDateString);
% startDisplay =uicontrol('position',[104,320,100,30],'style','edit','string',startDateString)

handles.end_textbox.String = endDateString;

guidata(hObject,handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
handles.activeList = 1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ConfigPlot_pushbutton1.
function ConfigPlot_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigPlot_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in QuickPlot_pushbutton2.
function QuickPlot_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to QuickPlot_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RP1_radiobutton1.
function RP1_radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to RP1_radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RP1_radiobutton1


% --- Executes on button press in LO2_radiobutton2.
function LO2_radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to LO2_radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LO2_radiobutton2


% --- Executes on button press in LN2_radiobutton4.
function LN2_radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to LN2_radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LN2_radiobutton4


% --- Executes on button press in GN2_radiobutton5.
function GN2_radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to GN2_radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GN2_radiobutton5


% --- Executes on button press in GHE_radiobutton6.
function GHE_radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to GHE_radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GHE_radiobutton6


% --- Executes on button press in AIR_radiobutton7.
function AIR_radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to AIR_radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AIR_radiobutton7



% --- Executes on button press in WDS_radiobutton8.
function WDS_radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to WDS_radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WDS_radiobutton8


% --- Executes on button press in dateSearch_pushbutton5.
function dateSearch_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to dateSearch_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = handles.startDateValue;
% --- Staten's search function
statenSearchFunction(time)
% --- call handles containing 2 datenums
% --- Store into time array
% --- input into staten's function
% --- Output array of structures
% --- Call function to display list in drop down menu



function start_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to start_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_textbox as text
%        str2double(get(hObject,'String')) returns contents of start_textbox as a double


% --- Executes during object creation, after setting all properties.
function start_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to end_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_textbox as text
%        str2double(get(hObject,'String')) returns contents of end_textbox as a double


% --- Executes during object creation, after setting all properties.
function end_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
