function hs = openingFunctionMakeGUI( varargin )
%openingFunctionMakeGUI creates the MARS DRT settings panel.
%
% Called by itself, it generates a stand-alone gui.
% Pass a handle to a parent object, and this panel will populate
% the parent object.
%
% makeDataImportGUI returns a handle structure
%
% Counts, 2016 VCSFA

if nargin == 0
    % Run as standalone GUI for testing
    % Run as standalone GUI for testing

    hs.fig = figure;
        guiSize = [672 387];
        hs.fig.Position = [hs.fig.Position(1:2) guiSize];
        hs.fig.Name = 'Data Import GUI';
        hs.fig.NumberTitle = 'off';
        hs.fig.MenuBar = 'none';
        hs.fig.ToolBar = 'none';
        hs.fig.Tag = 'importFigure';
        hs.fig.DeleteFcn = @windowCloseCleanup;

elseif nargin == 1
    % Populate a UI container
    
    hs.fig = varargin{1};
    
end




end


