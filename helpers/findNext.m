timeWindow = 0.75/24/60/60; % (1 second)

% % % % dcm_obj = datacursormode(fig);
% % % % set(dcm_obj,'DisplayStyle','datatip',...
% % % % 'SnapToDataVertex','on','Enable','on')
% % % % 
% % % % c_info = getCursorInfo(dcm_obj);
% % % % 
% % % % 
% % % % 
% % % % pos(1,:) = c_info(1).Position;
% % % % pos(2,:) = c_info(2).Position;
% % % % pos(3,:) = c_info(3).Position;
% % % % pos(4,:) = c_info(4).Position;
% % % % 
% % % % % dataIndex(1) = c_info(1).DataIndex;
% % % % % dataIndex(2) = c_info(2).DataIndex;
% % % % 
% % % % % SORT THESE IN ASCENDING ORDER
% % % % 
% % % % pos = sort(pos, 1, 'ascend');

mainChildren = get(groot, 'Children');
openFigures = findobj(mainChildren, 'type', 'figure');
for i = 1:length(openFigures)
    disp(sprintf('Figure %i', openFigures(i).Number));
end

disp(sprintf('\n'))
targetFigNum = input('Choose target figure number: ');
disp(sprintf('\n\n'))

    figureDetails = openFigures(targetFigNum).Children;
    figureAxes = findobj(openFigures(targetFigNum).Children, 'Type', 'Axes');


for i = 1:length(figureAxes)
    if isempty(figureAxes(i).Title.String)
        axisTitle = '';
    else
        axisTitle = figureAxes(i).Title.String{1};
    end
    
    disp(sprintf('Axis %i : %s', i, axisTitle));
end

disp(sprintf('\n'))
targetAxis = input('Choose the target axis number: ');
disp(sprintf('\n\n'))

axisContents = figureAxes(targetAxis).Children;

for i = 1:length(axisContents)
    dataName = axisContents(i).DisplayName;
    disp(sprintf('Axis %i : %s', i, dataName));
end

disp(sprintf('\n'))
targetData = input('Choose the target data stream number: ');
disp(sprintf('\n\n'))

% Pull data stream from plot for analysis:
Data = axisContents(targetData).YData;
Time = axisContents(targetData).XData;
Title = axisContents(targetData).DisplayName;


% Console output status:
disp(sprintf('\n'))
disp(sprintf('Searching %s data stream for events', Title))


% Look for rises in 8020 command
rises = find(diff(Data)>10);
rises = rises(Data(rises)> -10);


%     start = rises(1) - 10;
%     stop = rises(1) + 100;
    
falls = find(diff(Data)<-10);




target = figureAxes(targetAxis);



xrange = target.XLim;

timeWindow = 0.500/24/60/60; % (1 second)
timeDelta = timeWindow;
timePad = timeDelta * 0.1;





for i = 1:length(rises)
    
    % find time of suspected rise
    newTime = Time(rises(i));
    
    % set axes start to rise time
    newRange = [newTime, newTime + timeDelta] - timePad;
    
    % set(target, 'XLim', newRange);
    target.XLim = newRange;
    
    
    keyboard
    
    markerDisp(1)
    
end


for i = 1:length(falls)
    
    % find time of suspected rise
    newTime = Time(falls(i));
    
    % set axes start to rise time
    newRange = [newTime, newTime + timeDelta] - timePad;
    
    set(target, 'XLim', newRange);
    
    
    keyboard
    
    markerDisp(1)
    
end



