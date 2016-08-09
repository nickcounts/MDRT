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

% Last Modified by GUIDE v2.5 03-Aug-2016 12:55:28

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
handles.searchResult = [];


%This displays the MARS logo in the corner, kind of ugly. Feel free to
%change or just delete (tried and failed 2 B fancy)
axes(handles.axes1);
imshow('C:\Users\Paige\Documents\MATLAB\MDRT\reviewPlot\images\MARS-logo.png')

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



% Calls GUI to plot multiple FD's on multiple subplots
% NOT wokring currently.

setappdata(hObject.Parent,'masterFDList',handles.newMasterFDList);

%Passing newMasterFDList (contents of popup menu) as a varargin to
%makeGraphGUI to create subplots
makeGraphGUI(handles.newMasterFDList);

guidata(hObject,handles);



% --- Executes on button press in QuickPlot_pushbutton2.
function QuickPlot_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to QuickPlot_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



index = get(handles.FDList_popupmenu,'Value');

string = handles.FDList_popupmenu.String{index};


% --> This might be unneccesary, but at least now can match up index between
% --> lists, takes value & string from popdown list and gets index of
% --> corresponding match from master list
for i = 1:length(handles.masterFDList.names);
    
    if strcmp(string,handles.masterFDList.names(i));
        newIndex = i;
    end
end

% Now can call the data from "newList" or with "newIndex" from old master
% list --- these both do the same thing. 

fdFileNameWithPath = char(handles.newMasterFDList.paths{index});
fdFileNameWithPath2 = char(handles.masterFDList.paths{newIndex});


% Load a timeline file from the path to the correct data set

        if exist([fullfile(handles.newMasterFDList.pathsToDataSet{index},filesep,'timeline.mat')],'file')

            load([fullfile(handles.newMasterFDList.pathsToDataSet{index},filesep,'timeline.mat')],'-mat')

            figureNumber = reviewQuickPlot( fdFileNameWithPath, timeline, handles);

        else

            figureNumber = reviewQuickPlot( fdFileNameWithPath, handles );

        end
        
% Yay you made a plot time to celebrate ---> HALLELUJAH
load handel
sound(y,Fs)

guidata(hObject, handles);



% --- Executes on button press in RP1_radiobutton.
function RP1_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to RP1_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RP1_radiobutton
RP1 = 'RP1';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,RP1);

handles.newMasterFDList = commodityFDList;

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', handles.newMasterFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,RP1);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', handles.newMasterFDList.names);
end


guidata(hObject, handles);



% --- Executes on button press in LO2_radiobutton.
function LO2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to LO2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LO2_radiobutton
LO2 = 'LO2';

fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,LO2);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,LO2);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;

guidata(hObject, handles);


% --- Executes on button press in LN2_radiobutton.
function LN2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to LN2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LN2_radiobutton
LN2 = 'LN2';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,LN2);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,LN2);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;


guidata(hObject, handles);


% --- Executes on button press in GN2_radiobutton.
function GN2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to GN2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GN2_radiobutton
GN2 = 'GN2';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,GN2);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,GN2);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;

guidata(hObject, handles);


% --- Executes on button press in GHE_radiobutton.
function GHE_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to GHE_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GHE_radiobutton
GHE = 'GHE';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,GHE);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,GHE);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;

guidata(hObject, handles);


% --- Executes on button press in AIR_radiobutton.
function AIR_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to AIR_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AIR_radiobutton
ECS = 'ECS';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,ECS);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,ECS);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;

guidata(hObject, handles);



% --- Executes on button press in WDS_radiobutton.
function WDS_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to WDS_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of WDS_radiobutton
WDS = 'WDS';
fdFile = handles.newMasterFDList;

commodityFDList = searchfdListByCommodity(fdFile,WDS);

% Run the search against what is cuurently in the popdown menu list
% (newMasterFDList)
% If no results, means that you have already filtered too far, so back out
% and run search again on the masterFDList to get results for the selected filter
% Then update popupmenu with new results

if ~isempty(commodityFDList.names)
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
else
    fdFile = handles.masterFDList;
    commodityFDList = searchfdListByCommodity(fdFile,WDS);
    handles.newMasterFDList = commodityFDList;
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', commodityFDList.names);
end

handles.newMasterFDList = commodityFDList;

