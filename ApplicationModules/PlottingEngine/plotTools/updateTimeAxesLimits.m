function updateTimeAxesLimits( varargin )
% updateTimeAxesLimits ( varargin )
%   Updates the x-axis limits within the displayed graph and saves set
%   limit to graph configuration file. 
%   VARARGIN - Input argument is typically the interactive control that
%   initiated the GUI function and the Action Data.
%   This tool serves as an in-graph companion to setTimeAxesLimits
%
% July 2017, Patel - Mid-Atlantic Regional Spaceport

%% Variable Definitions
parentFigure = varargin{1}.Parent.Parent;
graphNumber = parentFigure.Number;

% In order to pass graph structure through plot, it's stored to the appdata
graph = getappdata(parentFigure, 'graph'); 
config = getConfig;

% Load timeline file
if exist(fullfile(config.dataFolderPath, 'timeline.mat'),'file')
    t = load(fullfile(config.dataFolderPath, 'timeline.mat'));
    milestoneString = string(cellstr({t.timeline.milestone.String}'));
    milestoneString = [milestoneString; t.timeline.t0.name];
    disp('Timeline File Successfully Loaded.');
    
else
    warndlg('Event data file "timeline.mat" was not found. Milestone option unavailable.');
    milestoneString = 'Empty';
end

% Check if the parent graph is a quickplot (thus disregarding graphstruct)
if strcmp('quickPlot',varargin{1}.Parent.Parent.Tag)
    quickFlag = true;
else
    quickFlag = false;
end

% An empty bin for storing isStartTimeAuto and isStopTimeAuto
% Under "apply" these are stored to the graph structure IFF not quickplot
startAuto = 1;
stopAuto = 1;

%% GUI Setup

    tl.fig = figure; % creates handle for the GUI window
    tl.fig.Resize = 'off';
    guiSize = [100 25];
    tl.fig.Units = 'characters';
    tl.fig.Position = [tl.fig.Position(1:2) guiSize];
    tl.fig.Name = 'Select Time Axes Limits';
    tl.fig.NumberTitle = 'off';
    tl.fig.MenuBar = 'none';
    tl.fig.ToolBar = 'none';

%% Layout and Populate GUI

    function guiStartOpeningFcn ( varargin )
        tl.startText = uicontrol(tl.fig, ...
                        'Style',    'Text', ...
                        'String',   'Start Time', ...
                        'Units',    'characters',...
                        'Position', [5, 22.5, 18, 1.5], ...
                        'FontSize', 12);

        tl.startTime = uibuttongroup(tl.fig, ...
                        'Units',    'characters',... 
                        'Tag',      'Start', ...
                        'Position', [2.5, 3, 45, 19])';            

        tl.noneStart = uicontrol('Parent', tl.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @noneCallback, ...
                        'String',   'None',...
                        'Tag',      'none', ...
                        'Units',    'characters',...
                        'Position', [2.5, 16.5, 15, 1.5]); 

        tl.manualStart = uicontrol('Parent', tl.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @manualCallback, ...
                        'String',   'Manual',...
                        'Tag',      'manual', ...
                        'Units',    'characters',...
                        'Position', [2.5, 13.5, 15, 1.5]); 

        tl.manualStartInput = uicontrol('Parent', tl.startTime, ...
                        'Style',    'edit', ...
                        'Callback', @manualInputCallback, ...
                        'String',   'MM/DD/YY HH:MM:SS', ...
                        'Tag',      'manual', ...
                        'Units',    'characters', ...
                        'Position', [6, 11.5, 33, 1.5]);

        tl.milestoneStart = uicontrol('Parent', tl.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @milestoneCallback, ...
                        'String',   'Milestone', ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 8.5, 15, 1.5]);

        tl.milestoneStartInput = uicontrol('Parent',    tl.startTime, ...
                        'Style',    'popupmenu', ...
                        'Callback', @milestoneInputCallback, ...
                        'String',   milestoneString, ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [6, 6.5, 33, 1.5]);

        tl.offsetStart = uicontrol('Parent', tl.startTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @offsetCallback, ...
                        'String',   'Offset', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 3.5, 15, 1.5]);

        tl.offsetStartInput = uicontrol('Parent', tl.startTime, ...
                        'Style',	'edit', ...
                        'Callback', @offsetInputCallback, ...
                        'String',   'HH:MM:SS', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [6, 1.5, 33, 1.5]);                                
    end
     
    function guiStopOpeningFcn ( varargin )
        tl.stopText = uicontrol(tl.fig, ...
                        'Style',    'Text', ...
                        'String',   'Stop Time', ...
                        'Units',    'characters',...
                        'Position', [55, 22.5, 18, 1.5], ...
                        'FontSize', 12);

        tl.stopTime = uibuttongroup(tl.fig, ...
                        'Units',    'characters',...    
                        'Tag',      'Stop', ...
                        'Position', [52.5, 3, 45, 19])';            

        tl.noneStop = uicontrol('Parent', tl.stopTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @noneCallback, ...
                        'String',   'None',...
                        'Tag',      'none', ...
                        'Units',    'characters',...
                        'Position', [2.5, 16.5, 15, 1.5]); 

        tl.manualStop = uicontrol('Parent', tl.stopTime, ...
                        'Style',    'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @manualCallback, ...
                        'String',   'Manual',...
                        'Tag',      'manual', ...
                        'Units',    'characters',...
                        'Position', [2.5, 13.5, 15, 1.5]); 

        tl.manualStopInput = uicontrol('Parent', tl.stopTime, ...
                        'Style',    'edit', ...
                        'Callback', @manualInputCallback, ...
                        'String',   'MM/DD/YY HH:MM:SS', ...
                        'Tag',      'manual', ...
                        'Units',    'characters', ...
                        'Position', [6, 11.5, 33, 1.5]);

        tl.milestoneStop = uicontrol('Parent', tl.stopTime, ...
                        'Style',        'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @milestoneCallback, ...
                        'String',   'Milestone', ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 8.5, 15, 1.5]);

        tl.milestoneStopInput = uicontrol('Parent',    tl.stopTime, ...
                        'Style',    'popupmenu', ...
                        'Callback', @milestoneInputCallback, ...
                        'String',   milestoneString, ...
                        'Tag',      'milestone', ...
                        'Units',    'characters', ...
                        'Position', [6, 6.5, 33, 1.5]);

        tl.offsetStop = uicontrol('Parent', tl.stopTime, ...
                        'Style',        'radiobutton', ...
                        'FontSize', 10, ...
                        'Callback', @offsetCallback, ...
                        'String',   'Offset', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [2.5, 3.5, 15, 1.5]);

        tl.offsetStopInput = uicontrol('Parent', tl.stopTime, ...
                        'Style',	'edit', ...
                        'Callback', @offsetInputCallback, ...
                        'String',   'HH:MM:SS', ...
                        'Tag',      'offset', ...
                        'Units',    'characters', ...
                        'Position', [6, 1.5, 33, 1.5]); 
                    
        tl.apply = uicontrol(tl.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @applyCallback, ...
                        'String',   'Apply to Axes', ...
                        'Tag',      'apply', ...
                        'Units',    'characters', ...
                        'Position', [20, 0.75, 20, 1.5]);
                    
        tl.save = uicontrol(tl.fig, ...
                        'Style',    'pushbutton', ...
                        'Callback', @saveStructureCallback, ...
                        'String',   'Save Graph Structure', ...
                        'Tag',      'save', ...
                        'Units',    'characters', ...
                        'Position', [60 0.75, 20, 1.5]);
    end

