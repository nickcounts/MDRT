function guessMaxSpike ( data )
% guessMaxSpike is a helper routine designed to operate on saved data brush
% data for estimating off-scale high spike maxima or off-scale low minima.
%
%   USE:
%   
%   On a plot with a spike that goes off scale high, select the entirety of
%   the spike and several points on either side with the data brish and
%   save to a variable.
%
%   run guessMaxSpike(data) and follow the command prompts
%



fig = figure();
plot(data(:,1),data(:,2));

disp ('Use the data cursor tool to mark the shoulders of the peak')

% keyboard
% 
% 
% cursorMode = datacursormode(fig);
% dataTips = cursorMode.DataCursors.get;


dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','on','Enable','on')

pause

c_info = getCursorInfo(dcm_obj);



pos(1,:) = c_info(1).Position;
pos(2,:) = c_info(2).Position;

dataIndex(1) = c_info(1).DataIndex;
dataIndex(2) = c_info(2).DataIndex;

% SORT THESE IN ASCENDING ORDER
if pos(1,1) > pos(2,1)
    pos(3,:) = pos(1,:);
    pos(1,:) = [];
    
    dataIndex(3) = dataIndex(1);
    dataIndex(1) = [];
end

upLine = data(dataIndex(1)-5:dataIndex(1),:);
dnLine = data(dataIndex(2):dataIndex(2)+5,:);

upSlope = upLine(:,2)\upLine(:,1);

x1 = upLine(1,1);
y1 = upLine(1,2);

x2 = upLine(end,1);
y2 = upLine(end,2);

x3 = dnLine(1,1);
y3 = dnLine(1,2);

x4 = dnLine(end,1);
y4 = dnLine(end,2);


peakTime = ...
det([det([x1 y1; x2 y2]) det([x1 1; x2 1]);
     det([x3 y3; x4 y4]) det([x3 1; x4 1])]) ...
     / ...
det([det([x1 1; x2 1])   det([y1 1; y2 1]);
     det([x3 1; x4 1])   det([y3 1; y4 1])]);

 
peakPeak = ...
det([det([x1 y1; x2 y2]) det([y1 1; y2 1]);
     det([x3 y3; x4 y4]) det([y3 1; y4 1])]) ...
     / ...
det([det([x1 1; x2 1])   det([y1 1; y2 1]);
     det([x3 1; x4 1])   det([y3 1; y4 1])]);
 
 


if pos(1,1) < peakTime < pos(2,1)
    disp(sprintf('Selected spike is bounded by %g at %s',peakPeak, datestr(peakTime, 'HH:MM:SS.FFF')));
else
    disp('Calculation failed. Peak outside selected boundaries')
end




end