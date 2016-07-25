function varargout = explorerGUI(varargin)
% EXPLORERGUI MATLAB code for explorerGUI.fig
%      EXPLORERGUI, by itself, creates a new EXPLORERGUI or raises the existing
%      singleton*.
%
%      H = EXPLORERGUI returns the handle to a new EXPLORERGUI or the handle to
%      the existing singleton*.
%
%      EXPLORERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLORERGUI.M with the given input arguments.
%
%      EXPLORERGUI('Property','Value',...) creates a new EXPLORERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before explorerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to explorerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help explorerGUI

% Last Modified by GUIDE v2.5 04-Feb-2016 17:51:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @explorerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @explorerGUI_OutputFcn, ...
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











% -------------------------------------------------------------------------
% My Functions
% -------------------------------------------------------------------------

function openFigs = getFigures

    gRootChildren = get(groot, 'Children');
    openFigs = findobj(gRootChildren, 'type', 'figure');



function populateFigurePopup(hObject, handles)

    openFigures = handles.openFigures;
    
    % Make list to populate popUp
    
    figureList = cell(length(openFigures), 1);
    
    % Handle case where there are no open figures
    if isempty(openFigures)
        % Set to default message, update and return
        handles.uiPopupFigure.String = {'No figures open'};
        return
    end
    
    % Build the cell array and populate
    for i = 1:length(openFigures)
        
        figName = sprintf('Figure %i', openFigures(i).Number);
        
        if ~isempty(openFigures(i).Name)
            figName = sprintf('%s: %s', figName, openFigures(i).Name);
        end
        
        figureList{i,1} = figName;
        
    end
    
    handles.uiPopupFigure.String = figureList;
%     handles.openFigures = openFigures;
            
    guidata(hObject, handles);
    

    
    
function figureAxes = getFigureAxesFromSelection(hObject, handles, selection)
    figureAxes = findobj(handles.openFigures(selection).Children, 'Type', 'Axes');

    
    
    
function figureAxes = populateAxesDropdown(hObject, handles)
  
    figureAxes = getFigureAxesFromSelection(hObject, handles, handles.uiPopupFigure.Value);
    
    if isempty(figureAxes)
        % handle exmpty case and return - clear any existing options and
        % disable the other popups
        handles.uiPopupAxis.Value = 1;
        handles.uiPopupAxis.String = {''};
        handles.uiPopupAxis.Enable = 'off';
        handles.uiPopupDataStream.Enable = 'off';
        return
    end
    
    for i = 1:length(figureAxes)
        if isempty(figureAxes(i).Title.String)
            axisTitle = '';
        else
            axisTitle = figureAxes(i).Title.String{1};
        end
        
        axisDropdownContents{i, 1} = sprintf('Axis %i : %s', i, axisTitle);
        
    end
    
        
    handles.uiPopupAxis.String = axisDropdownContents;
    handles.uiPopupAxis.Enable = 'on';
    
    handles.figureAxes = figureAxes;
    
    guidata(hObject, handles);
    
    
function dataStreams = getDataStreamsFromSelection(hObject, handles, selection)
    dataStreams = handles.figureAxes(selection).Children;

function populateDataStreamDropdown(hObject, handles)

    dataStreams = getDataStreamsFromSelection(hObject, handles, handles.uiPopupAxis.Value);
    
    dataStreams = dataStreams(isprop(dataStreams, 'XData'));
           
    if isempty(dataStreams)
        % handle exmpty case and return - clear any existing options and
        % disable the popups
        handles.uiPopupDataStream.Value = 1;
        handles.uiPopupDataStream.String = {''};
        handles.uiPopupDataStream.Enable = 'off';
        return
    end
    
    
    for i = 1:length(dataStreams)
        if isempty(dataStreams(i).DisplayName)
            dataTitle = '';
        else
            dataTitle = dataStreams(i).DisplayName;
        end
        
        dataDropdownContents{i, 1} = sprintf('Stream %i : %s', i, dataTitle);
        
    end
    
    handles.uiPopupDataStream.String = dataDropdownContents;
    handles.uiPopupDataStream.Enable = 'on';
    
    guidata(hObject, handles);


    
    

