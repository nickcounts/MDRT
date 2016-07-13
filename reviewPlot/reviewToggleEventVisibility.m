function reviewToggleEventVisibility( figureHandle, varargin )
% reviewToggleEventVisibility hides or shows timeline event markers in a
% particular figure or in all open figures
%
% Use:
%
%   reviewToggleEventVisibility( figureNumber )
%
%   reviewToggleEventVisibility( toolbar.PushTool, eventdata.ActionData )
%
%   Counts 2016 VCSFA


% Default the search to the graphics root
parentFigure = 0;


switch nargin
    case 0
        % Assume we were passed a figure number/handle directly
        parentFigure = figureHandle;
    case 2
        if strcmpi(class(varargin{1}), 'matlab.ui.eventdata.ActionData')
            % We were passed an ActionData object
            
            % Extract figure number
            parentFigure = varargin{1}.Source.Parent.Parent.Number;
            
            buttonHandle = figureHandle;
            
            % Lets add special behavior if called from the toggle button.
            toggleEventsAndButton(parentFigure, buttonHandle)
            return
        end
        
    otherwise
        % Other things I want to do? Not sure right now
        
end
    
    lines   = findall(parentFigure, 'Tag',  'vline');
    labels  = findall(parentFigure, 'Tag',  'vlinetext');
    


    for i = 1:length(lines)
        
        if strcmpi(lines(i).Visible, 'off')
            % Lines were invisible, so turn them on
            
            lines(i).Visible = 'on';
            
        else
            % Lines were visible, so turn them off
            
            lines(i).Visible = 'off';
        end
        
    end
            
    for j = 1:length(labels)
        
        if strcmpi(labels(j).Visible, 'off')
            % Labels were invisible, so turn them on
            
            labels(j).Visible = 'on';
            
        else
            % Labels were visible, so turn them off
            
            labels(j).Visible = 'off';
        end
        
    end    

end

function toggleEventsAndButton( figureHandle, buttonHandle )

    lines   = findall(figureHandle, 'Tag',  'vline');
    labels  = findall(figureHandle, 'Tag',  'vlinetext');
    % change the icon with buttonHandle.CData
    
    switch buttonHandle.State
        case 'on'
            % ON means visibility is ON
            % Set icon to visible mode
            buttonHandle.CData = imread('reviewPlot/images/showTimeline_icon_16x16.png','png');
            
            buttonHandle.TooltipString = 'Hide Event Markers';
            
        case 'off'
            % OFF means visibility is OFF
            % Set icon to hidden mode
            buttonHandle.CData = imread('reviewPlot/images/hideTimeline_icon_16x16.png','png');
            
            buttonHandle.TooltipString = 'Show Event Markers';
    end
    
    % Loop through all event lines
    for i = 1:length(lines)
        
        lines(i).Visible = buttonHandle.State;
        
    end
            
    for j = 1:length(labels)
        
        labels(j).Visible = buttonHandle.State;
        
    end
    


end
