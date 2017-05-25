% MARSsaveFigure is a script for overriding the default save button
%
%   Gets the current graphics context, looks for a suptitle object and
%   generates an automatic name for saving MARS Data Plots.
%
%   Current version uses getConfig
%
%   Counts, Spaceport Support Services, 2014

%   Counts, VCSFA, 2017 - updated to be more fault tolerant. Fixed
%   documentation



config = getConfig;

fh = gcf;


%% Automatically select best font size for printing

    % Data Cursors / Tooltips
    cursors = findall(fh, 'type', 'hggroup');
    set(cursors, 'FontSize', 6)
    
    % Plot Legends
    legends = findall(fh, 'Type', 'Legend');
    set(legends, 'FontSize', 7); % default font was 9
    
    % Timeline Events
    
    
%% Intelligent filename guess based on plot super title

% Find handle to supertitle object and extract string
sth = findobj(fh,'Tag','suptitle');

if size(sth) == 0
    graphTitle = 'MDRT_Plot';
else
    graphTitle = sth.Children.String;
end

% clean up unhappy reserved filename characters
%     defaultName = regexprep(UserData.graph.name,'^[!@$^&*~?.|/[]<>\`";#()]','');
    defaultName = regexprep(graphTitle,'^[!@$^&*~?.|/[]<>\`";#()]','');
    defaultName = regexprep(defaultName, '[:]','-');
    
    if iscell(defaultName)
        defaultName = defaultName{1};
    end
    
    

% Open UI for save name and path
    [file,path] = uiputfile('*.pdf','Save Plot to PDF as:',fullfile(config.outputFolderPath, defaultName));

% Check the user didn't "cancel"
if file ~= 0
    saveas(fh, [path file],'pdf')
else
    % Cancelled... not sure what the best behavior is... return to GUI
end


% Garbage collection
clear config fh file path defaultName sth