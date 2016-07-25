function [  ] = addToolButtonsToPlot( figureHandle )
%addToolButtonsToPlot adds toggle lable size and timeline refresh buttons
%to MARS DRT Generated plot windows
%
%   Detailed explanation goes here


% Create the toolbar
    fh = figureHandle;
    tbh = uitoolbar(fh);

% Add a push tool to the toolbar
 
    toggleIcon  = imread('reviewPlot/images/toggleLabelSize_icon_16x16.png','png');
    refreshIcon = imread('reviewPlot/images/refreshTimeline_icon_16x16.png','png');
    showIcon    = imread('reviewPlot/images/showTimeline_icon_16x16.png','png');
    
    
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


togBut.ClickedCallback = {@reviewRescaleAllTimelineLabels};
refBut.ClickedCallback = {@reviewRescaleAllTimelineEvents};
visBut.ClickedCallback = {@reviewToggleEventVisibility};


end

