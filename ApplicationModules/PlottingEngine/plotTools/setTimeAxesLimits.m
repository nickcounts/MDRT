function graph = setTimeAxesLimits( graph, handles, varargin )
% graph = setTimeAxesLimits( graph, handles, varargin) 
%   Sets x-axis limits and saves set axis configuration to graph structure.
%   GRAPH - all x axis information saved to the graph time substructure
%   HANDLES - gui handles passed from parent function and updated with new
%             handles 
%   To impose x-axis limits without saving to the graph structure, use the
%   in-graph toolbar function updateXAxis to set start/stop.
%
% July 2017, Patel - Mid-Atlantic Regional Spaceport

disp('<a href="timeAxesToolHelpScript.html">Time Axes Tool Help Page</a>')

%% Load Timeline

config = getConfig;

% Load Timeline File
if exist(fullfile(config.dataFolderPath, 'timeline.mat'),'file')
    
    t = load(fullfile(config.dataFolderPath, 'timeline.mat'));
    % milestoneString = string(cellstr({t.timeline.milestone.String}'));
    milestoneString = cellstr({t.timeline.milestone.String}');
    milestoneString = [milestoneString; t.timeline.t0.name];
    milestoneTime = {t.timeline.milestone.Time}';
    milestoneTime = [milestoneTime; t.timeline.t0.time];    
    disp('Timeline File Successfully Loaded.');
    
else
    
    warndlg('Event data file "timeline.mat" was not found. Milestone Set Axes option unavailable.');
    milestoneString = 'Empty';
    
end

%% GUI Setup

    tl.fig = handles.figure1.Children(1).Children(2); % creates handle for the GUI tab
    tl.fig.Units = 'characters'; 
    tl.setAxes = struct('start',graph.time.startTime,'stop',graph.time.stopTime);

%% GUI Layout

    function guiStartOpeningFcn ( varargin )
        handles.startText = uicontrol(tl.fig, ...
                        'Style',    'Text', ...
                        'String',   'Start Time', ...
                        'Units',    'characters',...
                        'Position', [11, 26.1, 18, 1.5], ...
                        'FontSize', 12);

        handles.startTime = uibuttongroup(tl.fig, ...
                        'Units',    'characters',... 
                        'Tag',      'Start', ...
                        'Position', [8.5, 6.6, 45, 19])';            

        handles.noneStart = uicontrol('Parent', handles.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @noneCallback, ...
                        'String',   'None',...
                        'Tag',      'none', ...
                        'Units',    'characters',...
                        'Position', [2.5, 16.5, 15, 1.5]); 

        handles.manualStart = uicontrol('Parent', handles.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @manualCallback, ...
                        'String',   'Manual',...
                        'Tag',      'manual', ...
                        'Units',    'characters',...
                        'Position', [2.5, 13.5, 15, 1.5]); 

        handles.manualStartInput = uicontrol('Parent', handles.startTime, ...
                        'Style',    'edit', ...
                        'Callback', @manualInputCallback, ...
                        'String',   'MM/DD/YY HH:MM:SS', ...
                        'Tag',      'manual', ...
                        'Units',    'characters', ...
                        'Position', [6, 11.5, 33, 1.5]);

        handles.milestoneStart = uicontrol('Parent', handles.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @milestoneCallback, ...
                        'String',   'Milestone', ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 8.5, 15, 1.5]);

        handles.milestoneStartInput = uicontrol('Parent', handles.startTime, ...
                        'Style',    'popupmenu', ...
                        'Callback', @milestoneInputCallback, ...
                        'String',   milestoneString, ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [6, 6.5, 33, 1.5]);

        handles.offsetStart = uicontrol('Parent', handles.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @offsetCallback, ...
                        'String',   'Offset', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 3.5, 15, 1.5]);

        handles.offsetStartInput = uicontrol('Parent', handles.startTime, ...
                        'Style',	'edit', ...
                        'Callback', @offsetInputCallback, ...
                        'String',   'HH:MM:SS', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [6, 1.5, 33, 1.5]);                                
    end
     
    function guiStopOpeningFcn ( varargin )
        handles.stopText = uicontrol(tl.fig, ...
                        'Style',    'Text', ...
                        'String',   'Stop Time', ...
                        'Units',    'characters',...
                        'Position', [61, 26.1, 18, 1.5], ...
                        'FontSize', 12);

        handles.stopTime = uibuttongroup(tl.fig, ...
                        'Units',    'characters',...    
                        'Tag',      'Stop', ...
                        'Position', [58.5, 6.6, 45, 19])';            

        handles.noneStop = uicontrol('Parent', handles.stopTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @noneCallback, ...
                        'String',   'None',...
                        'Tag',      'none', ...
                        'Units',    'characters',...
                        'Position', [2.5, 16.5, 15, 1.5]); 

        handles.manualStop = uicontrol('Parent', handles.stopTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @manualCallback, ...
                        'String',   'Manual',...
                        'Tag',      'manual', ...
                        'Units',    'characters',...
                        'Position', [2.5, 13.5, 15, 1.5]); 

        handles.manualStopInput = uicontrol('Parent', handles.stopTime, ...
                        'Style',    'edit', ...
                        'Callback', @manualInputCallback, ...
                        'String',   'MM/DD/YY HH:MM:SS', ...
                        'Tag',      'manual', ...
                        'Units',    'characters', ...
                        'Position', [6, 11.5, 33, 1.5]);

        handles.milestoneStop = uicontrol('Parent', handles.stopTime, ...
                        'Style',        'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @milestoneCallback, ...
                        'String',   'Milestone', ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 8.5, 15, 1.5]);

        handles.milestoneStopInput = uicontrol('Parent', handles.stopTime, ...
                        'Style',    'popupmenu', ...
                        'Callback', @milestoneInputCallback, ...
                        'String',   milestoneString, ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [6, 6.5, 33, 1.5]);

        handles.offsetStop = uicontrol('Parent', handles.stopTime, ...
                        'Style',        'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @offsetCallback, ...
                        'String',   'Offset', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 3.5, 15, 1.5]);

        handles.offsetStopInput = uicontrol('Parent', handles.stopTime, ...
                        'Style',	'edit', ...
                        'Callback', @offsetInputCallback, ...
                        'String',   'HH:MM:SS', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [6, 1.5, 33, 1.5]); 
                    
        handles.apply = uicontrol(tl.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @applyCallback, ...
                        'String',   'Apply', ...
                        'Tag',      'apply', ...
                        'Units',    'characters', ...
                        'Position', [51, 4.35, 10, 1.5]);
    end

