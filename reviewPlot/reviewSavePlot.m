function varargout = reviewSavePlot(varargin)
% REVIEWSAVEPLOT MATLAB code for reviewSavePlot.fig
%      REVIEWSAVEPLOT, by itself, creates a new REVIEWSAVEPLOT or raises the existing
%      singleton*.
%
%      H = REVIEWSAVEPLOT returns the handle to a new REVIEWSAVEPLOT or the handle to
%      the existing singleton*.
%
%      REVIEWSAVEPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEWSAVEPLOT.M with the given input arguments.
%
%      REVIEWSAVEPLOT('Property','Value',...) creates a new REVIEWSAVEPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reviewSavePlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reviewSavePlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reviewSavePlot

% Last Modified by GUIDE v2.5 04-Feb-2014 16:29:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reviewSavePlot_OpeningFcn, ...
                   'gui_OutputFcn',  @reviewSavePlot_OutputFcn, ...
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


% --- Executes just before reviewSavePlot is made visible.
function reviewSavePlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reviewSavePlot (see VARARGIN)

% Choose default command line output for reviewSavePlot
handles.output = hObject;

% MY INITIALIZATION CODE GOES HERE

[QPNum QPList] = listAvailableQPs();

for i = 1:length(QPNum)
    popupContents{i,1} = sprintf('Figure %i : %s', QPNum(i), QPList{i});
end

set(handles.uiPopup_QPList, 'String', popupContents)

handles.QPFigTitles =  QPList;
handles.QPFigHandles = QPNum;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reviewSavePlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = reviewSavePlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uiButton_savePDF.
function uiButton_savePDF_Callback(hObject, eventdata, handles)
% hObject    handle to uiButton_savePDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


index = get(handles.uiPopup_QPList,'Value');

figHandle = handles.QPFigHandles(index);
defaultName = handles.QPFigTitles(index);

% clean up unhappy reserved filename characters
defaultName = regexprep(defaultName{1},'^[!@$^&*~?.|/[]<>\`";#()]','');
defaultName = regexprep(defaultName, '[:]','-');

% Open UI for save name and path
[file,path] = uiputfile('*.pdf','Save Plot to PDF as:',defaultName);

% Check the user didn't "cancel"
if file ~= 0
    saveas(figHandle, [path file],'pdf')
else
    % Cancelled... not sure what the best behavior is... return to GUI
end





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in uiPopup_QPList.
function uiPopup_QPList_Callback(hObject, eventdata, handles)
% hObject    handle to uiPopup_QPList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns uiPopup_QPList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from uiPopup_QPList

guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function uiPopup_QPList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiPopup_QPList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end










% My helper functions go here, I hope


function [ availQPs QPTitle ] = listAvailableQPs( )
%listAvailableFDs 


availQPs = findall(0,'Tag','quickPlot');clc

QPTitle = cell(0);

for QP = 1:length(availQPs)
    QPTitle{QP,1} = get(get(get(QP,'Children'),'Title'),'String');
%     QPTitle{QP,2} = availQPs(QP);
end


    
  
    
    
    
