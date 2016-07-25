function varargout = reviewPlot(varargin)
% REVIEWPLOT MATLAB code for reviewPlot.fig
%      REVIEWPLOT, by itself, creates a new REVIEWPLOT or raises the existing
%      singleton*.
%
%      H = REVIEWPLOT returns the handle to a new REVIEWPLOT or the handle to
%      the existing singleton*.
%
%      REVIEWPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEWPLOT.M with the given input arguments.
%
%      REVIEWPLOT('Property','Value',...) creates a new REVIEWPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reviewPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reviewPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reviewPlot

% Last Modified by GUIDE v2.5 20-Jan-2014 03:21:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reviewPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @reviewPlot_OutputFcn, ...
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

% --- Executes just before reviewPlot is made visible.
function reviewPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reviewPlot (see VARARGIN)

% Choose default command line output for reviewPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using reviewPlot.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
    
    
    XLim = get(handles.axes1,'XLim');
    YLim = get(handles.axes1,'YLim');
    
    set(handles.uiTextbox_yMax,'String',max(YLim));
    set(handles.uiTextbox_yMin,'String',min(YLim));
    set(handles.uiTextbox_xMax,'String',min(XLim));
    set(handles.uiTextbox_xMin,'String',max(XLim));
    
end

% UIWAIT makes reviewPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reviewPlot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function uiTextbox_yMax_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_yMax as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_yMax as a double

    YLim = get(handles.axes1,'YLim');
    
    switch isnan(str2double(get(hObject,'String')))
        case true
            % Not a number, process as a date/time string
            
        case false
            % Is a number, direct update
            Y = str2double(get(hObject,'String'));
    end

    if Y > YLim(1)
        YLim(2) = Y;
        set(handles.axes1,'YLim',YLim);
    else
        set(hObject,'String',YLim(2));
    end
    
    
    
    guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function uiTextbox_yMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiTextbox_yMin_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_yMin as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_yMin as a double
    YLim = get(handles.axes1,'YLim');
    
    switch isnan(str2double(get(hObject,'String')))
        case true
            % Not a number, process as a date/time string
            
        case false
            % Is a number, direct update
            Y = str2double(get(hObject,'String'));
    end

    if Y < YLim(2)
        YLim(1) = Y;
        set(handles.axes1,'YLim',YLim);
    else
        set(hObject,'String',YLim(1));
    end
    
    
    
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uiTextbox_yMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiTextbox_xMax_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_xMax as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_xMax as a double
    XLim = get(handles.axes1,'XLim');
    
    switch isnan(str2double(get(hObject,'String')))
        case true
            % Not a number, process as a date/time string
            
        case false
            % Is a number, direct update
            X = str2double(get(hObject,'String'));
    end

    if X > XLim(1)
        XLim(2) = X;
        set(handles.axes1,'XLim',XLim);
    else
        set(hObject,'String',XLim(2));
    end
    
    
    
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uiTextbox_xMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiTextbox_xMin_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_xMin as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_xMin as a double
    XLim = get(handles.axes1,'XLim');
    
    switch isnan(str2double(get(hObject,'String')))
        case true
            % Not a number, process as a date/time string
            
        case false
            % Is a number, direct update
            X = str2double(get(hObject,'String'));
    end

    if X < XLim(2)
        XLim(1) = X;
        set(handles.axes1,'XLim',XLim);
    else
        set(hObject,'String',XLim(1));
    end
    
    
    
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function uiTextbox_xMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in uiCheckbox_xIsTime.
function uiCheckbox_xIsTime_Callback(hObject, eventdata, handles)
% hObject    handle to uiCheckbox_xIsTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uiCheckbox_xIsTime



function uiTextbox_xLabel_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_xLabel as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_xLabel as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_xLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_xLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiTextbox_yLabel_Callback(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiTextbox_yLabel as text
%        str2double(get(hObject,'String')) returns contents of uiTextbox_yLabel as a double


% --- Executes during object creation, after setting all properties.
function uiTextbox_yLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTextbox_yLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