guiStartOpeningFcn() 
guiStopOpeningFcn()

% To make the code look less cluttered, I grouped GUI controls and nested
% them inside two separate functions. 

%% Populate GUI

% Instead of calling each handle to set enable on/off, I created an array
% from which the indices can be called for the desired handle. 

disableArray = [handles.noneStop handles.offsetStop handles.offsetStopInput...
            handles.offsetStart handles.offsetStartInput handles.noneStart...
            handles.manualStartInput handles.manualStopInput...
            handles.milestoneStartInput handles.milestoneStopInput];

% Populate GUI with any existing graph structure time information         
    function guiStartPopulate ( varargin )
        switch graph.time.startTag
            case 'none'
                handles.startTime.SelectedObject = handles.noneStart;
                set(disableArray(:,[2,3,5,7,9]),'Enable','off');
                set(disableArray(1), 'Enable', 'on');     
                
            case 'manual'
                handles.startTime.SelectedObject = handles.manualStart;
                set(disableArray(:,[1:2 7]), 'Enable', 'on');
                set(disableArray(:,[3 5 9]), 'Enable', 'off');
                set(handles.manualStartInput,'String',graph.time.startTime.String);
                
            case 'milestone'
                handles.startTime.SelectedObject = handles.milestoneStart;
                set(disableArray(:,[1:2 9]), 'Enable', 'on');
                set(disableArray(:,[3 5 7]), 'Enable', 'off'); 
                i = find(strcmp(handles.milestoneStartInput.String, ...
                            graph.time.startTime.String));
                        % The issue is that there is a low flow command
                        % that occurs at different times. In this case,
                        % manually pull the index from the timeline file,
                        % assuming that the index alignment didn't change
                        % from originally loading the file. 
                if length(i) ~= 1
                    i = find(cell2mat(milestoneTime) == ...
                            graph.time.startTime.Time);
                end                        
                set(handles.milestoneStartInput,'Value',i);
                
            case 'offset'
                handles.startTime.SelectedObject = handles.offsetStart;
                set(disableArray(:,[1:3 7 9]), 'Enable', 'off');
                set(disableArray(:,5), 'Enable', 'on');
                set(handles.offsetStartInput,'String',graph.time.startTime.String);
        end        
    end

   function guiStopPopulate ( varargin )
        switch graph.time.stopTag
            case 'none'
                handles.stopTime.SelectedObject = handles.noneStop;
                set(disableArray(:,[4:5 3 8 10]), 'Enable', 'off');
                set(disableArray(6), 'Enable', 'on');    
                
            case 'manual'
                handles.stopTime.SelectedObject = handles.manualStop;
                set(disableArray(:,[4 6 8]), 'Enable', 'on');
                set(disableArray(:,[3 5 10]), 'Enable', 'off');
                set(handles.manualStopInput,'String',graph.time.stopTime.String);
                
            case 'milestone'
                handles.stopTime.SelectedObject = handles.milestoneStop;
                set(disableArray(:,[4 6 10]), 'Enable', 'on');  
                set(disableArray(:,[3 5 8]), 'Enable', 'off');
                i = find(strcmp(handles.milestoneStopInput.String, ...
                            graph.time.stopTime.String));
                if length(i) ~= 1
                    i = find(cell2mat(milestoneTime) == ...
                            graph.time.stopTime.Time);
                end                        
                set(handles.milestoneStopInput,'Value',i);
                
            case 'offset'
                handles.stopTime.SelectedObject = handles.offsetStop;
                set(disableArray(:,[4:6 8 10]), 'Enable', 'off');
                set(disableArray(:,3), 'Enable', 'on');
                set(handles.offsetStopInput,'String',graph.time.stopTime.String);
        end        
   end

