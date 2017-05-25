% -------------------------------------------------------------------------
% Load all relevant data streams for later processing:
% -------------------------------------------------------------------------
% 
%     topData(1) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8020 Open.mat');
%     topData(2) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8020 Close.mat');
%     topData(3) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8020 Command.mat');
% 
%     midData(1) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8030 Open.mat');
%     midData(2) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8030 Close.mat');
%     midData(3) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ 8030 Command.mat');
% 
%     botData    = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/02-01-2016_HSS_Testing/data/MARDAQ STE PT.mat');

% Data from 1-28-16
% -------------------------------------------------------------------------
% 
%     topData(1) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8020 Open.mat');
%     
%     topData(1) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/8021.mat');
% 
%     topData(2) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8020 Close.mat');
%     topData(3) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8020 Command.mat');
% 
%     midData(1) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8030 Open.mat');
%     midData(2) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8030 Close.mat');
%     midData(3) = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ 8030 Command.mat');
% 
%     botData    = load('-mat','/Users/nickcounts/Documents/Spaceport/Data/Testing/01-28-2016_HSS_Testing/data/MARDAQ STE PT.mat');
%           



% Data from 8/8/16
% -------------------------------------------------------------------------
% 
% topData(1) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8020 Open.mat')
% topData(2) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8020 Close.mat')
% topData(3) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8020 Command.mat')
% 
% midData(1) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8030 Open.mat')
% midData(2) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8030 Close.mat')
% midData(3) = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/8030 Command.mat')
% 
% botData    = load('/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-08-06 - HSS Testing/2016-08-08 - HSS Testing ITR-1448 - Day 2/data/STE PT.mat')



% folderLocation = '/Users/nickcounts/Documents/Spaceport/Data/Testing/2016-09-20 - HSS Testing ITR-1448/data';


disp('Directions for use:');
disp('First select the folder containing MARDAQ HSS Data');
disp(' ');
disp('The script will search the 8030 valve for energize events.');
disp('Each found event will be plotted. After each plot, program execution');
disp('will pause to allow placing data cursors.');
disp(' ');
disp('When the plot and cursors are satisfactory, resume execution with the');
disp('resume command.');
disp(' ');
disp('The script will save the plot and move to the next event.');
disp(' ');

input('Press any key to continue')

disp(' ');
disp(' ');

pause



folderLocation = uigetdir;

% Quit if cancelled or invalid directory
if ~exist(folderLocation, 'dir')
    return
end

topData(1) = load(fullfile(folderLocation, 'MARDAQ 8020 Open.mat'));
topData(2) = load(fullfile(folderLocation, 'MARDAQ 8020 Close.mat'));
topData(3) = load(fullfile(folderLocation, 'MARDAQ 8020 Command.mat'));

midData(1) = load(fullfile(folderLocation, 'MARDAQ 8030 Open.mat'));
midData(2) = load(fullfile(folderLocation, 'MARDAQ 8030 Close.mat'));
midData(3) = load(fullfile(folderLocation, 'MARDAQ 8030 Command.mat'));

botData    = load(fullfile(folderLocation, 'MARDAQ STE PT.mat'));



%                                                 
% -------------------------------------------------------------------------
% Constants Defined Here
% -------------------------------------------------------------------------

titleString = 'HSS Testing';

fileID = fopen('timeStamps.txt','w');

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

dataWindow = 90000;        
        
% -------------------------------------------------------------------------
% Create a new graph
% -------------------------------------------------------------------------
    numberOfSubplots = 3;
    

% -------------------------------------------------------------------------
% STEP THROUGH INTERESTING STUFF
% -------------------------------------------------------------------------


% % Look for rises in 8030 command
    rises = find(diff(midData(3).fd.ts.Data)>10);
    rises = rises(midData(3).fd.ts.Data(rises)> -10);
    
    falls = find(diff(midData(3).fd.ts.Data)<-10);

% % Look for rises in STE PT command
%     rises = find(diff(botData.fd.ts.Data)>5);
%     rises = rises(botData.fd.ts.Data(rises)> -5);
%     
%     falls = find(diff(botData.fd.ts.Data)<-10);

% % Locate specific times    
% ps1 = find( abs(topData(1).fd.ts.Time - datenum('2-1-16 18:09:48')) < (1/24/60/60/500));
% ps2 = find( abs(topData(1).fd.ts.Time - datenum('2-1-16 18:25:57')) < (1/24/60/60/500));
% 

