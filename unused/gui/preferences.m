function varargout = preferences(varargin)
% PREFERENCES MATLAB code for preferences.fig
%      PREFERENCES, by itself, creates a new PREFERENCES or raises the existing
%      singleton*.
%
%      H = PREFERENCES returns the handle to a new PREFERENCES or the handle to
%      the existing singleton*.
%
%      PREFERENCES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREFERENCES.M with the given input arguments.
%
%      PREFERENCES('Property','Value',...) creates a new PREFERENCES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preferences_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preferences_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preferences

% Last Modified by GUIDE v2.5 11-Dec-2013 18:22:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preferences_OpeningFcn, ...
                   'gui_OutputFcn',  @preferences_OutputFcn, ...
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


% --- Executes just before preferences is made visible.
function preferences_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preferences (see VARARGIN)

% Choose default command line output for preferences
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes preferences wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preferences_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ui_timeButtonUTC.
function ui_timeButtonUTC_Callback(hObject, eventdata, handles)
% hObject    handle to ui_timeButtonUTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_timeButtonUTC


% --- Executes on button press in ui_timeButtonLocal.
function ui_timeButtonLocal_Callback(hObject, eventdata, handles)
% hObject    handle to ui_timeButtonLocal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ui_timeButtonLocal
