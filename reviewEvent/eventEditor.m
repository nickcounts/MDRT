function varargout = eventEditor(varargin)
% EVENTEDITOR1 MATLAB code for eventEditor1.fig
%      EVENTEDITOR1, by itself, creates a new EVENTEDITOR1 or raises the existing
%      singleton*.
%
%      H = EVENTEDITOR1 returns the handle to a new EVENTEDITOR1 or the handle to
%      the existing singleton*.
%
%      EVENTEDITOR1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EVENTEDITOR1.M with the given input arguments.
%
%      EVENTEDITOR1('Property','Value',...) creates a new EVENTEDITOR1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eventEditor1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eventEditor1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eventEditor1

% Last Modified by GUIDE v2.5 10-Jun-2016 15:11:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eventEditor1_OpeningFcn, ...
                   'gui_OutputFcn',  @eventEditor1_OutputFcn, ...
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


% --- Executes just before eventEditor1 is made visible.
function eventEditor1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eventEditor1 (see VARARGIN)

% Load my own variables for testing

% load ORB-1 timeline datafile as .mat


% Check for timeline.mat in default location and load if exists.
% Otherwise, instantiate a default timeline.mat structure

% setappdata(0, 'reviewConfigStruct', config)

% Read the shared configuration variable (assuming launched from review
% config = getappdata(0, 'reviewConfigStruct');



% This is where I put my initialization code
% -------------------------------------------------------------------------
    config = getConfig;

    handles.config = config;


    
% Debugging purposes: load existant timeline file.
% load('~/Documents/MATLAB/Data Review/ORB-1/data/timeline.mat')


% Constant Definitions
% -------------------------------------------------------------------------

% path to data folder definition
    path = config.dataFolderPath;
    
% timeline file name    
    timelineFile = 'timeline.mat';

    
% add information to the handles structure for later use!
    handles.config.dataFolderPath = path;




% Check for existing timeline.mat file in the working data directory and
% load if exists
% -------------------------------------------------------------------------
    if exist(fullfile(path, timelineFile),'file')
        load([path timelineFile]);
    else
        % timeline file not found
        timeline = newTimelineStructure;
        msgbox([{'No timeline file found'};
                {'Starting with default'};
                {'timeline structure'}], ...
                'Missing timeline.mat');
    end

handles.timeline = timeline;

    t0Month  = month(timeline.t0.time);
    t0Day    = day(timeline.t0.time);
    t0Year   = year(timeline.t0.time);

    t0Hour   = hour(timeline.t0.time);
    t0Minute = minute(timeline.t0.time);
    t0Second = second(timeline.t0.time);

% Call subroutine to enter all values from valid file
eventEditor_pre_populate_GUI(handles)

% Choose default command line output for eventEditor1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eventEditor1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eventEditor1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;












% --- Executes on selection change in ui_eventListBox.
function ui_eventListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ui_eventListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_eventListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_eventListBox

eventIndex = get(hObject, 'Value');
handles.timeline.milestone(eventIndex);

t = handles.timeline.milestone(eventIndex).Time;

tm = num2cell([month(t) day(t) year(t) hour(t) minute(t) second(t)]);
[eMonth, eDay, eYear, eHour, eMinute, eSecond] = deal(tm{:}); 

% Populate the UI with known values
set(handles.ui_popup_eventMonthPicker,  'Value',    eMonth);
set(handles.ui_editBox_eventDay,        'String',   eDay);
set(handles.ui_editBox_eventYear,       'String',   eYear);

set(handles.ui_editBox_eventHour,       'String',   eHour);
set(handles.ui_editBox_eventMinute,     'String',   eMinute);
set(handles.ui_editBox_eventSecond,     'String',   eSecond);



set(handles.ui_editBox_eventNameString, 'String',   handles.timeline.milestone(eventIndex).String);
set(handles.ui_editBox_eventTriggerFD, 'String',   handles.timeline.milestone(eventIndex).FD);

% Calculate the T +/- for the given event
 dt = handles.timeline.milestone(eventIndex).Time - handles.timeline.t0.time;
    if dt < 0
        % Negative delta means T-
        eTimeModifier = '-';
    else
        % Positive delta means T+
        eTimeModifier = '+';
    end
    
% eventString = sprintf('T%s%s %s', eTimeModifier, datestr(abs(dt), 'HH:MM:SS'),handles.timeline.milestone(eventIndex).String);


dt = abs(dt);

% Assign T+/- values to working variables
etm = num2cell([month(dt) day(dt) year(dt) hour(dt) minute(dt) second(dt)]);
[eeMonth, eeDay, eeYear, eeHour, eeMinute, eeSecond] = deal(etm{:});














% --- Executes during object creation, after setting all properties.
function ui_eventListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_eventListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ui_popup_monthPicker.
function ui_popup_monthPicker_Callback(hObject, eventdata, handles)
% hObject    handle to ui_popup_monthPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_popup_monthPicker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_popup_monthPicker


% --- Executes during object creation, after setting all properties.
function ui_popup_monthPicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_popup_monthPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_day_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_day as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_day as a double


% --- Executes during object creation, after setting all properties.
function ui_editBox_day_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_year_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_year as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_year as a double

    updateT0fromGUI(hObject, handles);
    
    keyboard


% --- Executes during object creation, after setting all properties.
function ui_editBox_year_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_year (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_hour_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_hour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_hour as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_hour as a double


% --- Executes during object creation, after setting all properties.
function ui_editBox_hour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_hour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_minute_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_minute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_minute as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_minute as a double


% --- Executes during object creation, after setting all properties.
function ui_editBox_minute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_minute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_second_Callback(hObject, ~, handles)
    set(hObject, 'String', returnStringWithoutWhitespace(get(hObject, 'String')));




% --- Executes during object creation, after setting all properties.
function ui_editBox_second_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventDay_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function ui_editBox_eventDay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventYear_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventYear as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventYear as a double
    set(hObject, 'String', returnStringWithoutWhitespace(get(hObject, 'String')));
    
    



% --- Executes during object creation, after setting all properties.
function ui_editBox_eventYear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventHour_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventHour as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventHour as a double
    set(hObject, 'String', returnStringWithoutWhitespace(get(hObject, 'String')));



% --- Executes during object creation, after setting all properties.
function ui_editBox_eventHour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventMinute_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventMinute as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventMinute as a double
    set(hObject, 'String', returnStringWithoutWhitespace(get(hObject, 'String')));



% --- Executes during object creation, after setting all properties.
function ui_editBox_eventMinute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventSecond_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventSecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventSecond as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventSecond as a double

    set(hObject, 'String', returnStringWithoutWhitespace(get(hObject, 'String')));

% --- Executes during object creation, after setting all properties.
function ui_editBox_eventSecond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventSecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ui_popup_eventMonthPicker.
function ui_popup_eventMonthPicker_Callback(hObject, eventdata, handles)
% hObject    handle to ui_popup_eventMonthPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_popup_eventMonthPicker contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_popup_eventMonthPicker


% --- Executes during object creation, after setting all properties.
function ui_popup_eventMonthPicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_popup_eventMonthPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Called on GUI start to populate the values if a valid timeline.mat file
% is found.
function eventEditor_pre_populate_GUI(handles)


    t0Month  = month(handles.timeline.t0.time);
    t0Day    = day(handles.timeline.t0.time);
    t0Year   = year(handles.timeline.t0.time);

    t0Hour   = hour(handles.timeline.t0.time);
    t0Minute = minute(handles.timeline.t0.time);
    t0Second = second(handles.timeline.t0.time);

    monthList = {'01 Jan', '02 Feb', '03 Mar', '04 Apr', ...
                 '05 May', '06 Jun', '07 Jul', '08 Aug', ...
                 '09 Sep', '10 Oct', '11 Nov', '12 Dec'};

    set(handles.ui_popup_monthPicker, 'String', monthList);
    set(handles.ui_popup_eventMonthPicker, 'String', monthList);

% Populate the GUI with available data

% Set T0 information
    set(handles.ui_popup_monthPicker,   'Value' , t0Month);
    set(handles.ui_editBox_year,        'String', t0Year);
    set(handles.ui_editBox_day,         'String', t0Day);

    set(handles.ui_editBox_hour,   'String', t0Hour);
    set(handles.ui_editBox_minute, 'String', t0Minute);
    set(handles.ui_editBox_second, 'String', t0Second);


% Set event information with the T0 info as default
    set(handles.ui_popup_eventMonthPicker,  'Value',    t0Month);
    set(handles.ui_editBox_eventDay,        'String',   t0Day);
    set(handles.ui_editBox_eventYear,       'String',   t0Year);

    set(handles.ui_editBox_eventHour,       'String',   t0Hour);
    set(handles.ui_editBox_eventMinute,     'String',   t0Minute);
    set(handles.ui_editBox_eventSecond,     'String',   t0Second);

set(handles.ui_eventListBox, 'String', {handles.timeline.milestone(:).String}');


function setEventTimeGUIValuesFromNumericArray ( MDYhms, handles )
% Looks for a cell array of the form [month day year hour minute second)

% TODO: Add matrix or cell checking

    set(handles.ui_popup_eventMonthPicker,  'Value',	MDYhms{1});
    set(handles.ui_editBox_eventDay,        'String',   sprintf('%i',MDYhms{2}));
    set(handles.ui_editBox_eventYear,       'String',   sprintf('%i',MDYhms{3}));

    set(handles.ui_editBox_eventHour,       'String',   sprintf('%i',MDYhms{4}));
    set(handles.ui_editBox_eventMinute,     'String',   sprintf('%i',MDYhms{5}));   
    set(handles.ui_editBox_eventSecond,     'String',   sprintf('%.3f',MDYhms{6}));



% --- Executes on button press in ui_button_commitChange.
function ui_button_commitChange_Callback(hObject, ~, handles)

% Update t0 from GUI
updateT0fromGUI(hObject, handles);

    disp(sprintf('ui_button_commitChange_Callback 1: %s', datestr(handles.timeline.t0.time)));


% Get event values from GUI
et0Month  = get(handles.ui_popup_eventMonthPicker,  'Value');
et0Day    = get(handles.ui_editBox_eventDay,        'String');
et0Year   = get(handles.ui_editBox_eventYear,       'String');

et0Hour   = get(handles.ui_editBox_eventHour,       'String');
et0Minute = get(handles.ui_editBox_eventMinute,     'String');
et0Second = get(handles.ui_editBox_eventSecond,     'String');



% validate input type
if validDateTime([et0Day et0Year et0Hour et0Minute et0Second])
    % Update the structure
    newDateString = [num2str(et0Month) '-' et0Day '-' et0Year ' ' et0Hour ':' et0Minute ':' et0Second];
    
    eventIndex = get(handles.ui_eventListBox, 'Value');
    
    handles.timeline.milestone(eventIndex).Time = datenum(newDateString);
    
    guidata(hObject,handles);
    
else
    % Do NOT update the structure. 
end



% Update FD and String
handles.timeline.milestone(eventIndex).FD = handles.ui_editBox_eventTriggerFD.String;
handles.timeline.milestone(eventIndex).String = handles.ui_editBox_eventNameString.String;

guidata(hObject, handles);

eventEditor_pre_populate_GUI(handles)






function isValid = validDateTime (t)


v = ismember(t,'0123456789+-.eED');

% for i = 1:length(t)
%     % loop through each entry and confirm numeric
%     v(i) = all(ismember(t{i},'0123456789+-.eED'));
% end

isValid = all(v);

if ~isValid
    h = msgbox('Timestamp is invalid. Please check your input', 'Error','error');
end 




function ui_editBox_eventNameString_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventNameString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventNameString as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventNameString as a double


% --- Executes during object creation, after setting all properties.
function ui_editBox_eventNameString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventNameString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ui_editBox_eventTriggerFD_Callback(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventTriggerFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_editBox_eventTriggerFD as text
%        str2double(get(hObject,'String')) returns contents of ui_editBox_eventTriggerFD as a double


% --- Executes during object creation, after setting all properties.
function ui_editBox_eventTriggerFD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_editBox_eventTriggerFD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ui_button_copyT0DateToEvent.
function ui_button_copyT0DateToEvent_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_copyT0DateToEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t0Month  = get(handles.ui_popup_monthPicker,  'Value');
t0Day    = get(handles.ui_editBox_day,        'String');
t0Year   = get(handles.ui_editBox_year,       'String');

% TODO: Deal with UTC vs non-UTC!!!
t0date = floor(handles.timeline.t0.time);



for i = 1:max(size(handles.timeline.milestone))
    
    t = handles.timeline.milestone(i).Time;
    time = t-floor(t);
    
    newDay = t0date + time;

    handles.timeline.milestone(i).Time = newDay;
end

guidata(hObject,handles);

ui_eventListBox_Callback(hObject, eventdata, handles);




% --- Executes on button press in ui_button_pasteCCTTimeStamp.
function ui_button_pasteCCTTimeStamp_Callback(hObject, eventdata, handles)


% TODO : Validate that pasted string is of the following form:
% 2014/194/10:20:48.080690
    eventIndex = get(handles.ui_eventListBox, 'Value');

    cctString = clipboard('paste');

    % TODO : Check for isUTC and isDST and pass variables to
    % makeMatlabTimeVector()
    t = makeMatlabTimeVector({cctString}, false, false);

    % Update the timeline structure with the new datenum
    handles.timeline.milestone(eventIndex).Time = t;

    % Matrix-ize to numericals to update the GUI also!
    tm = num2cell([month(t) day(t) year(t) hour(t) minute(t) second(t)]);

    % Update the GUI
    setEventTimeGUIValuesFromNumericArray(tm, handles);

    % Update the handles structure to save changes
    guidata(hObject,handles);


%%  Time Settings Panel Callbacks
% -------------------------------------------------------------------------

function checkbox_UseT0_Callback(hObject, eventdata, handles)

    if get(hObject, 'Value')
        useT0 = 'on';
    else
        useT0 = 'off';
    end

    set(handles.ui_popup_monthPicker,   'Enable', useT0);
    set(handles.ui_editBox_day,         'Enable', useT0);
    set(handles.ui_editBox_year,        'Enable', useT0);
    set(handles.ui_editBox_hour,        'Enable', useT0);
    set(handles.ui_editBox_minute,      'Enable', useT0);
    set(handles.ui_editBox_second,      'Enable', useT0);
    
    
% --- Executes when selected object is changed in uipanel_timeZone.
function uipanel_timeZone_SelectionChangeFcn(hObject, ~, handles)

    % Toggle daylight savings time checkbox based on UTC vs Local time
    if strcmp(get(hObject,'String'), 'UTC')
        % Disable the daylight savings time checkbox
        set(handles.checkbox_DST, 'Enable', 'off');
    else
        % Enable the daylight savings time checkbox
        set(handles.checkbox_DST, 'Enable', 'on');
    end
    
    
    
     
    
    
% --- Executes on button press in uiAddEventButton.
function uiAddEventButton_Callback(hObject, eventdata, handles)
    
    timeline = handles.timeline;
    milestone = handles.timeline.milestone;
    selected = handles.ui_eventListBox.Value;

    list = handles.ui_eventListBox.String;
    
    % Generate new event contents;
    newTimeline = newTimelineStructure;
    newMilestone = newTimeline.milestone;
    
    if timeline.uset0
        newMilestone.Time = timeline.t0.time;
    else
        newMilestone.Time = today;
    end
    
    % add new timeline event to the structure

    handles.timeline.milestone(end+1) = newMilestone;
    
    guidata(hObject, handles);
    
    eventEditor_pre_populate_GUI(handles)
    
    % Add new line:
    
    
    
    
% --- Executes on button press in uiDeleteEventButton.
function uiDeleteEventButton_Callback(hObject, eventdata, handles)
% hObject    handle to uiDeleteEventButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Get Current Selection Index
    selected = handles.ui_eventListBox.Value;
    eventList = handles.ui_eventListBox.String;

% Remove timeline.milestone(index)
    eventStructArray = handles.timeline.milestone;
    eventStructArray(selected) = [];
    
% Make sure the selected index is still valid (fix if it isn't)
    if length(eventStructArray) <= selected
        keyboard
        selected = length(eventStructArray);
        handles.ui_eventListBox.Value = selected;
    else
        % The selection should still be valid, so don't do anything
    end

% Update the GUI Display
    handles.ui_eventListBox.String = {eventStructArray.String}';
    
% Store the updated timeline in the handles structure
    guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%  Event Options Panel Callbacks
% -------------------------------------------------------------------------

% --- Executes on button press in uibutton_allowEditing.
function uibutton_allowEditing_Callback(hObject, eventdata, handles)

    if get(hObject, 'Value')
        editingAllowed = 'on';
    else
        editingAllowed = 'off';
    end

    set(handles.ui_editBox_eventNameString, 'Enable', editingAllowed);
    set(handles.ui_editBox_eventTriggerFD,  'Enable', editingAllowed);


   
    
% Update the handles.timeline structure from the GUI
% -------------------------------------------------------------------------

function getTimelineFromGUI(handles)

    timeline = handles.timeline;

    isUTC = get(handles.radiobuttion_UTC, 'Value');
    isDST = get(handles.checkbox_DST, 'Value');
    useT0 = get(handles.checkbox_UseT0, 'Value');

    timeline.uset0 = useT0;
    timeline.t0.utc = isUTC;
    timeline.t0.dst = isDST;
    
    
function newString = returnStringWithoutWhitespace(originalString)
    
%     newString = regexprep(originalString,'[^\w'']','');
    newString = originalString(originalString~=' ');
    
function updateT0fromGUI(hObject, handles)

    M = get(handles.ui_popup_monthPicker,   'Value');
    D = get(handles.ui_editBox_day,         'String');
    Y = get(handles.ui_editBox_year,        'String');
    h = get(handles.ui_editBox_hour,        'String');
    m = get(handles.ui_editBox_minute,      'String');
    s = get(handles.ui_editBox_second,      'String');
    
    dateString = [num2str(M) '-' D '-' Y ' ' h ':' m ':' s];
    
    datestamp = datenum(dateString);
    
    handles.timeline.t0.time = datestamp;
    
    disp(sprintf('updateT0fromGUI 1: %s', datestr(handles.timeline.t0.time)));
    
    guidata(hObject, handles);
    
    disp(sprintf('updateT0fromGUI 2: %s', datestr(handles.timeline.t0.time)));
    

    
    
    


% --------------------------------------------------------------------
function uiToolbar_saveButton_ClickedCallback(hObject, eventdata, handles)
% retrieve the current working directory from the handles structure
% What hapens if this isn't there!?

    path = handles.config.dataFolderPath;
    timelineFile = 'timeline.mat';

    % Bring up the save-as dialog prepopulated with the current working
    % directory and the default filename
    [file,path] = uiputfile('*.mat','Save timeline file as:',fullfile(path, timelineFile));
    
    if file
        % User did not hit cancel
        % grab the variable to save
        timeline = handles.timeline; %#ok<NASGU>
        
        keyboard

        save(fullfile(path,file),'timeline')
    else
        % User hit cancel button
        disp('User cancelled save');
    end