function [  ] = addToolButtonsToPlot( figureHandle )
%addToolButtonsToPlot adds toggle lable size and timeline refresh buttons
%to MARS DRT Generated plot windows
%
%   Detailed explanation goes here


% Create the toolbar
    fh = figureHandle;
    tbh = uitoolbar(fh);

% Add a push tool to the toolbar
 
    toggleIcon  = imread( getResource('toggleLabelSize_icon_16x16.png'),'png');
    refreshIcon = imread( getResource('refreshTimeline_icon_16x16.png'),'png');
    showIcon    = imread( getResource('showTimeline_icon_16x16.png'),'png');
    xAxisIcon   = imread( getResource('timeAxes_icon_23x25'),'png');
    
    
% % Convert white pixels into a transparent background
%     map(find(map(:,1)+map(:,2)+map(:,3)==3)) = NaN;
% % Convert into 3D RGB-space
%     toggleIcon = ind2rgb(toggleIcon,map);
    
    togBut = uipushtool(tbh,'CData',toggleIcon,...
                            'TooltipString','Toggle label sizes',...
                            'HandleVisibility','on');
                        
    refBut = uipushtool(tbh,'CData',refreshIcon,...
                            'TooltipString','Refresh event markers',...
                            'HandleVisibility','on');
                        
    visBut = uitoggletool(tbh,'CData',showIcon, ...
                            'TooltipString','Hide Event Markers',...
                            'HandleVisibility','on', ...
                            'State', 'on');
                        
    xaxBut = uipushtool(tbh,'CData',xAxisIcon, ...
                            'TooltipString','Change and Update X Axis',...
                            'HandleVisibility','on');


togBut.ClickedCallback = {@reviewRescaleAllTimelineLabels};
refBut.ClickedCallback = {@reviewRescaleAllTimelineEvents};
visBut.ClickedCallback = {@reviewToggleEventVisibility};
xaxBut.ClickedCallback = {@updateTimeAxesLimits};

end

