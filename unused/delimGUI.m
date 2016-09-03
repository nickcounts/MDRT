function varargout = delimGUI(varargin)
% DELIMGUI MATLAB code for delimGUI.fig
%      DELIMGUI, by itself, creates a new DELIMGUI or raises the existing
%      singleton*.
%
%      H = DELIMGUI returns the handle to a new DELIMGUI or the handle to
%      the existing singleton*.
%
%      DELIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELIMGUI.M with the given input arguments.
%
%      DELIMGUI('Property','Value',...) creates a new DELIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before delimGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to delimGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help delimGUI

% Last Modified by GUIDE v2.5 29-Aug-2012 14:22:15



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @delimGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @delimGUI_OutputFcn, ...
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


% --- Executes just before delimGUI is made visible.
function delimGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to delimGUI (see VARARGIN)

% Choose default command line output for delimGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes delimGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = delimGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ui_listbox_dataSelection.
function ui_listbox_dataSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ui_listbox_dataSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    disp('In listbox callback') 
    disp(get(hObject, 'value')) 
    whos
    handles
    handles.ui_listbox_dataSelection
    

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_dataSelection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_dataSelection


% --- Executes during object creation, after setting all properties.
function ui_listbox_dataSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_listbox_dataSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Temporary line
x = evalin('base','headersTok');

    [filename, pathname] = uigetfile;
    dataHeaders = loadFile(filename, pathname);


    name = dataHeaders{2}{1};
    qual = dataHeaders{4}{1}; % not imlemented

    name = {name{2:end}}';

    for i = 1:length(name)
        dataList{i*2-1} = [name{i} ' min'];
        dataList{i*2}   = [name{i} ' Max'];
    end

    dataList = dataList';

% set(hObject,'String',name{2}{1}(2:end));  
    set(hObject,'String',dataList);
    set(hObject,'Max', length(dataList) );

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in ui_button_clearSelection.
function ui_button_clearSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_clearSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Inside ui_button_clearSelection_Callback')
set(handles.ui_listbox_dataSelection, 'value', []);


% --- Executes on button press in ui_button_addChannel.
function ui_button_addChannel_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_addChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ui_button_removeChannel.
function ui_button_removeChannel_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_removeChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ui_button_clearChannels.
function ui_button_clearChannels_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_clearChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in ui_listbox_selectedData.
function ui_listbox_selectedData_Callback(hObject, eventdata, handles)
% hObject    handle to ui_listbox_selectedData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ui_listbox_selectedData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ui_listbox_selectedData


% --- Executes during object creation, after setting all properties.
function ui_listbox_selectedData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_listbox_selectedData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ui_button_openFile.
function ui_button_openFile_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
{  '*.delim',  'FCS Archive File (*.delim)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');

fid = fopen([pathname filename]);

% import data from file
Q = textscan(fid, '%s %s %s %s %s %s %s %s %s', 'Delimiter', ',');

% store data for use in other functions
handles.readFromFile = Q;
guidata(hObject, handles);

fclose(fid);

% Memory management
clear fid pathname filename

%% Initial Data Parsing
%
%   Assign important data to their own cell arrays for parsing
%

timeCell        = Q{1};
parameterCell   = Q(4);
labelCell       = Q{6};
valueCell       = Q{8};

% Optional Cleanup
clear Q;

%% Timestamp Parsing
%
%   textscan(timeCell, '%d / %d / %d / %d : %d : %f')
%   Quick parse time data into a matrix

    a = textscan(sprintf('%s\n',timeCell{:}),'%f/%f/%f:%f:%f');

%timeMat is of the form [year day hour minute second]
    timeMat = [a{:}];

% generate a Matlab-style date (without time) by addition
% extract yyyy mm dd
% assemble Matlab date using datenum
    rawDate = datenum(timeMat(:,1),1,1) + timeMat(:,2);

        yearM   = year(rawDate);
        monthM  = month(rawDate); 
        dayM    = day(rawDate);

% TIME VARIABLE: time is a matlab-style time value (double)
    time = datenum(yearM,monthM,dayM,timeMat(:,3),timeMat(:,4),timeMat(:,5));

        % cleanup
        clear year month day rawdate timeMat a timeCell

%data cleanup
clear a

%   At this point, the active variables are:
%       time, labelCell, valueCell

%% Automatic Plotting:


% Data reduction from Excel Delim file

channels = unique(labelCell);

%Grab logical index mask for each channel
for i = 1:length(channels)
    chanIndexes(:,i) = strcmp(labelCell,channels(i));
end


% Create styles for each data set.
% Loop through so there are always enough styles for each plot
styles = { };
for i = 1:9:length(channels)
    styles = [styles {'b-' 'g-' 'r-' 'b.-' 'g.-' 'r.-' 'b:' 'g:' 'r:'}];
end

%Plot all available channels.
% TEMP FIX: Ignore any channels that are ACK / ACK pending - command
% related data. All non-numerical channels will  be skipped
for i = 1:length(channels)
    if channels
    plot( time(chanIndexes(:,i)), valueCell(chanIndexes(:,i)),styles{i},'displayname',channels{i});
    hold on;
    end
end

legend show;

dynamicDateTicks;




































% --- Executes on button press in ui_button_plot.
function ui_button_plot_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