guiStartPopulate()
guiStopPopulate()
            
% Note, many of the uicontrols are set as enabled and disabled depending on
% the radiobutton selection. This is due to the proper pairing of start and
% stop time events. E.g. you cannot have an offset stop time from a "none"
% start time within this GUI. 

%% Callback Functions

% Callback function if "none" is selected for limit type. 
    function noneCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'
                set(disableArray(:,[2:3 5 9 7]), 'Enable', 'off');
                set(disableArray(1), 'Enable', 'on');
                graph(1).time.isStartTimeAuto = 1;
                
            case 'Stop'       
                set(disableArray(:,[4:5 3 8 10]), 'Enable', 'off');
                set(disableArray(6), 'Enable', 'on');
                graph(1).time.isStopTimeAuto = 1;
        end
    end

% Callback function for "manual" radiobutton selection.
    function manualCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'
                set(disableArray(:,[1:2 7]), 'Enable', 'on');
                set(disableArray(:,[3 5 9]), 'Enable', 'off');
                
            case 'Stop' 
                set(disableArray(:,[4 6 8]), 'Enable', 'on');
                set(disableArray(:,[3 5 10]), 'Enable', 'off');
        end        
    end

% Reads manually inputted time and converts to a date number.
    function manualInputCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'
                match = regexp(hObject.String,'(0\d|1[0-2])/([0-3]\d)/\d\d (0\d|1\d|2[0-4]):[0-5]\d:[0-5]\d');                
                
                % Input argument must match format displayed in string.
                if match
                    val = datenum(hObject.String);
                    tl.setAxes.start = struct('Time',val,'String',hObject.String);
                    graph(1).time.isStartTimeAuto = 0;     
                    
                else
                    disp('Invalid Input Argument. Provide Time in MM/DD/YY HH:MM:SS Format.');
                end
                
            case 'Stop'
                match = regexp(hObject.String,'(0\d|1[0-2])/([0-3]\d)/\d\d (0\d|1\d|2[0-4]):[0-5]\d:[0-5]\d');                                
               
                if match
                     val = datenum(hObject.String);
                     tl.setAxes.stop = struct('Time',val,'String',hObject.String);
                     graph(1).time.isStopTimeAuto = 0;                                        
               
                else
                    disp('Invalid Input Argument. Provide Time in MM/DD/YY HH:MM:SS Format.');
                end        
        end             
    end

% Callback function for "milestone" radiobutton selection. 
    function milestoneCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'
                set(disableArray(:,[1:2 9]), 'Enable', 'on');
                set(disableArray(:,[3 5 7]), 'Enable', 'off');
            
            case 'Stop' 
                set(disableArray(:,[4 6 10]), 'Enable', 'on');  
                set(disableArray(:,[3 5 8]), 'Enable', 'off');
        end
        
        disp('Make sure to select or reselect drop-down item to update output values.')
    end

