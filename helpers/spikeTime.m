% disp(sprintf('%s\t%s',datestr(q(1).Position(1),'mm/dd/yy HH:MM:SS.FFF'),...
%     datestr(abs(q(2).Position(1)-q(1).Position(1)),'SS.FFF') ))


% HACK IN TARGET FIGURE
figNum = 1;

% HACK IN TARGET DATA
data = overMawp;

% HACK IN NUMBER OF POINTS FOR INTERPOLATION
pts = 1;


% GET DATA CURSOR INFO
dcm_obj = datacursormode(figNum);
c_info = getCursorInfo(dcm_obj);

pos(1,:) = c_info(1).Position;
pos(2,:) = c_info(2).Position;

dataIndex(1) = c_info(1).DataIndex;
dataIndex(2) = c_info(2).DataIndex;

% SORT DATA CURSOR IN ASCENDING ORDER
if pos(1,1) > pos(2,1)
    pos(3,:) = pos(1,:);
    pos(1,:) = [];
    
    dataIndex(3) = dataIndex(1);
    dataIndex(1) = [];
end

% ASSIGN LINE SEGMENT DATA
upLine = data(dataIndex(1):dataIndex(1)+pts,:);
dnLine = data(dataIndex(2):-1:dataIndex(2)-pts,:);

% ASSIGN POINTS
x1 = upLine(1,1);
y1 = upLine(1,2);

x2 = upLine(end,1);
y2 = upLine(end,2);

x3 = dnLine(1,1);
y3 = dnLine(1,2);

x4 = dnLine(end,1);
y4 = dnLine(end,2);



% CALCULATE PEAK HEIGHT
peakPeak = ...
det([det([x1 y1; x2 y2]) det([y1 1; y2 1]);
     det([x3 y3; x4 y4]) det([y3 1; y4 1])]) ...
     / ...
det([det([x1 1; x2 1])   det([y1 1; y2 1]);
     det([x3 1; x4 1])   det([y3 1; y4 1])]);

% CALCULATE PEAK TIME
peakTime = ...
det([det([x1 y1; x2 y2]) det([x1 1; x2 1]);
     det([x3 y3; x4 y4]) det([x3 1; x4 1])]) ...
     / ...
det([det([x1 1; x2 1])   det([y1 1; y2 1]);
     det([x3 1; x4 1])   det([y3 1; y4 1])]);


if pos(1,1) < peakTime < pos(2,1)
    disp(sprintf('Selected spike is bounded by %g at %s',peakPeak, datestr(peakTime, 'HH:MM:SS.FFF')));
else
    disp('DANGER, WILL ROBINSON! Calculation failed. Peak outside selected boundaries')
end



% DISPLAY INFO
disp(sprintf('%s\t%s\t%g',datestr(pos(1,1),'mm/dd/yy HH:MM:SS.FFF'),...
    datestr(abs(pos(2,1)-pos(1,1)),'SS.FFF'), ...
    peakPeak ))