% % ps1 = find( abs(botData(1).fd.ts.Time - datenum('1-28-16 20:46:14.893933')) < (1/24/60));
% % ps2 = find( abs(botData(1).fd.ts.Time - datenum('1-28-16 20:54:36.980957')) < (1/24/60));
% % ps3 = find( abs(botData(1).fd.ts.Time - datenum('1-28-16 21:03:37.594080')) < (1/24/60));
% % 
% % 
% % rises = [ps1(1); ps2(1); ps3(1)];

timeWindow = 90/24/60/60; % (5 seconds)
% timeWindow = 0.500/24/60/60; % (0.5 second)
timeDelta = timeWindow;
timePad = timeDelta * 0.1;


for i = 1:length(rises)
    
% -------------------------------------------------------------------------
% Generate new figure and handle. Set up for priting
% -------------------------------------------------------------------------
    figureHandle(i) = figure();
    
    saveButtonHandle = findall(figureHandle(i),'ToolTipString','Save Figure');
    
    set(saveButtonHandle, 'ClickedCallback', 'MARSsaveFigure');
    
    orient('landscape');
    
    subPlotAxes = MDRTSubplot(3,1,graphsPlotGap, ... 
                                GraphsPlotMargin,GraphsPlotMargin);
                            
        topAxis = get(subPlotAxes(1));
        midAxis = get(subPlotAxes(2));
        botAxis = get(subPlotAxes(3));
        
        
	titleDateString = datestr(botData.fd.ts.Time(rises(i)), 'mmm dd yyyy');
    titleNameString = sprintf('%s %s', titleString, titleDateString);
    
                            
    ST_h = suptitle(titleNameString);
    
    % Reset axes label variables
    axesTypeCell = [];
    
    
        % -----------------------------------------------------------------
        % Pick interesting data indices
        % -----------------------------------------------------------------

    
   
        
        % -----------------------------------------------------------------
        % Main plotting loop.
        % -----------------------------------------------------------------

        % Initialize style loop variables
            iStyle = 1;
            iColor = 1;
            lineWeight = 0.5;
            
        % Initialize each plot stream
        
            hold on;
            
            axes(subPlotAxes(1))
            topAxisLine(1) = plot(topData(1).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , topData(1).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8020 Open Switch');
%             topAxisLine(1) = plot(topData(1).fd.ts.Time, topData(1).fd.ts.Data, 'displayname', '8021 State');
            topAxisLine(1).Color = 'b';
            
            hold on;

            axes(subPlotAxes(1))
            topAxisLine(2) = plot(topData(2).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , topData(2).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8020 Close Switch');
            topAxisLine(2).Color = 'g';

            hold on;
            
            axes(subPlotAxes(1))
            topAxisLine(3) = plot(topData(3).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , topData(3).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8020 Control');
            topAxisLine(3).Color = 'm';
            
            % Style subplot 1 Axis
            legend(subPlotAxes(1), 'show');
            % -------------------------------------------------------------
            % CHANGED TITLE!!!!!!
            % -------------------------------------------------------------
            topAxisTitle = title(subPlotAxes(1), 'DCVNO-8020');
            hold on;
            plotStyle;
            dynamicDateTicks
%             datetick('x', 'HH:MM:SS.FFF')
            % -------------------------------------------------------------
            % CHANGED LIMITS!!!!!!
            % -------------------------------------------------------------
            set(subPlotAxes(1), 'YLim', [-5, 30]);
%             set(subPlotAxes(1), 'YLim', [-1, 3]);
            set(subPlotAxes(1), 'YTickLabelMode', 'auto');

            axes(subPlotAxes(2))
            
            midAxisLine(1) = plot(midData(1).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , midData(1).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8030 Open Switch');
            midAxisLine(1).Color = 'b';
            

            hold on;
            
            axes(subPlotAxes(2));
            midAxisLine(2) = plot(midData(2).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , midData(2).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8030 Close Switch');
            midAxisLine(2).Color = 'g';

            hold on;
            
            axes(subPlotAxes(2));
            midAxisLine(3) = plot(midData(3).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , midData(3).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', '8030 Control');
            midAxisLine(3).Color = 'm';

            
            % Style subplot 2 axis
            legend(subPlotAxes(2), 'show');
            midAxisTitle = title(subPlotAxes(2), 'DCVNC-8030');
            plotStyle;
            dynamicDateTicks
            set(subPlotAxes(2), 'YLim', [-5, 30]);
            set(subPlotAxes(2), 'YTickLabelMode', 'auto');
            
            
            % Axis 3
            % ------------------------------------------------------------
            axes(subPlotAxes(3));
            botAxisLine    = plot(botData(1).fd.ts.Time(rises(i)-dataWindow:rises(i)+dataWindow) , botData(1).fd.ts.Data(rises(i)-dataWindow:rises(i)+dataWindow), 'displayname', 'HSS STE PT');
            botAxisLine.Color = 'b';
            
            % Style subplot 3 axis
            legend(subPlotAxes(3), 'show');
            botAxisTitle = title(subPlotAxes(3), 'HSS STE Pressure');
            plotStyle;
            dynamicDateTicks
%             datetick('x', 'HH:MM:SS.FFF')
                set(subPlotAxes(3),'YLim', [-50, 3200]);
                set(subPlotAxes(3), 'YTickLabelMode', 'auto');
            
        % Link x axes
%             dynamicDateTicks(subPlotAxes(1:3), 'link', 'HH:MM:SS.FFF')
            linkaxes(subPlotAxes(:),'x');
            dynamicDateTicks
%             tlabel(subPlotAxes(3), 'HH:MM:SS.FFF', 'WhichAxes', 'Last');
            
            
            newTime = midData(3).fd.ts.Time(rises(i));
            newRange = [newTime, newTime + timeDelta] - timePad;
    
        % set(target, 'XLim', newRange);
            set(subPlotAxes(1), 'XLim', newRange);
            
        dcmObj = datacursormode(gcf);
                set(dcmObj,'UpdateFcn',@dateTipCallback,'Enable','on');

%             
%     hDataPlot(graphNumber,subPlotNumber,i) = stairs(s(i).fd.ts.Time, ...
%                                                     s(i).fd.ts.Data, ...
%                                                     displayname', ...
%                                                     [s(i).fd.Type '-' s(i).fd.ID]);
%                                                 
%                                                 
                                                


keyboard




%  Dump cursor data to a file
    dcm_obj = datacursormode(figureHandle(i));
    cursors = getCursorInfo(dcm_obj);

    datestr(cursors(1).Position(1),'HH:MM:SS.FFF');


    fprintf(fileID, 'Data from Run %i\n', i);

    for j = 1:length(cursors)
        fprintf(fileID,'%s\t%f\n',datestr(cursors(j).Position(1),'HH:MM:SS.FFF'), cursors(j).Position(2));
    end

    fprintf(fileID, '\n\n');

% Save plot

    path = '~/Desktop';
    figureName = sprintf('HSS Test Run %i', i)
    saveas(figureHandle(i), fullfile(path, figureName), 'pdf')



    
end



fclose(fileID);


% -------------------------------------------------------------------------                                         
% Initial data population
% -------------------------------------------------------------------------
%     topAxisLine(1).XData = topData(1).fd.ts.Time(1:1000);
%     topAxisLine(1).YData = topData(1).fd.ts.Data(1:1000);
%     
%     topAxisLine(2).XData = topData(2).fd.ts.Time(1:1000);
%     topAxisLine(2).YData = topData(1).fd.ts.Data(1:1000);
%     
%     topAxisLine(3).XData = topData(3).fd.ts.Time(1:1000);
%     topAxisLine(3).YData = topData(1).fd.ts.Data(1:1000);
%     
%     
%     midAxisLine(1).XData = midData(1).fd.ts.Time(1:1000);
%     midAxisLine(1).YData = midData(1).fd.ts.Data(1:1000);
%     
%     midAxisLine(2).XData = midData(2).fd.ts.Time(1:1000);
%     midAxisLine(2).YData = midData(1).fd.ts.Data(1:1000);
%     
%     midAxisLine(3).XData = midData(3).fd.ts.Time(1:1000);
%     midAxisLine(3).YData = midData(1).fd.ts.Data(1:1000);
%     
%     botAxisLine.XData =    botData.fd.ts.Time(1:1000);
%     botAxisLine.YData =    botData.fd.ts.Data(1:1000);
%     
    
    
    
    
