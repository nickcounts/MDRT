function [ figureHandle ] = makeMDRTPlotFigure( varargin )
%makeMDRTPlotFigure creates a new figure window with the MDRT toolbars and
%menus and returns the figure handle.
%
%   figHandle = makeMDTRPlotFigure
%

% TODO:
% Allowable commands for the future?
%
% MDRTToolbar, on, off
% MDRTAdvanceMenu, on, off
% FigureOptions, cellArrayOfValidKeyValuePairs

% -------------------------------------------------------------------------
% Generate new figure and handle. Set up for priting
% -------------------------------------------------------------------------
    
    figureHandle = figure();
    
    saveButtonHandle = findall(figureHandle,'ToolTipString','Save Figure');
    
    set(saveButtonHandle, 'ClickedCallback', 'MARSsaveFigure');
    
    % Add label size toggle and timeline refresh buttons
    addToolButtonsToPlot(figureHandle);
    
    addAdvancedMenuToPlot(figureHandle);
    
    % Set plot/paper size and orientation if needed
    orient('landscape');
    
    % Hide File/Save as
    hMenuSaveAs = findall(gcf,'tag','figMenuFileSaveAs');
    hMenuSaveAs.Visible = 'off';
    
    % Override File/Save(as)
    hMenuSave   = findall(gcf,'tag','figMenuFileSave');
    set(hMenuSave, 'Callback', 'MARSsaveFigure');
    

end