guidata(hObject, handles);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%                                                                   %%%%
% %%%%                      SEARCH BY DATE FUNCTION                      %%%%
% %%%%                                                                   %%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in Search_pushbutton.
function Search_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Search_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

time = [handles.startDateValue, handles.endDateValue];

% --> This checks to make sure dates are in correct order, but not
% neccessary because search function automatically switches dates.
    % if handles.startDateValue > handles.endDateValue 
    %     
    %     dateWarningDialog % < displays message saying times are reversed
    % 
    %     % -> Automatically switch times - warning not needed
    % else


% Search function -> input a time, return a searchResult structure with
% matching data

[searchResult] = searchTimeStamp(time);


% This function takes the searchResult structure and creates 3 arrays with
% full string titles for each FD, the full filepath to the data file, and
% the path to the corresponding data set
[FDListStringNames,FileNameWithPath,FDPathToDataFolder] = makeNameAndPathFromSearchResult(searchResult,handles);

% Store searchResult in a handle in case need to access it later
handles.searchResult = searchResult;

% 
% handles.FDList = FDListStringNames; % Are these still needed??
% handles.FDPathsWithName = FileNameWithPath; % ??
% handles.FDPathsToFolder = FDPathToDataFolder; % ??
handles.metaDataFlags = newMetaDataFlags;

% -- masterFDList is one structure that holds Names, File Paths with Names, and path to
% --   data folders together instead of in 3 seperate arrays

handles.masterFDList = newMasterFDListStruct;

handles.masterFDList.names = FDListStringNames;
handles.masterFDList.paths = FileNameWithPath;
handles.masterFDList.pathsToDataSet = FDPathToDataFolder;

% Temporary  master list to display in popup menu = newMasterFDList? 
% i.e. masterFDList is always entire list returned from search function but new list is
% updated and displayed in popup based on selected filter

handles.newMasterFDList = handles.masterFDList;

% handles.newMasterFDList.names = handles.masterFDList.names;
% handles.newMasterFDList.paths = handles.masterFDList.paths;
% handles.newMasterFDList.pathsToDataSet = handles.masterFDList.pathsToDataSet;

% Always display new/temp list in popupmenu

handles.FDList_popupmenu.String = handles.newMasterFDList.names;

guidata(hObject, handles);



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



% --- Executes on button press in isOperation_checkbox.
function isOperation_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to isOperation_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of isOperation_checkbox

state = get(hObject,'Value');

%Set the state of the metaDataFlag to be called later in metaDataFlagSearch
handles.metaDataFlags.isOperation = state;


guidata(hObject, handles);



% --- Executes on button press in hasMARSUID_checkbox.
function hasMARSUID_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to hasMARSUID_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hasMARSUID_checkbox
state = get(hObject,'Value');

%Set the state of the metaDataFlag to be called later in metaDataFlagSearch
handles.metaDataFlags.hasMARSuid = state;

guidata(hObject, handles);


% --- Executes on button press in isProcedure_checkbox.
function isProcedure_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to isProcedure_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isProcedure_checkbox
state = get(hObject,'Value');

%Set the state of the metaDataFlag to be called later in metaDataFlagSearch
handles.metaDataFlags.isMARSprocedure = state;


guidata(hObject, handles);


% --- Executes on button press in isVehicleOp_checkbox.
function isVehicleOp_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to isVehicleOp_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isVehicleOp_checkbox
state = get(hObject,'Value');

%Set the state of the metaDataFlag to be called later in metaDataFlagSearch
handles.metaDataFlags.isVehicleOp = state;

guidata(hObject, handles);



% --- Executes on button press in OpFilter_button.
function OpFilter_button_Callback(hObject, eventdata, handles)
% hObject    handle to OpFilter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Passes teh searchResults to searchthrough, and the metaDataFlags to check
% against -- only returns if ALL flags are a match
[matchingOperationSearchResult] = newNewSearchMetaDataFlag(handles.searchResult, handles.metaDataFlags);


% idk why im checking if its a structure it should alwasy be a structure??
if isstruct(matchingOperationSearchResult) 
    [opFDListStringNames,opFileNameWithPath,opFDPathToDataFolder] = makeNameAndPathFromSearchResult(matchingOperationSearchResult,handles);

    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', opFDListStringNames);
else
    set(handles.FDList_popupmenu,'Value',1); 
    set(handles.FDList_popupmenu, 'String', matchingOperationSearchResult);
end