guiStartOpeningFcn() 
guiStopOpeningFcn()

% To make the code look less cluttered, I grouped GUI controls and nested
% them inside two separate functions. 

% Instead of calling each handle to set enable on/off, I created an array
% from which the indices can be called for the desired handle.

disableArray = [tl.noneStop tl.offsetStop tl.offsetStopInput tl.offsetStart ...
                tl.offsetStartInput tl.noneStart tl.manualStartInput ...
                tl.manualStopInput tl.milestoneStartInput ...
                tl.milestoneStopInput];
            
% Populate GUI with any existing graph structure time information                     
    function guiStartPopulate ( varargin )
        switch graph(graphNumber).time.startTag
            case 'none'
                tl.startTime.SelectedObject = tl.noneStart;
                set(disableArray(:,[2,3,5,7,9]),'Enable','off');
                set(disableArray(1), 'Enable', 'on');                
            
            case 'manual'
                tl.startTime.SelectedObject = tl.manualStart;
                set(disableArray(:,[1:2 7]), 'Enable', 'on');
                set(disableArray(:,[3 5 9]), 'Enable', 'off');
                set(tl.manualStartInput,'String',graph(graphNumber).time.startTime.String);
            
            case 'milestone'
                tl.startTime.SelectedObject = tl.milestoneStart;
                set(disableArray(:,[1:2 9]), 'Enable', 'on');
                set(disableArray(:,[3 5 7]), 'Enable', 'off'); 
                i = find(strcmp(tl.milestoneStartInput.String, ...
                            graph(graphNumber).time.startTime.String));
                set(tl.milestoneStartInput,'Value',i);
            
            case 'offset'
                tl.startTime.SelectedObject = tl.offsetStart;
                set(disableArray(:,[1:3 7 9]), 'Enable', 'off');
                set(disableArray(:,5), 'Enable', 'on');
                set(tl.offsetStartInput,'String',graph(graphNumber).time.startTime.String);
        end        
    end

   function guiStopPopulate ( varargin )
        switch graph(graphNumber).time.stopTag
            case 'none'
                tl.stopTime.SelectedObject = tl.noneStop;
                set(disableArray(:,[4:5 3 8 10]), 'Enable', 'off');
                set(disableArray(6), 'Enable', 'on');               
           
            case 'manual'
                tl.stopTime.SelectedObject = tl.manualStop;
                set(disableArray(:,[4 6 8]), 'Enable', 'on');
                set(disableArray(:,[3 5 10]), 'Enable', 'off');
                set(tl.manualStopInput,'String',graph(graphNumber).time.stopTime.String);
            
            case 'milestone'
                tl.stopTime.SelectedObject = tl.milestoneStop;
                set(disableArray(:,[4 6 10]), 'Enable', 'on');  
                set(disableArray(:,[3 5 8]), 'Enable', 'off');
                i = find(strcmp(tl.milestoneStopInput.String, ...
                            graph(graphNumber).time.stopTime.String));
                set(tl.milestoneStopInput,'Value',i);
            
            case 'offset'
                tl.stopTime.SelectedObject = tl.offsetStop;
                set(disableArray(:,[4:6 8 10]), 'Enable', 'off');
                set(disableArray(:,3), 'Enable', 'on');
                set(tl.offsetStopInput,'String',graph(graphNumber).time.stopTime.String);
        end        
   end

