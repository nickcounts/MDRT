function varargout = graphConfigTest(varargin)
% GRAPHCONFIGTEST MATLAB code for graphConfigTest.fig
%      GRAPHCONFIGTEST, by itself, creates a new GRAPHCONFIGTEST or raises the existing
%      singleton*.
%
%      H = GRAPHCONFIGTEST returns the handle to a new GRAPHCONFIGTEST or the handle to
%      the existing singleton*.
%
%      GRAPHCONFIGTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHCONFIGTEST.M with the given input arguments.
%
%      GRAPHCONFIGTEST('Property','Value',...) creates a new GRAPHCONFIGTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graphConfigTest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graphConfigTest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graphConfigTest

% Last Modified by GUIDE v2.5 19-Feb-2014 10:04:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graphConfigTest_OpeningFcn, ...
                   'gui_OutputFcn',  @graphConfigTest_OutputFcn, ...
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


% --- Executes just before graphConfigTest is made visible.
function graphConfigTest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graphConfigTest (see VARARGIN)

% Choose default command line output for graphConfigTest
handles.output = hObject;

% #########################################################################
%   My Variables and Setup
% #########################################################################

graphConfigMenu_empty = cell(1);
    graphConfigMenu_empty{1} = 'Not available';

graphConfigMenu_command = cell(1);
    graphConfigMenu_command = {'Graph'; 'Plot'; 'Data'; 'Start'; 'Stop'};

graphConfigMent_time = { 'T-'; 'T+'; 'UTC'};


path = fullfile(pwd, '..', 'ORB-2','data', filesep);
fileType = 'mat';

keyboard


graphConfigMenu_data = listAvailableFDs( path, fileType );

    handles.graphConfigMenu.empty   = graphConfigMenu_empty;
    handles.graphConfigMenu.command = graphConfigMenu_command;
    handles.graphConfigMenu.time    = graphConfigMent_time;
    handles.graphConfigMenu.data    = graphConfigMenu_data;

    data = get(handles.uitable1, 'Data');
    
    data{1,1} = graphConfigMenu_command{1};
    data{2,1} = graphConfigMenu_command{2};
    data{3,1} = graphConfigMenu_command{3};
    data{4,1} = graphConfigMenu_command{4};
    data{5,1} = graphConfigMenu_command{5};
    data{end,end} = false;
    data{1,2} = 'Enter New Graph Title';
    data{2,2} = 'Enter Plot Title';
    
    set(handles.uitable1, 'Data', data);
    
    editable = get(handles.uitable1, 'ColumnEditable');
    editable = true(size(editable));
    set(handles.uitable1,'ColumnEditable',editable);
    
    set(handles.uitable1, 'CellSelectionCallback', {@cellSelectCallback,handles});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graphConfigTest wait for user response (see UIRESUME)
% uiwait(handles.figure1);





% --- Outputs from this function are returned to the command line.
function varargout = graphConfigTest_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% A Custom cellselectcallback function to ensure the proper selections are
% available based on the state of the current row.

function cellSelectCallback(src, event, handles)

data = get(src,'Data');
origData = data(event.Indices(1),event.Indices(2));
cellformat = get(src, 'ColumnFormat');



switch event.Indices(2)
    case 1
        % do nothing, I think...
    case 2
        % Need to check the value of the previous cell
        switch data{event.Indices(1),1}
            case 'Graph'
                % Prevent the cell from turning
                cellformat{2} = 'char';
                set(src, 'ColumnFormat', cellformat)
                data(event.Indices(1),event.Indices(2)) = origData;
                set(src, 'Data', data)
                
                

            case 'Plot'
                
            case 'Data'

                cellformat{2} = handles.graphConfigMenu.data(:,1)';
                set(src, 'ColumnFormat', cellformat);
                
                
                
            case 'Start'
                
            case 'Stop'
            otherwise
        end
        
    case 3
        
    otherwise
        
        
end
        
