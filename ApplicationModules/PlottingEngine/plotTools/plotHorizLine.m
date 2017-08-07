function hl = plotHorizLine( varargin )
% hl = plotHorizLine ( varargin )
%   Plots and styles a horizontal line on the selected plot.
%   VARARGIN - Input argument is typically the interactive control that
%   initiated the GUI function and the Action Data. 
%   This code uses elements from Brandon Kuczenski of Kensington Labs.
%   brandon_kuczenski@kensingtonlabs.com, 8 November 2001
%
% Modified 2017, Patel - Mid-Atlantic Regional Spaceport

figureHandle = varargin{1}.Parent.Parent; % calls the handle of the original plot

%% GUI Setup

    hl.fig = figure; % creates handle for the GUI window
    hl.fig.Resize = 'off';
    guiSize = [350 310];
    hl.fig.Position = [hl.fig.Position(1:2) guiSize];
    hl.fig.Name = 'Horizontal Line Tool';
    hl.fig.NumberTitle = 'off';
    hl.fig.MenuBar = 'none';
    hl.fig.ToolBar = 'none';

%% Variable Definitions

    String  = {'Value';'Label';'Color';'Style';'Optional';...
                'Save';'Delete'}; % String values for GUI interface
            
    data = struct('style','r-','label','','value','',...
                    'count',0,'select',''); 
                % Data structure that can be called across functions. 
                % The individual fields refer to differrent values that
                % are referenced in multiple callback functions.
                
    % Finds all existing horizontal lines and labels           
    data.line = findall(figureHandle, 'Tag', 'hline');
    prevtext = findall(figureHandle, 'Type','text','Tag','hlabel');
        
    % If there are existing labels, create a string array to populate the
    % listbox GUI. Otherwise leave blank. 
    if ~isempty(prevtext)
        data.text = prevtext;
        prevlist = flipud(string(cellstr({prevtext.String}')));
        data.list = prevlist;
    
    else
        prevlist = '';
        data.list = strings(1);
    end
    
    % Find all subplots in graph. 
    axes = findobj(figureHandle,'Type','Axes');
    numberOfSubplots = length(axes)-1;
    
    % Note that if there is no subplot, suptitle is lumped as the title of
    % the main plot and thus the number of axes is correct. Subtracting 1
    % would then yield 0, hence the conditional statement below. 
    if numberOfSubplots ~= 0
        plotString = cell(numberOfSubplots,1); % Create the empty array to save computational time. 
       
        % Pulls the name of the subplots to populate the drop down menu.
        for i = 1:numberOfSubplots
            plotString(i,1) = axes(i,:).Title.String;
        end
        
        plotString = flipud(plotString);
        axes = flipud(axes); axes(1) = []; % Internally deletes suptitle axes
    
    else 
        plotString = axes.Title.String;
    end
    
%% GUI Layout

    function guiOpeningFcn ( varargin )
        hl.text_plot = uicontrol(hl.fig,...
                'Style',        'text', ...
                'String',       'Plot',...
                'Position',      [40, 275, 50, 20]);

        hl.popup_plot = uicontrol(hl.fig,...
                'Style',        'popupmenu', ...
                'String',       plotString,...
                'Callback',     @popupCallbackPlot,...  
                'Tag',          'plot',...
                'Value',        1,...
                'Position',      [96, 275, 212, 20]);    

        hl.text_value = uicontrol(hl.fig,...
                'Style',        'text', ...
                'String',       String{1},...
                'Position',      [40, 245, 50, 20]);

        hl.edit_value =   uicontrol(hl.fig,...
                'Style',        'edit',...
                'String',       '',...
                'Callback',     @enterTextCallback,...
                'Tag',          'editValue',...
                'TooltipString',    'Enter Y-Value',...                
                'Position',     [96, 245, 212, 20]);     

        hl.panel = uipanel(hl.fig,...
                'Title',        String{5},...
                'Units',        'pixels',...
                'Position',     [20, 140, 313, 95]);  

        hl.text_label = uicontrol('Parent', hl.panel,...
                'Style',        'text', ...
                'String',       String{2},...
                'Position',      [20, 51, 50, 20]);

        hl.edit_label =   uicontrol('Parent', hl.panel,...
                'Style',            'edit',...
                'String',           '',...
                'TooltipString',    'Name and Print Line Label',...        
                'Callback',         @enterTextCallback,...
                'Tag',              'editLabel',...        
                'Position',         [76, 51, 212, 20]);

        hl.text_color = uicontrol('Parent',     hl.panel,...
                'Style',        'text', ...
                'String',       String{3},...
                'Position',      [23, 17, 44, 20]);

        hl.popup_color = uicontrol(hl.panel,...
                'Style',        'popupmenu', ...
                'String',       {'Red';'Blue';'Yellow';'Green';'Black'},...
                'Callback',     @popupCallback,...  
                'Tag',          'color',...
                'Position',      [76, 17, 72, 20]);

        hl.text_style = uicontrol(hl.panel,...
                'Style',        'text', ...
                'String',       String{4},...
                'Position',      [160, 17, 50, 20]);    

        hl.popup_style = uicontrol(hl.panel,...
                'Style',        'popupmenu', ...
                'String',       {'Solid';'Dashed';'Dotted'},...
                'Callback',     @popupCallback,...
                'Tag',          'linestyle',...
                'Position',      [210, 17, 72, 20]);  

        hl.button_save = uicontrol(hl.fig,...
                'Style',        'pushbutton',...
                'String',       String{6},...
                'Callback',     @saveCallback,...
                'toolTipString',    'Save and Plot Line',...
                'Position',     [79, 113, 69, 20]);

        hl.button_delete = uicontrol(hl.fig,...
                'Style',        'pushbutton',...
                'String',       String{7},...
                'Callback',     @deleteCallback,...
                'toolTipString',    'Delete Line',...
                'Position',     [224, 113, 69, 20]);

        hl.listbox_lines = uicontrol(hl.fig,...
                'Style',        'listbox',...
                'Tag',          'listbox',...
                'String',       prevlist,...
                'Callback',     @listCallback,...                
                'Position',     [22, 14, 303, 88]);
    end
    
guiOpeningFcn()

% To make the code look less cluttered, I grouped GUI controls and nested
% them inside a separate function. 

handles = guihandles(hl.fig);
guidata(hl.fig,handles); % Creates structure of guidata based on tags 
% defined within the uicontrol elements above. guidata can be accessed
% across multiple callback functions.

    
%% Callback Functions

% Reads and processes entered value and label text
    function enterTextCallback(hObject, event, handles )
        % Receives values entered into the edit textboxes.
        switch hObject.Tag
            case 'editValue' % Value receives the location of the line.
                val = str2num(hObject.String);
               
                if isa(val,'numeric') == 1 
                    data.value = val;
                end 
                % Value entry must be numeric. If not, default field value
                % remains in the data structure as an empty character.
            
            case 'editLabel'
                if ~isempty(hObject.String)
                    label = hObject.String;
                    data.label = label;
                    % If the user specifies a label for the line, the label
                    % is stored into the data structure.
                
                else 
                    data.label = ''; 
                end
        end
    end

% Reads and concatenates style and color selections
    function popupCallback(hObject, event, handles)
      handles = guidata(hl.fig);
      
      str1 = handles.color.String; % Returns all string values for the popupmenu as specified in the uicontrol.
      val1 = handles.color.Value; % Returs the index of the selected item in the menu.
    
      switch str1{val1}
          case 'Red' 
             color = 'r';
          case 'Blue' 
             color = 'b'; 
          case 'Yellow' 
             color = 'y';
          case 'Green' 
             color = 'g';
          case 'Black' 
             color = 'k';         
      end
      
      str2 = handles.linestyle.String;
      val2 = handles.linestyle.Value;
      
      switch str2{val2}
          case 'Solid' 
             ls = '-';
          case 'Dashed' 
             ls = '--'; 
          case 'Dotted' 
             ls = ':';     
      end
      
      st = strcat(char(color),char(ls)); % concatenates line color and style
      data.style = st; % Stores selected line color/style into data structure
    end

% Reads plot selection to make current axes
    function popupCallbackPlot(hObject, event, handles)
        handles = guidata(hl.fig);
        val = handles.plot.Value; 
        setAxes = axes(val);
        subplot(setAxes);
    end

% Saves and plots and lists the new horizontal line
    function saveCallback(hObject, event, handles)
        figure(figureHandle); % sets current figure to parent figure
        hold on
       
        y = data.value;
        x = get(gca,'xlim'); % retrieves x-axis bounds from parent graph
       
        if ~isempty(y)  % if the y value was entered and stored, proceed
            
            if ~strcmp(data.label,data.list) | isempty(data.label)
               
                % Store the data label in the displayname as well to match
                % the line to the list and text items (tag is already
                % occupied by 'hline'
                h = plot(x,[y y],data.style,'Tag','hline','DisplayName',data.label); % plot a horizontal line across those bounds with the specified style
                index = length(data.line); % The 'index' will then be one after the last entry
                
                if ~isempty(data.label) % plot any input line labels
                    % Following text plotting code from Kuczenski, B. 
                    yy=get(gca,'ylim'); 
                    yrange=yy(2)-yy(1);
                    yunit=(y-yy(1))/yrange;
                    
                    if yunit<0.2
                        l = text(x(1)+0.02*(x(2)-x(1)),y+0.02*yrange,...
                            data.label,'color',get(h,'color'),'Tag','hlabel');
                        data.text(index+1) = l;
                    
                    else
                        l = text(x(1)+0.02*(x(2)-x(1)),y-0.02*yrange,...
                            data.label,'color',get(h,'color'),'Tag','hlabel');
                        data.text(index+1) = l;
                    end
                    name = string(data.label);
                
                else % If no input line name provided, create generic one
                    checkName = 'Line' + string(index+1);
                    logic = strcmp(checkName, data.list);
                    
                    % If the generic Line# is not already in the list, add
                    if ~any(logic)
                        name = checkName;
                    
                    % Otherwise, figure out the largest #, and then add 1
                    % See Note 1 at end of code. 
                    else
                        lineNumMatrix = char(data.list');
                        lineNumMatrix = str2num(lineNumMatrix(:,5));
                        newLineNumber = max(lineNumMatrix);                        
                        name = 'Line' + string(newLineNumber+1);
                    
                    end
                    
                    % A text file is still created to match indices 
                    % See Note 2 at end of code. 
                    l = text(x(1),y, char(name),'Tag','hlabel','Visible','off');
                    data.text(index+1) = l;
              
                end
                h.DisplayName = name;
                
                data.line(index+1) = h; % store the horizontal line structure at its indexed value
                data.list(index+1) = name; % store all data labels at their indexed values
                
                handles = guidata(hl.fig);
                handles.listbox.String = data.list; % update listbox with data labels of plotted lines
                drawnow
                guidata(hl.fig, handles)
            
            else
                disp('Invalid Input Argument.');
                disp('Make sure "Value" is a number and "Label" is not a repeat.');                
            end
            
        else
            disp('Invalid Input Argument.');
            disp('Make sure "Value" is a number and "Label" is not a repeat.');
        end
        hold off
        % See Note 3 for data.list, data.text, and data.line
    end

% Reads and provides index for listbox selection, highlights line
    function listCallback (hObject,event, handles)
        set(data.line, 'Selected','off'); % Set all selected states off
        
        select = string(hObject.String);
        num = hObject.Value;
       
        data.select = select(num); % Return index of selected listbox item. Must be highlighted blue to return.
        
        % Find the horizontal line with the Display Name tag (same as listbox name)
        selLine = findall(figureHandle, 'Tag', 'hline','DisplayName',char(data.select));
        selLine.Selected = 'on';
    end

% Deletes selected horizontal line
    function deleteCallback (hObject,event,handles)
        handles = guidata(hl.fig);
        
        % If there is no active stored selection or if the stored selection
        % happens to not be in the list, set the selection to last stored
        % index value. 
        if isempty(data.select) | ~any(strcmp(data.select,data.list))
            data.select = data.list(handles.listbox.Value);
        end
        
        % Find index of the listbox selection matching the selected line.
        delListIndex = find(strcmp(data.list,data.select));
       
        data.list(delListIndex) = []; % Deletes that line from LIST
        handles.listbox.String = data.list; % Updates listbox
        
        % Resets the active selection to the listbox item just above the
        % deleted item.
        if delListIndex ~= 1
            handles.listbox.Value = delListIndex -1;
        else
            handles.listbox.Value = 1;
        end
        
        guidata(hl.fig, handles)
        drawnow % Refreshes listbox and uicontrols
        
        % Delete selection from LINE and from graph. 
        delLine = findall(figureHandle, 'Tag', 'hline','DisplayName',char(data.select));
        delLineIndex = find(data.line == delLine);
        delete(data.line(delLineIndex));
        data.line(delLineIndex) = [];
        
        % Delete selection from TEXT and from graph text item. 
        delText = findall(figureHandle,'Type','text','Tag','hlabel','String',char(data.select));
        delTextIndex = find(data.text == delText);
        delete(data.text(delTextIndex));
        data.text(delTextIndex) = [];
       

    end

end


%% Note
% 1 - There are cases where the user does not input any names and lines 1,
%       2, and 3 are plotted. If line 2 is deleted and then a new unnamed
%       line is plotted, the index value is 3 and the automatic name
%       generation would create a second 'Line3.' To avoid that, if the
%       automatic name matches any listbox selection, all line #'s (1 and
%       3) are extracted and the maximum (3) found. The next plotted line
%       is then labeled as 'Line4.'
% 2 - If no user line label is inputted, then no line label is meant to be
%       plotted. However, to ensure that the indices align in data.list, 
%       data.line, and data.text, a text element is still created and just
%       set to visibility off. 
% 3 - Note: the line label is stored in three places: label, list, and
%       text. Data.label is what was read from the edit text uicontrol.
%       Data.text stores the plotted text label (if present) in a manner
%       similar to storing the plotted line 'h'. Data.list keeps track of
%       all plotted lines, assigning references to lines that were not
%       given user labels. This allows for proper indexing alignment.

%% TODO
% change the units to characters and redo the sizes on everything
% add keyPressFcn functionality with the enter key
% horizline window goes to background as plot comes to foreground after
% save is clicked
% prevent two windows from opening
% change the data structure to a GUI handle?
% repopulate fields once you select an old line in the listbox


