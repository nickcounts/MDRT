 function varargout = plotGraphFromGUI(graph, timeline)
%% plotGraphFromGUI is a function for the MARS data tool GUI
% --> changes by Paige 8/1/16 -- changing secodn input from options structure to timeline structure
% --- > make sure am passing timeline 
% function varargout = plotGraphFromGUI(graph, options)
% function varargout = plotGraphFromGUI(graph, timeline)
%
%   takes a graph structure and an options structure
%
%   runs the MARS data plotting engine for the given graph structure with
%   the passed options structure. if options is left blank, uses default
%   values to be defined leter
%
% Counts, 10-7-14 - Spaceport Support Services

% Read in the plot info
% TODO: implement error checking?

% temporary hack for non-timeline plots
    useTimeline = true;
    
% temporary hack to handle giant data sets
    useReducePlot = false;
    
% Flag to supress warning dialogs
    supressWarningDialogs = false;


    
    
% Load the project configuration (paths to data, plots and raw data)
% -------------------------------------------------------------------------
% --> want to change to if timeline structure passed with path to data/timeline file, plot timeline. else if call
% --> getConfig to find timeline (check newTimelineStructure function for
% --> fields contained in Timeline Structure
    config = getConfig;

% Loads event data files. If missing, procedes with events disabled.
% -------------------------------------------------------------------------

% [pathstr,name,ext] = fileparts(datapath);

    if useTimeline
%         if isempty(pathstr)
        if exist(fullfile(config.dataFolderPath, 'timeline.mat'),'file')
            load(fullfile(config.dataFolderPath, 'timeline.mat'));
            disp('using timeline markers')
        else
            if ~supressWarningDialogs
                warndlg('Event data file "timeline.mat" was not found. Continuing with events disabled.');
            end
            useTimeline = false;
        end
%         end
    end


% -------------------------------------------------------------------------
% Constants Defined Here
% -------------------------------------------------------------------------

%	Page setup for landscape US Letter
        graphsInFigure = 1;
        graphsPlotGap = 0.05;
        GraphsPlotMargin = 0.06;
        
        legendFontSize = [8];
     
%	Plot colors and styles for auto-styling data streams
        colors = { [0 0 1], [0 .5 0], [.75 0 .75],...
                   [0 .75 .75], [.68 .46 0]};
        lineStyle = {'-','--',':'};
        isColorOverride = false;

%	Data path (*.mat)
%         dataPath = '/Users/nick/Documents/MATLAB/ORB-D1/Data Files/';
        dataPath = config.dataFolderPath;
        
        eventFile = 'events.mat';

% %   TODO: Implement start/stop time passing through getPlotParameters()
%         timeToPlot = struct('start',735495.296704555, ...
%                             'stop',735496.029342311);
%         t0 = datenum('September 18, 2013 14:58');

if useTimeline
    t0 = timeline.t0.time;
    debugout('Found t0 in timeline struct')
else
    % Should I do something here?
end



% Setup multi plot loop variables from plot parameters
numberOfGraphs = length(graph);


for graphNumber = 1:numberOfGraphs
% -------------------------------------------------------------------------
% Create a new graph
% -------------------------------------------------------------------------
    numberOfSubplots = length(graph(graphNumber).subplots);
    numberOfSubplots
    
% -------------------------------------------------------------------------
% Generate new figure and handle. Set up for priting
% -------------------------------------------------------------------------
    UserData.graph = graph;
    
    figureHandle(graphNumber) = makeMDRTPlotFigure(UserData.graph, graphNumber);
    
    subPlotAxes = MDRTSubplot(numberOfSubplots,1,graphsPlotGap, ... 
                                GraphsPlotMargin,GraphsPlotMargin);
                            
    
    % TODO: Insert code to parse graph title meta tags!
    %     graphName = parseGraphTitle(graph(graphNumber).name);                      
                            
    ST_h = suptitle(graph(graphNumber).name);

    
    % Reset axes label variables
    axesTypeCell = [];
    
    
    for subPlotNumber = 1:numberOfSubplots
        
        % Plot the actual data here
        toPlot = graph(graphNumber).streams(subPlotNumber).toPlot;
        
        % Load data sets to be plotted into array of structs
        % --> CHANGE TO CHECK FOR FULLFILE PATH <------------
        for i = 1:length(toPlot)
            s(i) = load([dataPath toPlot{i} '.mat'],'fd');
        end
        
        % Build the list of variable types for axes label generation
        for i = 1:length(s)
            axesTypeCell = [axesTypeCell, {s(i).fd.Type}];
        end

        % Preallocate plot handles
%         hDataPlot = gobjects(numberOfGraphs, max(size(toPlot)));
%         hDataPlot = gobjects(numberOfGraphs);
        
        
        % -----------------------------------------------------------------
        % Main plotting loop.
        % -----------------------------------------------------------------

        % Initialize style loop variables
            iStyle = 1;
            iColor = 1;
            lineWeight = 0.5;

            hold off;
            axes(subPlotAxes(subPlotNumber));
            
            for i = 1:length(toPlot)
                
                % Valve thing to do for the plot
                    if(any(strcmp('isValve',fieldnames(s(i).fd))))
                        
                        
                        debugout(subPlotAxes(subPlotNumber).HitTest)
                        
                        if(any(strcmp('isProportional',fieldnames(s(i).fd))))
                            % Default to plotting just the position right
                            % now. 
                            %TODO: Implement selective plotting for
                            %proportional valves
                            
                            
                            if useReducePlot
                                
                                hDataPlot(graphNumber,subPlotNumber,i) = reduce_plot(s(i).fd.position.Time, ...
                                                  s(i).fd.position.Data, ...
                                                  'displayname', ...
                                                  [s(i).fd.Type '-' s(i).fd.ID]);
                            else
                            
                                hDataPlot(graphNumber,subPlotNumber,i) = plot(s(i).fd.position.Time, ...
                                                      s(i).fd.position.Data, ...
                                                      'displayname', ...
                                                      [s(i).fd.Type '-' s(i).fd.ID]);
                            end
                            
                        else
                            
                            if useReducePlot
                                
                                hDataPlot(graphNumber,subPlotNumber,i) = stairs(s(i).fd.ts.Time, ...
                                                  s(i).fd.ts.Data, ...
                                                  'displayname', ...
                                                  [s(i).fd.Type '-' s(i).fd.ID]);
                                              
                            else

                                hDataPlot(graphNumber,subPlotNumber,i) = stairs(s(i).fd.ts.Time, ...
                                                      s(i).fd.ts.Data, ...
                                                      'displayname', ...
                                                      [s(i).fd.Type '-' s(i).fd.ID]);
                            end
                            
                        end
                    elseif(any(strcmp('isLimit',fieldnames(s(i).fd))))

                        hDataPlot(graphNumber,subPlotNumber,i) = stairs(s(i).fd.ts.Time, ...
                                              s(i).fd.ts.Data, ...
                                              'displayname', ...
                                              [s(i).fd.Type '-' s(i).fd.ID]);
                        isColorOverride = true;
                        overrideColor = [1 0 0];
                    else
                        
                        if useReducePlot
                            
                            hDataPlot(graphNumber,subPlotNumber,i) = reduce_plot(s(i).fd.ts, ...
                                            'displayname', ...
                                            [s(i).fd.Type '-' s(i).fd.ID]);
                                        
                        else
                                    
                            hDataPlot(graphNumber,subPlotNumber,i) = plot(s(i).fd.ts, ...
                                            'displayname', ...
                                            [s(i).fd.Type '-' s(i).fd.ID]);
                        end
                    end
                                
                % Apply the appropriate color
                if (isColorOverride)
                    set(hDataPlot(graphNumber,subPlotNumber,i),'Color',overrideColor);
                    isColorOverride = false;
                else
                    set(hDataPlot(graphNumber,subPlotNumber,i),'Color',colors{iColor})
                end
                set(hDataPlot(graphNumber,subPlotNumber,i),'LineStyle',lineStyle{iStyle});
                set(hDataPlot(graphNumber,subPlotNumber,i),'LineWidth',lineWeight);
                hold on;

                % Increment Styles as needed
                iColor = iColor + 1;
                if (iColor > length(colors))
                    iStyle = iStyle + 1;
                    iColor = 1;
                    if (iStyle > length(lineStyle))
                        iStyle = 1;
                        iColor = 1;
                    end
                    % Option to adjust line weight for d
                    switch lineStyle{iStyle}
                        case ':'
                            lineWeight = 0.5;
                        otherwise
                            lineWeight = 0.5;
                    end
                end
                
            end % Data stream plots
            
            
            % REMEMBER FOR LATER:
            % if(any(strcmp('isValve',fieldnames(fd))));disp('isValve!!!');end
            
            
            
            
            % -------------------------------------------------------------
            % Apply styling to the subplot.
            % -------------------------------------------------------------
                
                
                debugout(subPlotAxes(subPlotNumber).HitTest)    
            
                % Set subplot title and draw T:0
                    title(subPlotAxes(subPlotNumber),graph(graphNumber).subplots(subPlotNumber));
                    
                % Set(subPlotAxes(1), 'fontSize', [6]);
               
                % Plot sequencer events first, underneath data streams
                        % Plot time markers for major LFF events
                            % Loop through listed events
                            axes(subPlotAxes(subPlotNumber));

                            % Crappy workaround to still have timeline events
                            if useTimeline
                                reviewPlotAllTimelineEvents(config);
                            end


                % ylabel(subPlotAxes(subPlotNumber),'Temperature (^oF)')
                    ylabel(subPlotAxes(subPlotNumber), axesLabelStringFromSensorType(axesTypeCell));
                    
%                 % Plot T=0 on top of data    
%                     vline(datenum(2013,9,18,14,58,0),'r-','T-0 at 14:58 UTC',0.5)
           

                % Display major and minor grids

                    set(subPlotAxes(subPlotNumber),'XGrid','on','XMinorGrid','on','XMinorTick','on');
                    set(subPlotAxes(subPlotNumber),'YGrid','on','YMinorGrid','on','YMinorTick','on');

                % dynamicDateTicks
                    dynamicDateTicks(subPlotAxes, 'linked') 
                
                    
                    xLim = get(subPlotAxes(subPlotNumber), 'XLim');
%                     setDateAxes(subPlotAxes(subPlotNumber), 'XLim', [timeToPlot.start timeToPlot.stop]);
                     setDateAxes(subPlotAxes(subPlotNumber), 'XLim', xLim);
                    
                    
                % Override the data cursor text callback to show time stamp
                    dcmObj = datacursormode(gcf);
                    set(dcmObj,'UpdateFcn',@dateTipCallback,'Enable','on');
                    
                % Style the legend to use smaller font size
                    subPlotLegend(subPlotNumber) = legend(subPlotAxes(subPlotNumber), 'show');
                    set(subPlotLegend(subPlotNumber),'FontSize',legendFontSize);
                    
                % Reset any subplot specific loop variables
                    axesTypeCell = [];
                    clear s
                    
                    if subPlotNumber == numberOfSubplots
                        % on last subplot, so add date string
%                         tlabel('WhichAxes', 'last')
                        debugout('last tlabel call')
                        
                    else
%                         tlabel('Reference', 'none')
                        debugout('regular tlabel call')
                        
                    end
                    
    end % subplot loop
    
    
    % Link x axes?
        linkaxes(subPlotAxes(:),'x');
        
        
    % Automatic X axis scaling:
    % --------------------------------------------------------------------- 
        timeLimits = get(subPlotAxes(subPlotNumber),'XLim');
        
        if ~graph(graphNumber).time.isStartTimeAuto
            switch graph(graphNumber).time.isStartTimeUTC
                case true
                    % absolute timestamp
                    timeLimits(1) = graph(graphNumber).time.startTime.Time;
                case false
                    % T- timestamp
                    % Added if/end block to accomodate non-timeline plots
                    if useTimeline
                        timeLimits(1) = t0 + graph(graphNumber).time.startTime;
                    end
            end
        end
        
        if ~graph(graphNumber).time.isStopTimeAuto
            switch graph(graphNumber).time.isStopTimeUTC
                case true
                    % absolute timestamp
                    timeLimits(2) = graph(graphNumber).time.stopTime.Time;
                    disp('Using UTC time!!! Hooray')
                case false
                    % T- timestamp
                    % Added if/end block to accomodate non-timeline plots
                    if useTimeline
                        timeLimits(2) = t0 + graph(graphNumber).time.stopTime;
                    end
            end
        end
        
        % Add a buffer on each side of the x axis scaling
        bound = 0.04;
        delta = 0.04*(timeLimits(2)-timeLimits(1));
        timeLimits = [timeLimits(1)-delta, timeLimits(2)+delta];
        
        set(subPlotAxes(subPlotNumber),'XLim',timeLimits);
        
        if ~graph(graphNumber).time.isStartTimeAuto && ~graph(graphNumber).time.isStopTimeAuto
            reviewRescaleAllTimelineEvents(gcf);
        end

    % Fix paper orientation for saving
        orient(figureHandle(graphNumber), 'landscape');

    % Pause execution to allow user to adjust plot prior to saving?
    
    % Call a redraw to correct the grid bug
    refresh(figureHandle(graphNumber))
    
end % Graph Loop



