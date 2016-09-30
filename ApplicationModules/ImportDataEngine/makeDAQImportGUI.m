

    hs.fig = figure;
        guiSize = [672 387];
        hs.fig.Position = [hs.fig.Position(1:2) guiSize];
        hs.fig.Name = 'Data Import GUI';
        hs.fig.NumberTitle = 'off';
        hs.fig.MenuBar = 'none';
        hs.fig.ToolBar = 'none';
        hs.fig.Tag = 'importFigure';
        % hs.fig.DeleteFcn = @windowCloseCleanup;
        

             

% Button Properties
% ------------------------------------------------------------------------

uicontrol(hs.fig, 'Style', 'pushbutton', 'position', [480  37  80  30], 'String', 'Previous', 'Tag', 'back');
uicontrol(hs.fig, 'Style', 'pushbutton', 'position', [570  37  80  30], 'String', 'Next', 'Tag', 'next');                


% Work Area Properties
% ------------------------------------------------------------------------

p = uipanel(hs.fig, 'units', 'pixels', 'position', [167  73 483 292], 'backgroundcolor', [1 1 1]);                


% Progress indicator button properties
% ------------------------------------------------------------------------
progressIndicators = {
    uicontrol(hs.fig, 'Style', 'radiobutton', 'Enable', 'Inactive', 'Position', [ 17  314 134  23], 'String', 'Introduction', 'Value', 1);
    uicontrol(hs.fig, 'Style', 'radiobutton', 'Enable', 'Inactive', 'Position', [ 17  285 134  23], 'String', 'Step 1');
    uicontrol(hs.fig, 'Style', 'radiobutton', 'Enable', 'Inactive', 'Position', [ 17  256 134  23], 'String', 'Step 2');
    uicontrol(hs.fig, 'Style', 'radiobutton', 'Enable', 'Inactive', 'Position', [ 17  227 134  23], 'String', 'Step 3');
    uicontrol(hs.fig, 'Style', 'radiobutton', 'Enable', 'Inactive', 'Position', [ 17  198 134  23], 'String', 'Step 4');
};



% Step 1 - Introduction
% ------------------------------------------------------------------------

pageContents{1} = {

    uicontrol(p, 'Style', 'text', 'position', [ 33 237 430 27], 'HorizontalAlignment', 'center', 'String', 'MARDAQ Data Import Tool', 'backgroundcolor', [1 1 1], 'FontSize', 20, 'FontWeight', 'bold');
    uicontrol(p, 'Style', 'text', 'position', [108 214 266 13], 'HorizontalAlignment', 'center', 'String', 'Select a MARDAQ data file to begin.', 'backgroundcolor', [1 1 1]);
    uicontrol(p, 'Style', 'text', 'position', [ 12 114 462 13], 'HorizontalAlignment', 'center', 'String', 'No file selected.', 'backgroundcolor', [1 1 1]);

    uicontrol(p, 'Style', 'pushbutton', 'position', [183 164 110  21], 'String', 'Select File');

};

% Step 2 - header parsing
% ------------------------------------------------------------------------

pageContents{2} = {

    uicontrol(p, 'Style', 'text', 'position', [35 268 250 13], 'HorizontalAlignment', 'left', 'String', 'Select the row with column names', 'backgroundcolor', [1 1 1]);
    uicontrol(p, 'Style', 'text', 'position', [35 118 151 13], 'HorizontalAlignment', 'left','String', 'Select first row of data', 'backgroundcolor', [1 1 1]);

    uicontrol(p, 'Style', 'listbox', 'position', [35 167 433 100])
    uicontrol(p, 'Style', 'listbox', 'position', [35  16 433 100])
};

% Step 3 - Data names
% ------------------------------------------------------------------------

pageContents{3} = {

    uicontrol(p, 'Style', 'text', 'position', [35 268 250 13], 'HorizontalAlignment', 'left', 'String', 'Select the row with column names', 'backgroundcolor', [1 1 1]);
};

% Step 4 - Data names
% ------------------------------------------------------------------------

pageContents{4} = {

    uicontrol(p, 'Style', 'text', 'position', [35 268 250 13], 'HorizontalAlignment', 'left', 'String', 'Select the row with column names', 'backgroundcolor', [1 1 1]);
};

% Step 53 - Data names
% ------------------------------------------------------------------------

pageContents{5} = {

    uicontrol(p, 'Style', 'text', 'position', [35 268 250 13], 'HorizontalAlignment', 'left', 'String', 'Select the row with column names', 'backgroundcolor', [1 1 1]);
};

