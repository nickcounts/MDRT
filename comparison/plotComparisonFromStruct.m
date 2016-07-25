function varargout = plotComparisonFromStruct(CG, options)
%% plotGraphFromGUI is a function for the MARS data tool GUI
%
%   takes a comparison graph structure and an options structure (not
%   implemented)
%
%   runs the MARS data plotting engine for the given graph structure with
%   the passed options structure. if options is left blank, uses default
%   values to be defined leter
%
% Counts, 10-7-14 - Spaceport Support Services
% Counts, 7-22-16 - VCSFA - Updated for comparison

% Read in the plot info
% TODO: implement error checking?

%% TEMPORARY HACK TO TEST STRUCTURES
% load('comparison/CG.mat');

subTitles(1) = {makeDataSetTitleStringFromActiveConfig(CG.topMetaData)};
subTitles(2) = {makeDataSetTitleStringFromActiveConfig(CG.botMetaData)};

timelines(1) = CG.topTimeline;
timelines(2) = CG.botTimeline;

timeShift(1) = 0;
timeShift(2) = CG.bottomTimeShift;

graph = struct;
graph.name = CG.Title;

% temporary hack for non-timeline plots
    useTimeline = true;
    
% temporary hack to handle giant data sets
    useReducePlot = true;
    
% Flag to supress warning dialogs
    supressWarningDialogs = false;


% Load the project configuration (paths to data, plots and raw data)
% -------------------------------------------------------------------------
    config = getConfig;

% Loads event data files. If missing, procedes with events disabled.
% -------------------------------------------------------------------------
%     if useTimeline
%         if exist(fullfile(config.dataFolderPath, 'timeline.mat'),'file')
%             load(fullfile(config.dataFolderPath, 'timeline.mat'));
%             disp('using timeline markers')
%         else
%             if ~supressWarningDialogs
%                 warndlg('Event data file "timeline.mat" was not found. Continuing with events disabled.');
%             end
%             useTimeline = false;
%         end
%     end


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



% Put filename/paths into streams struct array for plotting
    streams = struct;
    streams(1).toPlot = CG.topPlot;
    streams(2).toPlot = CG.botPlot;


% -------------------------------------------------------------------------
% Create a new graph
% -------------------------------------------------------------------------
    numberOfSubplots = 2;
    
% -------------------------------------------------------------------------
% Generate new figure and handle. Set up for priting
% -------------------------------------------------------------------------
    figureHandle = figure();
    
    saveButtonHandle = findall(figureHandle,'ToolTipString','Save Figure');
    
    set(saveButtonHandle, 'ClickedCallback', 'MARSsaveFigure');
    
    % Add label size toggle and timeline refresh buttons
    addToolButtonsToPlot(figureHandle);
    
    orient('landscape');
    
    subPlotAxes = tight_subplot(numberOfSubplots,1,graphsPlotGap, ... 
                                GraphsPlotMargin,GraphsPlotMargin);
                            
    
    % TODO: Insert code to parse graph title meta tags!
    %     graphName = parseGraphTitle(graph(graphNumber).name);                      
                            
    ST_h = suptitle(CG.Title);
    

    
    % Reset axes label variables
    axesTypeCell = [];
    
    
    for subPlotNumber = 1:numberOfSubplots
        
        % Plot the actual data here
        toPlot = streams(subPlotNumber).toPlot;
        
        % Load data sets to be plotted into array of structs
        for i = 1:length(toPlot)
            s(i) = load(toPlot{i});
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
                
                timeVect = s(i).fd.ts.Time + timeShift(subPlotNumber);
                
                % Valve thing to do for the plot
                    if(any(strcmp('isValve',fieldnames(s(i).fd))))
                        
                        if(any(strcmp('isProportional',fieldnames(s(i).fd))))
                            % Default to plotting just the position right
                            % now. 
                            %TODO: Implement selective plotting for
                            %proportional valves
                            
                            timeVect = s(i).fd.position.Time + timeShift(subPlotNumber);
                            
                            
                            if useReducePlot
                                
                                hDataPlot(subPlotNumber,i) = reduce_plot(timeVect, ...
                                                  s(i).fd.position.Data, ...
                                                  'displayname', ...
                                                  [s(i).fd.Type '-' s(i).fd.ID]);
                            else
                            
                                hDataPlot(subPlotNumber,i) = plot(timeVect, ...
                                                      s(i).fd.position.Data, ...
                                                      'displayname', ...
                                                      [s(i).fd.Type '-' s(i).fd.ID]);
                            end
                            
                        else
                            
                            if useReducePlot
                                
                                hDataPlot(subPlotNumber,i) = stairs(timeVect, ...
                                                  s(i).fd.ts.Data, ...
                                                  'displayname', ...
                                                  [s(i).fd.Type '-' s(i).fd.ID]);
                                              
                            else

                                hDataPlot(subPlotNumber,i) = stairs(timeVect, ...
                                                      s(i).fd.ts.Data, ...
                                                      'displayname', ...
                                                      [s(i).fd.Type '-' s(i).fd.ID]);
                            end
                            
                        end
                    elseif(any(strcmp('isLimit',fieldnames(s(i).fd))))

                        hDataPlot(subPlotNumber,i) = stairs(timeVect, ...
                                              s(i).fd.ts.Data, ...
                                              'displayname', ...
                                              [s(i).fd.Type '-' s(i).fd.ID]);
                        isColorOverride = true;
                        overrideColor = [1 0 0];
                    else
                        
                        if useReducePlot
                            
                            hDataPlot(subPlotNumber,i) = reduce_plot(timeVect,s(i).fd.ts.Data, ...
                                            'displayname', ...
                                            [s(i).fd.Type '-' s(i).fd.ID]);
                                        
                        else
                                    
                            hDataPlot(subPlotNumber,i) = plot(timeVect,s(i).fd.ts.Data, ...
                                            'displayname', ...
                                            [s(i).fd.Type '-' s(i).fd.ID]);
                        end
                    end
                                
                % Apply the appropriate color
                if (isColorOverride)
                    set(hDataPlot(subPlotNumber,i),'Color',overrideColor);
                    isColorOverride = false;
                else
                    set(hDataPlot(subPlotNumber,i),'Color',colors{iColor})
                end
                set(hDataPlot(subPlotNumber,i),'LineStyle',lineStyle{iStyle});
                set(hDataPlot(subPlotNumber,i),'LineWidth',lineWeight);
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
                
                
                    