% --- Executes just before explorerGUI is made visible.
function explorerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to explorerGUI (see VARARGIN)

% Choose default command line output for explorerGUI
handles.output = hObject;


    % ---------------------------------------------------------------------
    % Run before GUI becomes visible
    % ---------------------------------------------------------------------

    handles.openFigures = getFigures();
    
    populateFigurePopup(hObject, handles);
    
    handles.filterMode = 0;

    % Update handles structure
    guidata(hObject, handles);
    
   
% UIWAIT makes explorerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = explorerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------------------------------------------------------------
% GUI Callback Functions
% -------------------------------------------------------------------------



% --- Executes on selection change in uiPopupFigure.
function uiPopupFigure_Callback(hObject, eventdata, handles)
% hObject    handle to uiPopupFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns uiPopupFigure contents as cell array
%        contents{get(hObject,'Value')} returns selected item from uiPopupFigure
    
    populateAxesDropdown(hObject, handles);
    
    
    
% --- Executes during object creation, after setting all properties.
function uiPopupFigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiPopupFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in uiPopupAxis.
function uiPopupAxis_Callback(hObject, eventdata, handles)
% hObject    handle to uiPopupAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    populateDataStreamDropdown(hObject, handles);


    


% Hints: contents = cellstr(get(hObject,'String')) returns uiPopupAxis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from uiPopupAxis


% --- Executes during object creation, after setting all properties.
function uiPopupAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiPopupAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in uiPopupDataStream.
function uiPopupDataStream_Callback(hObject, eventdata, handles)
% hObject    handle to uiPopupDataStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns uiPopupDataStream contents as cell array
%        contents{get(hObject,'Value')} returns selected item from uiPopupDataStream


% --- Executes during object creation, after setting all properties.
function uiPopupDataStream_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiPopupDataStream (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiEditChange_Callback(hObject, eventdata, handles)
% hObject    handle to uiEditChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiEditChange as text
%        str2double(get(hObject,'String')) returns contents of uiEditChange as a double


% --- Executes during object creation, after setting all properties.
function uiEditChange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiEditChange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uiEditThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to uiEditThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of uiEditThreshold as text
%        str2double(get(hObject,'String')) returns contents of uiEditThreshold as a double


% --- Executes during object creation, after setting all properties.
function uiEditThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiEditThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uiButtonGroupThreshold.
function uiButtonGroupThreshold_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uiButtonGroupThreshold 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    switch hObject.Tag
        case 'uiRadioAll'
            handles.filterMode = 0;
        case 'uiRadioAbove'
            handles.filterMode = 1;
        case 'uiRadioBelow'
            handles.filterMode = -1;
        otherwise
            % not sure what the alternatives are at this point?
    end

    guidata(hObject, handles);


function isValid = checkValidSearchOptions(hObject, handles)

searchSetupErrors = cell(0);

% Find errors in threshold setup
if isempty(str2num(handles.uiEditThreshold.String)) && handles.filterMode
    % no value, but trying to filter by threshold
    if isempty(handles.uiEditThreshold.String)
        searchSetupErrors = [searchSetupErrors; 'No threshold specified'];
    else
        searchSetupErrors = [searchSetupErrors; 'Invalid threshold specified'];
    end
end

% Find errors in rate of change setup
if isempty(str2num(handles.uiEditChange.String))
    if isempty(handles.uiEditChange.String)
        searchSetupErrors = [searchSetupErrors; 'No rate of change specified'];
    else
        searchSetupErrors = [searchSetupErrors; 'Invalid rate of change specified'];
    end
end



if isempty(searchSetupErrors)
    % no errors - good to go!
    isValid = true;
    return
else
    warndlg(searchSetupErrors);
    isValid = false;
    return
end

% --- Executes on button press in uiButtonSearch.
function uiButtonSearch_Callback(hObject, eventdata, handles)

    if ~checkValidSearchOptions(hObject, handles); return; end

    search = struct('useThreshold', false,      ...
                    'thresholdValue', [],       ...
                    'useRateOfChange', false,   ...
                    'rateOfChange', []);



    
