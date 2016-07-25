% MARSsaveFigure is a script for overriding the default save button
%
%   Gets the current graphics context, looks for the UserData.graph
%   structure and generates an automatic name for saving MARS Data Plots.
%
%   Current version uses getConfig
%
%   Counts, Spaceport Support Services, 2014



config = getConfig;

fh = gcf;

UserData = get(fh, 'UserData');

% Find handle to supertitle object and extract string
sth = findobj(fh,'Tag','suptitle');
graphTitle = sth.Children.String;

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
clear config fh UserData file path defaultName