%% Subplot Titles!!!!!!!            
                % Set subplot title and draw T:0
                    title(subPlotAxes(subPlotNumber), subTitles(subPlotNumber));
                    
                % Set(subPlotAxes(1), 'fontSize', [6]);
               
                % Plot sequencer events first, underneath data streams
                        % Plot time markers for major LFF events
                            % Loop through listed events
                            axes(subPlotAxes(subPlotNumber));

                            
                            % Commented out this bs...
%                             for i = 1:length(graph(graphNumber).events)
%                                 plotEvents(dataPath, eventFile, graph(graphNumber).events{i}, '-k');
%                             end

                            % Crappy workaround to still have timeline events
                            if useTimeline
                                reviewPlotAllTimelineEvents( timelines(subPlotNumber), timeShift(subPlotNumber) );
                            end


                % ylabel(subPlotAxes(subPlotNumber),'Temperature (^oF)')
                    ylabel(subPlotAxes(subPlotNumber), axesLabelStringFromSensorType(axesTypeCell));
                    
%                 % Plot T=0 on top of data    
%                     vline(datenum(2013,9,18,14,58,0),'r-','T-0 at 14:58 UTC',0.5)
           

                % Display major and minor grids

                    set(subPlotAxes(subPlotNumber),'XGrid','on','XMinorGrid','on','XMinorTick','on');
                    set(subPlotAxes(subPlotNumber),'YGrid','on','YMinorGrid','on','YMinorTick','on');

                % dynamicDateTicks
                    
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
                        tlabel('WhichAxes', 'last')
                        debugout('last tlabel call')
                        
                    else
                        tlabel('Reference', 'none')
                        debugout('regular tlabel call')
                        
                    end
                    
    end % subplot loop
    
    
    % Link x axes?
        linkaxes(subPlotAxes(:),'x');
        
    % Automatic X axis scaling:
    % --------------------------------------------------------------------- 
% %         timeLimits = get(subPlotAxes(subPlotNumber),'XLim');
% %         
% %         if ~graph(graphNumber).time.isStartTimeAuto
% %             switch graph(graphNumber).time.isStartTimeUTC
% %                 case true
% %                     % absolute timestamp
% %                     timeLimits(1) = graph(graphNumber).time.startTime;
% %                 case false
% %                     % T- timestamp
% %                     % Added if/end block to accomodate non-timeline plots
% %                     if useTimeline
% %                         timeLimits(1) = t0 + graph(graphNumber).time.startTime;
% %                     end
% %             end
% %         end
% %         
% %         if ~graph(graphNumber).time.isStopTimeAuto
% %             switch graph(graphNumber).time.isStopTimeUTC
% %                 case true
% %                     % absolute timestamp
% %                     timeLimits(2) = graph(graphNumber).time.stopTime;
% %                     disp('Using UTC time!!! Hooray')
% %                 case false
% %                     % T- timestamp
% %                     % Added if/end block to accomodate non-timeline plots
% %                     if useTimeline
% %                         timeLimits(2) = t0 + graph(graphNumber).time.stopTime;
% %                     end
% %             end
% %         end
% %         
% %         
% %         set(subPlotAxes(subPlotNumber),'XLim',timeLimits);


    % Fix paper orientation for saving
        orient(figureHandle, 'landscape');

    % Pause execution to allow user to adjust plot prior to saving?makeRe
    
    % Call a redraw to correct the grid bug
    refresh(figureHandle)
    