guidata(hObject, handles);



    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%                  Callbacks for Toolbar Buttons                    %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                                   %%%%
%%%%            Save Graph Configuration Button Callback               %%%%
%%%%                                                                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function uiSaveButton_ClickedCallback(hObject, eventdata, handles)

    

    % Retrieve graph structure to be saved from GUI elements
    graph = returnGraphStructureFromGUI(handles);
    
    % Generate default filename from graph structure
    defaultName = graph.name;

        % clean up unhappy reserved filename characters
        defaultName = regexprep(defaultName,'^[!@$^&*~?.|/[]<>\`";#()]','');
        defaultName = regexprep(defaultName, '[:]','-');
        
        % Guarantee defaultName is a string
        if iscell(defaultName)
            defaultName = defaultName{1};
        end
        
        
    % Attempt to autopopulate the path
    if isfield(handles.configuration, 'graphConfigFolderPath')
        % Loads path from configuration
        lookInPath = handles.configuration.graphConfigFolderPath;
        disp(lookInPath)
    else
        % Set default path... to graph
        lookInPath = handles.configuration.dataFolderPath;
    end    
    
    % Open UI for save name and path
    [file,path] = uiputfile('*.gcf','Save Graph Configuration as:',fullfile(lookInPath, defaultName));

    % Check the user didn't "cancel"
    if file ~= 0
        save(fullfile(path, file), 'graph', '-mat');
    else
        % Cancelled... not sure what the best behavior is... return to GUI
    end
    



function operationNameSearch_editbox_Callback(hObject, eventdata, handles)
% hObject    handle to operationNameSearch_editbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of operationNameSearch_editbox as text
%        str2double(get(hObject,'String')) returns contents of operationNameSearch_editbox as a double


handles.opNameInput = get(hObject,'String');


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function operationNameSearch_editbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operationNameSearch_editbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in searchName_button.
% function searchName_button_Callback(hObject, eventdata, handles)
% % hObject    handle to searchName_button (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% 
% [searchResult] = searchOperationName(handles.opNameInput);
% 
% if ~isempty(searchResult)
%     
%     [FDListStringNames,FileNameWithPath,FDPathToDataFolder] = makeNameAndPathFromSearchResult(searchResult,handles);
% 
%     handles.FDList_popupmenu.String = FDListStringNames;
% 
%     handles.searchResult = searchResult;
% 
% 
%     handles.FDList = FDListStringNames;
%     handles.FDPathsWithName = FileNameWithPath;
%     handles.FDPathsToFolder = FDPathToDataFolder;
%     handles.metaDataFlags = newMetaDataFlags;
% 
% else
%     handles.FDList_popupmenu.String = 'No Data Found Matching Search Criteria';
% end
% 
% guidata(hObject, handles);

% function operationNameSearch_editbox_ButtonDownFcn(hObject, eventdata, handles)
% % hObject    handle to axes1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% set(handles.operationNameSearch.String,' ');
% 
% guidata(hObject,handles);




% --- Executes on key press with focus on operationNameSearch_editbox and none of its controls.
function operationNameSearch_editbox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to operationNameSearch_editbox (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


if strcmp(eventdata.Key,'return')
    
    handles.opNameInput = get(hObject,'String');

    [searchResult] = searchOperationName(handles.opNameInput);

    if ~isempty(searchResult)

        [FDListStringNames,FileNameWithPath,FDPathToDataFolder] = makeNameAndPathFromSearchResult(searchResult,handles);

        handles.FDList_popupmenu.String = FDListStringNames;

        handles.searchResult = searchResult;
        
        handles.masterFDList.names =FDListStringNames;
        handles.masterFDList.paths = FileNameWithPath;
        handles.masterFDList.pathsToDataSet = FDPathToDataFolder;

        handles.newMasterFDList = handles.masterFDList;
%         handles.newMasterFDList.names =FDListStringNames;
%         handles.newMasterFDList.paths = FileNameWithPath;
%         handles.newMasterFDList.pathsToDataSet = FDPathToDataFolder;

%         handles.FDList = FDListStringNames;
%         handles.FDPathsWithName = FileNameWithPath;
%         handles.FDPathsToFolder = FDPathToDataFolder;
        handles.metaDataFlags = newMetaDataFlags;

    else
        handles.FDList_popupmenu.String = 'No Data Found Matching Search Criteria';
    end
else
    
end

guidata(hObject, handles);

function operationNameSearch_editbox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
