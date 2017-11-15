function exportMilestones (hObj, ~, varargin)
%% exportMilestones
%
%   exportMilestones(hObj)
%   exportMilestones(hObj, ~, 'option')
%
%   option:
%           'prompt'    Display save file dialog for new timeline file
%           'noprompt'  Save timeline file without prompting (default)
%
%   Tries to load the timeline file from the working data path (currently
%   uses getConfig). Generates a new file if none found.
%
%   Expects to find a timeline milestone structure in the hObj parent's
%   appdata with the name milestones.
%
% Counts - VCSFA/MARS - 11-2017



%% Constant Definitions
% -------------------------------------------------------------------------

% timeline file name    
    timelineFile = 'timeline.mat';


%% Handle options
% -------------------------------------------------------------------------

showSaveDialog = false;

if nargin > 2
    switch lower(varargin{1})
        case 'prompt'
            % User will be shown a save file dialog
            showSaveDialog = true;
        otherwise
            
    end
end



%% 
% -------------------------------------------------------------------------

    config = getConfig;
    %path = config.dataFolderPath;
    
    savePath = path;
    saveFile = timelineFile;
    
    milestones = getappdata(hObj.Parent, 'milestones');



%% Check for existing timeline.mat in the data directory and load if exists
% -------------------------------------------------------------------------
    if exist(fullfile(path, timelineFile),'file')
        load([path timelineFile]);
    else
        % timeline file not found
        % -----------------------------------------------------------------
        
        % Ask user to select one or create one
        
        % Construct a questdlg with three options
        choice = questdlg(  'How do you want to proceed?', ...
                            'No Timeline File Found', ...
                            'Choose a file','Create new file', 'Quit',...
                            'Quit');
        
        % Handle response
        switch choice
            case 'Choose a file'
                [file, pathname] = uigetfile(fullfile(path, timelineFile),'Open a timeline file');
    
                if file
                    % User did not hit cancel
                    % grab the variable to save

                    load(fullfile(pathname, file));

                    if exist('timeline','var')
                        
                        savePath = pathname;
                        saveFile = file;

                        % We loaded a variable with the right name. Now, is it the
                        % right variable?

                        switch checkStructureType(timeline)
                            case 'timeline'
                                % We have a valid timeline structure.

                            otherwise
                                % We do not have a valid timeline structure.
                                % Do nothing to soft fail?
                                warning('Selected file did not contain a valid timeline file');
                                return
                        end

                        % We did not load a variable named timeline.
                        % Do nothing to soft fail

                    end

                else
                    % User hit cancel button
                    disp('User cancelled load');
                    return
                end
                
            case 'Create new file'
                timeline = newTimelineStructure;

            case 'Quit'
                return
        end

    end
    
    
%% Create new merged timeline variable with milestones
% -------------------------------------------------------------------------

    if numel(timeline.milestone)
        timeline.milestone = vertcat(timeline.milestone, milestones);
    else
        timeline.milestone = milestones;
    end

%% Save updated timeline file
% -------------------------------------------------------------------------


    
    if showSaveDialog
        
        % UI Save File Dialog
        % -----------------------------------------------------------------
        [filename, pathname, filterindex] = uiputfile( ...
            {'*.mat', 'MDRT Data Files (*.mat)';
             '*.*',  'All Files (*.*)'},...
             'Save as');
         
        % Handle user cancel case
        % -----------------------------------------------------------------
        if isequal(filename,0) || isequal(pathname,0)
            disp('User selected Cancel')
            return
        else
           disp(['User selected ',fullfile(pathname,filename)])
           savePath = pathname;
           saveFile = filename;
        end
        
    else
        % Nothing to do - gonna save automatically!
        
    end

    save(fullfile(savePath, saveFile), 'timeline');
    
    
