fig = figure;

%	Page setup for landscape US Letter
%         graphsInFigure = 1;
%         graphsPlotGap = 0.05;
        graphsPlotGap = 0.05;
%         GraphsPlotMargin = 0.06;
        GraphsPlotMargin = 0.06;
        
        legendFontSize = [8];



window = 30000;
minimumTestDuration = 5000; % ms
minimumRateOfChange = -25; % units/div
timeBetweenTests = 30000; % ms
lowDataThreshold = 1000; % psi

%% Locate Vent Events

% % falls = find(diff(fd.ts.Data)<-350);
% falls = find(diff(fd.ts.Data)<-250)
% 
% % points = falls([1 3 5]);
% points = falls([1 3 6 10 14 18 21])

% Locate indecies that have a sharp downward trend
downIndex = find(diff(fd.ts.Data) < minimumRateOfChange);

keyboard;

% Filter out indecies corresponding to data values below a threshold
downIndex = downIndex(find(fd.ts.Data(downIndex)>lowDataThreshold));

keyboard;

% Filter out indecies that are farther than minimumTestDuration from a high
% value
downIndex = downIndex(fd.ts.Data(downIndex - minimumTestDuration)> lowDataThreshold);

keyboard

% Locate indecies that are more than 1 second apart
uniqueIndexes = find(diff(downIndex)>timeBetweenTests)

keyboard

% Test Starting Indexes
testStarts = downIndex(uniqueIndexes);
% Test Start Timestrings
% datestr(fd.ts.Time(downIndex(uniqueIndexes)), 'HH:MM:SS.FFF')




%% Set up multiplot

% Combine Subplots:
% Loop through what I found
    plotsWide = 5;
    numPlots = length(testStarts);
    
%     plotRows = ceil(numPlots / plotsWide);
    plotRows = 3;
    
    orient('landscape');

    subPlotAxes = MDRTSubplot(plotRows,plotsWide,graphsPlotGap, ... 
                                    GraphsPlotMargin,GraphsPlotMargin);
    suptitle('MARS HSS Performance Testing B Flowdyne Valve Data');




% % 
% % for i = 1:length(testStarts)
% %     fig(i) = figure;
% %     ph(i) = plot(fd.ts.Time(testStarts(i)-window:testStarts(i)+window),fd.ts.Data(testStarts(i)-window:testStarts(i)+window));
% %     plotStyle;
% %     dynamicDateTicks;
% % %     
% % % % dynamicDateTicks
% % % 
% % % % tlabel
% % % % xLim = get(subPlotAxes(subPlotNumber), 'XLim');
% % % %                     setDateAxes(subPlotAxes(subPlotNumber), 'XLim', [timeToPlot.start timeToPlot.stop]);
% % % % setDateAxes(subPlotAxes(subPlotNumber), 'XLim', xLim);
% % %   
% % %     
% % % 
% % keyboard
% % % 
% % end
% % 

%% Plot Through Found Locations:



for i = 1:length(testStarts)
%     start = rises(i) - 10;
%     stop  = falls(i) + 10;

%     msTurns = (t(falls(i))-t(rises(i)))*1000;
    
%     range = start:stop;
    
    axes(subPlotAxes(i));
    
        
    
        ph(i) = plot(fd.ts.Time(testStarts(i)-window:testStarts(i)+window),fd.ts.Data(testStarts(i)-window:testStarts(i)+window));
%             hold on;
%         plot(t(range)-t(rises(i)) ,a2(range),'-g','DisplayName','Close Switch');
        
%         disp(sprintf('Transition time for cycle %i was %3.1f ms',i, msTurns));
        
%         title(subPlotAxes(i),sprintf('Closing Cycle %i: %3.1f ms',i, msTurns));
        ylabel(subPlotAxes(i), 'STE Pressure (psig)');
        xlabel(subPlotAxes(i), 'Time (UTC)');
        
    % Display major and minor grids

                set(subPlotAxes(i),'XGrid','on','XMinorGrid','off','XMinorTick','on');
                set(subPlotAxes(i),'YGrid','on','YMinorGrid','off','YMinorTick','on');

    % Set time limits of subplot
%         timeLimits = [t(start) t(stop)]-t(rises(i));
%         set(subPlotAxes(i),'XLim',timeLimits);
%         
%         set(subPlotAxes(i), 'xTick', [-0.02: 0.010 : (timeFrame+20)/1000]);
%         
    axis square;
    
    dynamicDateTicks;
    
end