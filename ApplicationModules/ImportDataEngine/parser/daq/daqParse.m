function varargout = daqParse(varargin)
% DAQPARSE MATLAB code for daqParse.fig
%      DAQPARSE, by itself, creates a new DAQPARSE or raises the existing
%      singleton*.
%
%      H = DAQPARSE returns the handle to a new DAQPARSE or the handle to
%      the existing singleton*.
%
%      DAQPARSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAQPARSE.M with the given input arguments.
%
%      DAQPARSE('Property','Value',...) creates a new DAQPARSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before daqParse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to daqParse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help daqParse

% Last Modified by GUIDE v2.5 28-Oct-2015 10:57:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @daqParse_OpeningFcn, ...
                   'gui_OutputFcn',  @daqParse_OutputFcn, ...
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


% --- Executes just before daqParse is made visible.
function daqParse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to daqParse (see VARARGIN)

% Choose default command line output for daqParse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes daqParse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = daqParse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openDaqFileToParse(handles);

function openDaqFileToParse(handles)
    [fileName, processPath] = uigetfile( {...
                            '*.csv', 'Comma Separated'; ...
                            '*.*',     'All Files (*.*)'}, ...
                            'Pick a file', '*.csv');

    % Was a file selected?
    if isnumeric(fileName)
        % User cancelled .delim pre-parse
        disp('User cancelled .delim pre-parse');
        return
    end
    
    handles.fileName = fileName;
    handles.processPath = processPath;
          
    % Open the file selected above
    % -------------------------------------------------------------------------
    fid = fopen(fullfile(processPath,fileName));

    linesOfPreview = 10;

    previewCell = textscan(fid, '%s', linesOfPreview, 'Delimiter', '\n');
    
    set(handles.listbox1, 'String', previewCell{1});



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileNameEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to fileNameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileNameEditBox as text
%        str2double(get(hObject,'String')) returns contents of fileNameEditBox as a double


% --- Executes during object creation, after setting all properties.
function fileNameEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileNameEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1



function numHeaderLinesEdit_Callback(hObject, eventdata, handles)
% hObject    handle to numHeaderLinesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numHeaderLinesEdit as text
%        str2double(get(hObject,'String')) returns contents of numHeaderLinesEdit as a double


% --- Executes during object creation, after setting all properties.
function numHeaderLinesEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numHeaderLinesEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numChannelsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to numChannelsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numChannelsEdit as text
%        str2double(get(hObject,'String')) returns contents of numChannelsEdit as a double


% --- Executes during object creation, after setting all properties.
function numChannelsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numChannelsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10
