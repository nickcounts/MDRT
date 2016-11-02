function eventMarkerVisibilityTool(hobj, event, varargin)
% eventMarkerVisibilityTool
%
%   MDRT Utility for customizing timeline event markers
%
%   Counts, VCSFA 2016


% Get handle to figure that calls this function
    fh = gcbf;

% Find all event markers in the calling figure:
    lines   = findall(fh, 'Tag',  'vline');
    labels  = findall(fh, 'Tag',  'vlinetext');
    
% Add listener to close this tool if the calling window closes
lh = addlistener(fh, 'Close', @graphWindowClosed);

% Prepare event strings, sorted list, and sort index for display in
% checklist
    eventStrings = {labels.String}';
    [eventStrings, sortIndex] = sort(eventStrings);

    
% Create tool window
%TODO: Make this a singleton instance - look for existing GUI

    hs.fig = figure;
            guiSize = [672 387];
            hs.fig.Position = [hs.fig.Position(1:2) guiSize];
            hs.fig.Name = 'Event Marker Visibility Tool';
            hs.fig.NumberTitle = 'off';
            hs.fig.MenuBar = 'none';
            hs.fig.ToolBar = 'none';
            hs.fig.Tag = 'importFigure';
            


% First create the data model
jList = java.util.ArrayList;  % any java.util.List will be ok



for i = 1:numel(eventStrings)
    jList.add(i - 1, eventStrings{i});
end

 
% Next prepare a CheckBoxList component within a scroll-pane
jCBList = com.mathworks.mwswing.checkboxlist.CheckBoxList(jList);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCBList);


% Create a check box model from control
    jCBModel = jCBList.getCheckModel;
    
% Update model to reflect current status    
    visibleEventIndex = find(strcmp({lines.Visible}, 'on'));
    
    for i = 1:length(visibleEventIndex)
        
        jListIndex = find(sortIndex==visibleEventIndex(i));
        
        jCBModel.checkIndex( jListIndex -1 );
        
    end

% Respond to checkbox update events
    jhCBModel = handle(jCBModel, 'CallbackProperties');
    set(jhCBModel, 'ValueChangedCallback', @checkBoxChanged); 

% Now place this scroll-pane within a Matlab container (figure or panel)
    [jhScroll,hContainer] = javacomponent(jScrollPane,[10,10,80,65], gcf);

    hContainer.Units = 'normalized';
    hContainer.Position = [0.05 0.05 0.9 0.85];

% Create "select all" checkbox
    selectAllControl = uicontrol(hs.fig, 'style', 'checkbox',... 
                            'units',        'normalized',... 
                            'position',     [0.05 0.925 0.9 0.05]);
                    
    selectAllControl.String = 'Select All Events';
    selectAllControl.Callback = @toggleAllButton; 


 



    function checkBoxChanged(hobj, event, varargin)

        
        
        % Get selected index and convert to 1 based matlab array index
        selectedInd = jCBModel.getCheckedIndicies + 1;
        
        % create default boolean array of false
        eventVisibilityIndex = false(size(lines));
        
        % set checked items to true
        eventVisibilityIndex(selectedInd) = true;
        
        %Loop through each event marker and reassign value.
        %TODO: only update those that changed
        for i = 1:numel(eventVisibilityIndex)
            
            if eventVisibilityIndex(i)
                % Visibility ON
                visibleValue = 'on';
            else
                visibleValue = 'off';
            end

        lines(sortIndex(i)).Visible = visibleValue;
        labels(sortIndex(i)).Visible = visibleValue;
        
        end

    end

    function toggleAllButton(hobj, event, varargin)
        
        
        
        % Update check model
        if hobj.Value
            % User selected all
            jCBModel.checkAll
        else
            % User de-selected all
            jCBModel.uncheckAll
        end
        
        %Update plot
        checkBoxChanged(hobj, event) 
        
    end

    function graphWindowClosed(hobj, event, varargin)
        
        close(hs.fig);

    end

end
