function varargout = Data_Import_GUI(varargin)
% DATA_IMPORT_GUI MATLAB code for Data_Import_GUI.fig
%      DATA_IMPORT_GUI, by itself, creates a new DATA_IMPORT_GUI or raises the existing
%      singleton*.
%
%      H = DATA_IMPORT_GUI returns the handle to a new DATA_IMPORT_GUI or the handle to
%      the existing singleton*.
%
%      DATA_IMPORT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_IMPORT_GUI.M with the given input arguments.
%
%      DATA_IMPORT_GUI('Property','Value',...) creates a new DATA_IMPORT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Import_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Import_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Import_GUI

% Last Modified by GUIDE v2.5 05-Sep-2016 05:50:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Import_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Import_GUI_OutputFcn, ...
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


% --- Executes just before Data_Import_GUI is made visible.
function Data_Import_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_Import_GUI (see VARARGIN)

% Choose default command line output for Data_Import_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_Import_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Data_Import_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_folderName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_folderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_folderName as text
%        str2double(get(hObject,'String')) returns contents of edit_folderName as a double


% --- Executes during object creation, after setting all properties.
function edit_folderName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_folderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_newDataImportSession.
function button_newDataImportSession_Callback(hObject, eventdata, handles)
% hObject    handle to button_newDataImportSession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox_filesToProcess.
function listbox_filesToProcess_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_filesToProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_filesToProcess contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_filesToProcess


% --- Executes during object creation, after setting all properties.
function listbox_filesToProcess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_filesToProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_selectFiles.
function button_selectFiles_Callback(hObject, eventdata, handles)
% hObject    handle to button_selectFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox_autoName.
function checkbox_autoName_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autoName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autoName


% --- Executes on button press in checkbox_vehicleSupport.
function checkbox_vehicleSupport_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_vehicleSupport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_vehicleSupport


% --- Executes on button press in checkbox_marsProcedure.
function checkbox_marsProcedure_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_marsProcedure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_marsProcedure


% --- Executes on button press in checkbox_isOperation.
function checkbox_isOperation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_isOperation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_isOperation


% --- Executes on button press in checkbox_marsUID.
function checkbox_marsUID_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_marsUID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_marsUID



function edit_operationName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_operationName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_operationName as text
%        str2double(get(hObject,'String')) returns contents of edit_operationName as a double


% --- Executes during object creation, after setting all properties.
function edit_operationName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_operationName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_marsProcedure_Callback(hObject, eventdata, handles)
% hObject    handle to edit_marsProcedure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_marsProcedure as text
%        str2double(get(hObject,'String')) returns contents of edit_marsProcedure as a double


% --- Executes during object creation, after setting all properties.
function edit_marsProcedure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_marsProcedure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_marsUID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_marsUID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_marsUID as text
%        str2double(get(hObject,'String')) returns contents of edit_marsUID as a double


% --- Executes during object creation, after setting all properties.
function edit_marsUID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_marsUID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_importData.
function button_importData_Callback(hObject, eventdata, handles)
% hObject    handle to button_importData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
