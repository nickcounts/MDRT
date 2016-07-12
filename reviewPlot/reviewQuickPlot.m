function [ figureHandle ] = reviewQuickPlot( fdFileName, config, varargin )
% reviewQuickPlot( fdFileName, config )
%
%   Designed to be called by the Data Review Tool helper GUI,
%   reviewQuickPlot takes a data filename and the config structure as
%   arguments and returns the handle to a figure plotted in US Letter,
%   Landscape and appropriately styled for printing to PDF or another
%   format.
%
%   Counts 2014, Spaceport Support Services
%   Counts 2016, VCSFA - Updated


    % SET PLOT STYLE INFO FOR SAVING TO PDF
    
    %	Page setup for landscape US Letter
        graphsInFigure = 1;
        graphsPlotGap = 0.05;
        GraphsPlotMargin = 0.06;
        
        % For quickplot, only 1 subplot
        numberOfSubplots = 1;
    
    figureHandle = figure();
    set(figureHandle,'Tag','quickPlot');
    
    % Add label size toggle and timeline refresh buttons
    addToolButtonsToPlot(figureHandle);
    
   
    
    
    
    % Fix orientation for printing and .pdf generation
    orient('landscape');
    subPlotAxes = tight_subplot(numberOfSubplots,1,graphsPlotGap, ... 
                                GraphsPlotMargin,GraphsPlotMargin);

    % Set plotting axes!!
	axes(subPlotAxes);


    dataPath = config.dataFolderPath;

    % load(['/Users/nick/Documents/MATLAB/ORB-D1/Data Files/' fdName '.mat']);
    load([dataPath fdFileName],'-mat');

    
switch upper(fd.Type)
    case {'DCVNC','DCVNO','PCVNC','PCVNO','RV','BV','FV'}   

        if isfield(fd,'position')
            % Check for proportional valve special case
            h_plot = plot(fd.position); 
        else
            % No special case, use normal .ts plot
            h_plot = stairs(fd.ts.Time, fd.ts.Data*1);
        end
    
    otherwise
        h_plot = plot(fd.ts);
end

    

    h_zoom = zoom(figureHandle);
    
    
    
%     set(h_zoom,'Motion','horizontal','Enable','on');
%     set(h_zoom,'ActionPostCallback',@mypostcallback);
%     set(h_zoom,'ActionPreCallback',@myprecallback);
    
   
    h_zoom.ActionPreCallback = @myprecallback;
    h_zoom.ActionPostCallback = @mypostcallback;
    
    h_zoom.motion = 'horizontal';
    h_zoom.enable = 'on';
    
%     set(h_zoom,'Enable','on');
    


    % set(pan(ax), 'ActionPostCallback',@(x,y) reviewRedrawOnGraphLimitChange(ax));

    dynamicDateTicks;
    plotStyle; 
    
    % Point the datatip cursor callback function to my function
    dcm_obj = datacursormode(figureHandle);
    set(dcm_obj, 'UpdateFcn', @dataTipDateCallbackDecimal);


    if nargin == 2
        % nothing to do if no events passed
    else
        % an events structure was passed. Default to displaying only t0
        % Plot T=0 on top of data
        timeline = varargin{1};



        t0time = timeline.t0.time;
        if timeline.t0.utc
            timezone = ' eastern';
        else
            timezone = ' UTC';
        end

        % Manual plotting of t0 in red...
        t0string = [timeline.t0.name, ': ', datestr(timeline.t0.time,'HH:MM.SS'), timezone];
        vline(timeline.t0.time,'r-',t0string,0.5)

        % Cheat and plot everything the quick and dirty way
        reviewPlotAllTimelineEvents(config);




    end
    

function mypostcallback(varargin)

disp('A zoom is Just to occurred.');
newLim = get(evd.Axes,'XLim');
msgbox(sprintf('The new X-Limits are [%.2f %.2f].',newLim));


% function myprecallback(obj,evd)
% %% reviewRedrawOnGraphLimitChange(obj,evd)
% %
% %   custom callback function to execute when plot is resized or panned
% %
% 
% newLim = get(evd.Axes, 'XLim');
% 
% disp(newLim)
% disp('Actually inside my callback!')
% 
% reviewRescaleAllTimelineEvents;






function myprecallback(obj,evd)
disp('A zoom is about to occur.');