% Repopulate if graph structure present
if ~quickFlag
    guiStartPopulate()
    guiStopPopulate() 
    
else
    set(disableArray(:,[2:5 7:10]), 'Enable', 'off');
end
            
%% Establishing Original X Limits and Creating Structures

% Find all plotted lines in the figure (there are types 'line' and 'stair')

axes = findobj(parentFigure,'Type','Axes');
tl.line = [findobj(axes,'Type','line'); findobj(axes,'Type','Stair')];
numberOfSubplots = length(tl.line);

% For each of the lines, determine the starting and ending x data points

for i = 1:numberOfSubplots
        XData{1,i} = tl.line(i).XData;
        Xtrema(i,1) = XData{1,i}(1,1);
        length(tl.line(i).XData);
        Xtrema(i,2) = XData{1,i}(1,length(tl.line(i).XData));
end
    
% The default (for selecting "none" from a changed time selection) then
% switches to the most extreme starting and stopping times across all
% plots.

XLim = [min(Xtrema(:,1)) max(Xtrema(:,2))];
tl.setTime = XLim;

if ~quickFlag
    % This is the default structure that will be saved to the graph config.
    
    tl.setAxes = struct('start',graph(graphNumber).time.startTime,...
                        'stop',graph(graphNumber).time.stopTime);
    set(tl.save,'Enable','on');
    
else
    tl.setAxes = struct('start',[],'stop',[]);
    set(tl.save,'Enable','off');
end
            
%% Callback Functions

% Callback function if "none" is selected for limit type. 
    function noneCallback (hObject, events, handles)
        switch hObject.Parent.Tag
            case 'Start'
                set(disableArray(:,[2:3 5 9 7]), 'Enable', 'off');
                set(disableArray(1), 'Enable', 'on');
                startAuto = 1;
                tl.setAxes.start = [];
                tl.setTime(1) = XLim(1)
           
            case 'Stop'       
                set(disableArray(:,[4:5 3 8 10]), 'Enable', 'off');
                set(disableArray(6), 'Enable', 'on');
                stopAuto = 1;
                tl.setAxes.stop = [];
                tl.setTime(2) = XLim(2);
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
                    startAuto = 0;         
                    tl.setTime(1) = val;
                
                else
                    disp('Invalid Input Argument. Provide Time in MM/DD/YY HH:MM:SS Format.');
                end
                
            case 'Stop'
                match = regexp(hObject.String,'(0\d|1[0-2])/([0-3]\d)/\d\d (0\d|1\d|2[0-4]):[0-5]\d:[0-5]\d');                                
                
                if match
                     val = datenum(hObject.String);
                     tl.setAxes.stop = struct('Time',val,'String',hObject.String);
                     stopAuto = 0;    
                     tl.setTime(2) = val;
                
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
                    startAuto = 0;                                        
                    
                    % Since T0 has its own structure in the timeline file,
                    % it is treated in a separate if statement here.                    
                    if ~strcmp(hObject.String(index),'T0')
                        tl.setAxes.start = t.timeline.milestone(index);
                        tl.setTime(1) = t.timeline.milestone(index).Time; 
                    
                    else
                        tl.setAxes.start = t.timeline.t0;
                        % The T0 timeline structure is not case consistent
                        % with the other milestone structures. The
                        % following two commands internally fix that.
                        tl.setAxes.start = ...
                            renameStructField(tl.setAxes.start,'time','Time');
                        tl.setAxes.start = ...
                            renameStructField(tl.setAxes.start,'name','String');
                        tl.setTime(1) = t.timeline.t0.time;
                    end
                    
                case 'Stop'
                    index = hObject.Value;
                    stopAuto = 0;
                   
                    if ~strcmp(hObject.String(index),'T0')
                        tl.setAxes.stop = t.timeline.milestone(index);
                        tl.setTime(2) = t.timeline.milestone(index).Time;
                   
                    else
                        tl.setAxes.stop = t.timeline.t0;
                        tl.setAxes.stop = ...
                            renameStructField(tl.setAxes.stop,'time','Time');
                        tl.setAxes.stop = ...
                            renameStructField(tl.setAxes.stop,'name','String'); 
                        tl.setTime(2) = t.timeline.t0.time; 
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
                    startAuto = 0;
                    tl.setTime(1) = val;
               
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
                    stopAuto = 0;
                    tl.setTime(2) = val;
                
                else
                    disp('Invalid Input Argument. Offsets are limited to 24 hours.');
                end             
        end
    end