% Selects appropriate milestone structure based on popupmenu selection.
    function milestoneInputCallback (hObject, events, handles)
        if ~strcmp(hObject.String,'Empty')
            switch hObject.Parent.Tag
                case 'Start'
                    index = hObject.Value;
                    graph(1).time.isStartTimeAuto = 0;    
                    
                    % Since T0 has its own structure in the timeline file,
                    % it is treated in a separate if statement here. 
                    if ~strcmp(hObject.String(index),'T0')
                        tl.setAxes.start = t.timeline.milestone(index);
                        
                    else
                        tl.setAxes.start = t.timeline.t0;
                        % The T0 timeline structure is not case consistent
                        % with the other milestone structures. The
                        % following two commands internally fix that. 
                        tl.setAxes.start = ...
                            renameStructField(tl.setAxes.start,'time','Time');
                        tl.setAxes.start = ...
                            renameStructField(tl.setAxes.start,'name','String');
                    end
                    
                case 'Stop'
                    index = hObject.Value;
                    graph(1).time.isStopTimeAuto = 0;
                    
                    if ~strcmp(hObject.String(index),'T0')
                        tl.setAxes.stop = t.timeline.milestone(index);
                    
                    else
                        tl.setAxes.stop = t.timeline.t0;
                        tl.setAxes.stop = ...
                            renameStructField(tl.setAxes.stop,'time','Time');
                        tl.setAxes.stop = ...
                            renameStructField(tl.setAxes.stop,'name','String');                        
                    end
            end
            
        else
            disp('Milestones not available for this data set.');
        end
    end

% Callback fucntion for "offset" radiobutton selection. 
    function offsetCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'   
                set(disableArray(:,[1:3 7 9]), 'Enable', 'off');
                set(disableArray(:,5), 'Enable', 'on');
                disp('Select fixed stop point first and then input offset amount.');
           
            case 'Stop'         
                set(disableArray(:,[4:6 8 10]), 'Enable', 'off');
                set(disableArray(:,3), 'Enable', 'on');
                disp('Select fixed start point first and then input offset amount.')
        end             
    end

% Reads offset time, converts to a date number, appends from other limit.
    function offsetInputCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'  
                match = regexp(hObject.String,'(0\d|1\d|2[0-4]):[0-5]\d:[0-5]\d');
               
                % Input argument must match format displayed in string.
                if match
                    offsetAmt = datenum(['00 Jan 0000' ' ' hObject.String]);
                    
                    % 00 Jan 0000 must be added to ensure datenum doesn't
                    % convert from beginning of the current year instead.
                    val = tl.setAxes.stop.Time - offsetAmt;
                    tl.setAxes.start = struct('Time',val,'String',hObject.String,...
                                            'offsetAmount',offsetAmt);
                    graph(1).time.isStartTimeAuto = 0;
                
                else
                    disp('Invalid Input Argument. Offsets are limited to 24 hours.');
                end
                
            case 'Stop'
                match = regexp(hObject.String,'(0\d|1\d|2[0-4]):[0-5]\d:[0-5]\d');
                
                if match
                    offsetAmt = datenum(['00 Jan 0000' ' ' hObject.String]);
                   
                    val = tl.setAxes.start.Time + offsetAmt;
                    tl.setAxes.stop = struct('Time',val,'String',hObject.String,...
                                            'offsetAmount',offsetAmt);                    
                    graph(1).time.isStopTimeAuto = 0;
               
                else
                    disp('Invalid Input Argument. Offsets are limited to 24 hours.');
                end             
        end
    end

guidata(handles.figure1,handles)
uiwait % Waits for user to click apply or switch tabs to resume
 
% Saves set time limits to the graph structure.
    function applyCallback (hObject, events, handles)
        handles = guidata(hObject);
         
        % Tag allows for radiobutton ID when repopulating the GUI
        graph(1).time.startTag = handles.startTime.SelectedObject.Tag;
        graph(1).time.stopTag = handles.stopTime.SelectedObject.Tag;
                
        if ~graph(1).time.isStartTimeAuto
            graph(1).time.startTime = tl.setAxes.start;
        end
        
        if ~graph(1).time.isStopTimeAuto
            graph(1).time.stopTime = tl.setAxes.stop;
        end
        
        uiresume
        
    end

end
