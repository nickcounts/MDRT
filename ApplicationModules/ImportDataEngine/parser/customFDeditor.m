function varargout = customFDeditor(varargin)
% CUSTOMFDEDITOR
%
%   Launches a user interface to define special-case naming conventions for
%   data parsed by MDRT's ImportDataEngine.
%
%   Custom naming rules are saved in 'processDelimFiles.cfg' which is a
%   MATLAB .mat variable file containing a cell array of the form:
% 
% Original FD,                  System, ID,   Type, FullString,      FileName
% AIR FM-0001 Flow Meter  Mon,  ECS,    0001, FM,   Fwd-Bay Airflow, ECS-FM-0001
% AIR FM-0002 Flow Meter  Mon,  ECS,    0002, FM,   Mid-Bay Airflow, ECS-FM-0002
% AIR FM-0003 Flow Meter  Mon,  ECS,    0003, FM,   Aft-Bay Airflow, ECS-FM-0003
% 
%   Filenames may be deprecated in future releases, as the ImportDataEngine
%   filename generator is overhauled.
%
%   These override values are triggered by a matchhing Original FD, which
%   the ImportDataEngine checks before commiting a processed FD to disk.
%

%      CUSTOMFDEDITOR, by itself, creates a new CUSTOMFDEDITOR or raises the existing
%      singleton*.
%
%      H = CUSTOMFDEDITOR returns the handle to a new CUSTOMFDEDITOR or the handle to
%      the existing singleton*.
%
%      CUSTOMFDEDITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUSTOMFDEDITOR.M with the given input arguments.
%
%      CUSTOMFDEDITOR('Property','Value',...) creates a new CUSTOMFDEDITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before customFDeditor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to customFDeditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help customFDeditor

% Last Modified by GUIDE v2.5 16-May-2016 17:50:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @customFDeditor_OpeningFcn, ...
                   'gui_OutputFcn',  @customFDeditor_OutputFcn, ...
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


% --- Executes just before customFDeditor is made visible.
function customFDeditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to customFDeditor (see VARARGIN)

% This is where I put my initialization code
% -------------------------------------------------------------------------
config = getConfig;
    
    % Add configuration struct to the handles struct
    handles.configuration = config;

load('processDelimFiles.cfg','-mat');


handles.uitable1.Data = customFDnames(2:end,:);
handles.uitable1.ColumnName = customFDnames(1,:);
handles.uitable1.RearrangeableColumns = 'on';

% Choose default command line output for customFDeditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes customFDeditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = customFDeditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% My UI Controls


function saveRulesButton_Callback(hObject, eventdata, handles)

% Assemble the custom FD name/rules cell array from table headers and data

    colNames = handles.uitable1.ColumnName';
    FDnamesFromTable = handles.uitable1.Data;

    customFDnames = [colNames; FDnamesFromTable ];



    defaultName = {'processDelimFiles.cfg'};

  % Attempt to autopopulate the path
    if isfield(handles.configuration, 'programRootPath')
        % Loads path from configuration
        lookInPath = fullfile(handles.configuration.programRootPath, 'parser');
        disp(lookInPath)
    else
        % Set default path... to current working directory?
        lookInPath = '.';
    end    

    % Open UI for save name and path
    [file,path] = uiputfile('*.cfg','Save Custom FD Name Rules:',fullfile(lookInPath, defaultName{1}));

    % Check the user didn't "cancel"
    if file ~= 0
        save(fullfile(path, file), 'customFDnames', '-mat');
    else
        % Cancelled... not sure what the best behavior is... return to GUI
    end

% --- Executes on button press in openDelimButton.
function openDelimButton_Callback(hObject, eventdata, handles)

    % Define paths from config structure
        % delimPath = '~/Documents/MATLAB/Data Review/ORB-2/delim';
        delimPath = handles.configuration.delimFolderPath;
        processPath = fullfile(delimPath, '..');

        [fileName processPath] = uigetfile( {...
                                '*.delim', 'CCT Delim File'; ...
                                '*.*',     'All Files (*.*)'}, ...
                                'Pick a file', fullfile(processPath, '*.delim'));

    if isnumeric(fileName)
        % User cancelled .delim pre-parse
        disp('User cancelled .delim pre-parse');
        return
    end
    
    
    [fdName, fdDesciption] = getUniqueFDsFromDelim( handles.configuration, fileName, processPath );


% --- Executes on button press in insertRowButton.
function insertRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to insertRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

row = handles.tableSelection(1);
col = handles.tableSelection(2);

bottomHalf = handles.uitable1.Data(row:end, :);
topHalf    = handles.uitable1.Data(1:row, :);

    newData = [topHalf; bottomHalf];
    newData(row,:) = cell(1, length(handles.uitable1.Data(1,:)))

handles.uitable1.Data = newData;
guidata(hObject, handles);


% --- Executes on button press in deleteRowButton.
function deleteRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

row = handles.tableSelection(1);
col = handles.tableSelection(2);

handles.uitable1.Data(row,:) =[];

% --- Executes on button press in upRowButton.
function upRowButton_Callback(hObject, eventdata, handles)
% hObject    handle to upRowButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in downButton.
function downButton_Callback(hObject, eventdata, handles)
% hObject    handle to downButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)

    handles.tableSelection = eventdata.Indices;
    guidata(hObject, handles);


% --- Executes on button press in enableEdit.
function enableEdit_Callback(hObject, eventdata, handles)

    if eventdata.Source.Value
        % Edit button is true
        % Set table to editable
        handles.uitable1.ColumnEditable = true(1,size(handles.uitable1.Data,2));
    else
        handles.uitable1.ColumnEditable = false(1,size(handles.uitable1.Data,2));
    end