% Applies time limits to the current figure and saves appdata to figure. 
    function applyCallback (hObject, events, handles)
        figure(parentFigure);
        hold on
        
        % Create a boundary/buffer on each side of the time limit
        delta = 0.02*(tl.setTime(2)-tl.setTime(1));
        tl.setTime(1) = tl.setTime(1)- delta;
        tl.setTime(2) = tl.setTime(2) + delta;  

        % Apply new x axis limits and rescale all timeline markers
        xlim(tl.setTime)
        reviewRescaleAllTimelineEvents(parentFigure);
        hold off

        if ~quickFlag
            graph(graphNumber).time.isStartTimeAuto = startAuto;
            graph(graphNumber).time.isStopTimeAuto = stopAuto;
            
            % Tag allows for radiobutton ID when repopulating the GUI
            
            graph(graphNumber).time.startTag = tl.startTime.SelectedObject.Tag;
            graph(graphNumber).time.stopTag = tl.stopTime.SelectedObject.Tag;

            if ~graph(graphNumber).time.isStartTimeAuto
                graph(graphNumber).time.startTime = tl.setAxes.start;
            end

            if ~graph(graphNumber).time.isStopTimeAuto
                graph(graphNumber).time.stopTime = tl.setAxes.stop;
            end        

            % Save data to the appdata attached to figure. 
            setappdata(parentFigure,'graph',graph);
        end
    end

% Saves the time configuration to the graph structure for future use. 
    function saveStructureCallback (hObject, events, handles)
         
        % Tag allows for radiobutton ID when repopulating the GUI
        graph(graphNumber).time.startTag = tl.startTime.SelectedObject.Tag;
        graph(graphNumber).time.stopTag = tl.stopTime.SelectedObject.Tag;
                
        if ~graph(graphNumber).time.isStartTimeAuto
            graph(graphNumber).time.startTime = tl.setAxes.start;
        end
        
        if ~graph(graphNumber).time.isStopTimeAuto
            graph(graphNumber).time.stopTime = tl.setAxes.stop;
        end      

        setappdata(parentFigure,'graph',graph);        
        
        % The below code is pulled from makeGraphGUI.
        % Generate default filename from graph structure
        defaultName = graph(graphNumber).name;

            % clean up unhappy reserved filename characters
            defaultName = regexprep(defaultName,'^[!@$^&*~?.|/[]<>\`";#()]','');
            defaultName = regexprep(defaultName, '[:]','-');

            % Guarantee defaultName is a string
            if iscell(defaultName)
                defaultName = defaultName{1};
            end

        % Attempt to autopopulate the path
        if isfield(config, 'graphConfigFolderPath')
            % Loads path from configuration
            lookInPath = config.graphConfigFolderPath;
            disp(lookInPath)
        else
            % Set default path... to graph
            lookInPath = config.dataFolderPath;
        end    

        % Open UI for save name and path
        [file,path] = uiputfile('*.gcf','Save Graph Configuration as:',fullfile(lookInPath, defaultName));

        % Check the user didn't "cancel"
        if file ~= 0
            save(fullfile(path, file), 'graph', '-mat');
        end        
    end

end

%% ToDO
% add multiplot functionality??
% change icon JPG size