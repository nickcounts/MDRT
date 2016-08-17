timeFrame = 1000; % samples or ms
plotsWide = 4;

%	Page setup for landscape US Letter
%         graphsInFigure = 1;
%         graphsPlotGap = 0.05;
        graphsPlotGap = 0.05;
%         GraphsPlotMargin = 0.06;
        GraphsPlotMargin = 0.06;
        
        legendFontSize = [8];


% Look for rises

rises = find(diff(a1)>1.5);
    start = rises(1) - 10;
    stop = rises(1) + 100;

falls = find(diff(a2)<-2.5);


for i = 1:length(rises)
    matches(:,i) = abs(rises(i)-falls);
end

% Original Line - not 100% sure I know what it's doing
fallIndexes = sum(matches<timeFrame,2)>0;


falls = falls(fallIndexes);

% falls(fallIndexes)

    
% Find matching switch pairs



range = start:stop;

% plot(t(range),a1(range))
% hold on
% plot(t(range),a2(range),'g')


% Loop through what I found

    numPlots = length(rises);
    plotRows = ceil(numPlots / plotsWide);
    
    orient('landscape');

    subPlotAxes = tight_subplot(plotRows,plotsWide,graphsPlotGap, ... 
                                    GraphsPlotMargin,GraphsPlotMargin);
    suptitle('MARS GN2 Performance Testing Flowdyne Valve Data');


for i = 1:numel(rises)
    start = rises(i) - 10;
    stop  = falls(i) + 10;

    msTurns = (t(falls(i))-t(rises(i)))*1000;
    
    range = start:-1:stop;
    
    axes(subPlotAxes(i));
    
        
    
        plot(t(range)-t(rises(i)) ,a1(range),'-b','DisplayName','Close Switch');
            hold on;
        plot(t(range)-t(rises(i)) ,a2(range),'-g','DisplayName','Close Switch');
        
        disp(sprintf('Transition time for cycle %i was %3.1f ms',i, msTurns));
        
        title(subPlotAxes(i),sprintf('Closing Cycle %i: %3.1f ms',i, msTurns));
        ylabel(subPlotAxes(i), 'Volts DC');
        xlabel(subPlotAxes(i), 'Seconds');
        
    % Display major and minor grids

                set(subPlotAxes(i),'XGrid','on','XMinorGrid','off','XMinorTick','on');
                set(subPlotAxes(i),'YGrid','on','YMinorGrid','off','YMinorTick','on');

    % Set time limits of subplot
%         timeLimits = [t(start) t(stop)]-t(rises(i));
%         set(subPlotAxes(i),'XLim',timeLimits);
%         
%         set(subPlotAxes(i), 'xTick', [-0.02: 0.010 : (timeFrame+20)/1000]);
        
    axis square;
    
    
    
end




% Look for falls

% find(diff(a1)>2.5)