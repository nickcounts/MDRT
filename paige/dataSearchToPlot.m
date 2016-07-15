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

% Last Modified by GUIDE v2.5 13-Jul-2016 08:30:57

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


% --- Executes on selection change in FDList_popupmenu.
function FDList_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to FDList_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FDList_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FDList_popupmenu
handles.activeList = 1;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function FDList_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FDList_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ConfigPlot_pushbutton.
function ConfigPlot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ConfigPlot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in QuickPlot_pushbutton2.
function QuickPlot_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to QuickPlot_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ---> Test the 'paigeQuickPlot' version of reviewQuickPlot with a
% ---> preloaded dummy data file
index = get(handles.FDList_popupmenu,'Value');
fdFileName = fullfile(handles.configuration.dataFolderPath, handles.quickPlotFDs{index,2});
% fdFilePath = '/Users/Paige/Documents/MARS Matlab/Data Repository/2014-01-09 - ORB-1/data/1014.mat';
% fdFileName = handles.activeList(index,2);
% fdFileName = '1014.mat';

figureNumber = paigeQuickPlot( fdFileName); 
% If there is an events.mat file, then pass and plot t0
% if exist([handles.configuration.dataFolderPath 'timeline.mat'],'file')
%     load([handles.configuration.dataFolderPath 'timeline.mat'],'-mat')
%     
%     
%     
%     figureNumber  = paigeQuickPlot( fdFileName, handles.configuration, timeline);
% 
% else
%     
%     
% 
% end
guidata(hObject, handles);



% --- Executes on button press in RP1_radiobutton.
function RP1_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to RP1_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RP1_radiobutton
display('So you wanna filter by RP-1 eh?')


% --- Executes on button press in LO2_radiobutton.
function LO2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to LO2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LO2_radiobutton


% --- Executes on button press in LN2_radiobutton.
function LN2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to LN2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LN2_radiobutton


% --- Executes on button press in GN2_radiobutton.
function GN2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to GN2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GN2_radiobutton


% --- Executes on button press in GHE_radiobutton.
function GHE_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to GHE_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GHE_radiobutton


% --- Executes on button press in AIR_radiobutton.
function AIR_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to AIR_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AIR_radiobutton



% --- Executes on button press in WDS_radiobutton.
function WDS_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to WDS_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WDS_radiobutton



% --------------------> STATEN SEARCH FUNTION <----------------------- %
% --- Executes on button press in dateSearch_pushbutton5.
function dateSearch_pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to dateSearch_pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

time = [handles.startDateValue, handles.endDateValue];
% Check to make sure dates are in correct order
% ---> TAKE OUT COMMAND WINDOW WARNING
if handles.startDateValue > handles.endDateValue 
    display('Warning! Your start date is after your end date. That is not how time works!')
    dateWarningDialog
    %--- STATEN TO DO : Automatically switch times - warning not needed
else
% --- Staten's search function
[FDList] = statenSearchFunction(time);
handles.FDList_popupmenu.String = FDList(:,1);
end




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

% --- Helper Function to display warning dialog after Search Button is
% selected - Displays if dates are entered backwards.
function dateWarningDialog
    d = dialog('Position',[300 300 250 150],'Name','WARNING');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Warning! The End Date is before your Start Date. That is not how time works!');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
