function markerDisp ( fig )
% markerMath is a helper routine intended to calculate the delta and time
% span between two data tips placed on a figure.
%
%   USE:
%   
%   On any plot, clear all data tips and place two data tips on the plot.
%
%   run markerMath(figNum) to calculate the linear rate of change, start
%   and stop time and elapsed time between markers
%
%   N. Counts 2015, Spaceport Support Services.



dcm_obj = datacursormode(fig);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','on','Enable','on')

c_info = getCursorInfo(dcm_obj);



pos(1,:) = c_info(1).Position;
pos(2,:) = c_info(2).Position;
pos(3,:) = c_info(3).Position;
% pos(4,:) = c_info(4).Position;

% dataIndex(1) = c_info(1).DataIndex;
% dataIndex(2) = c_info(2).DataIndex;

% SORT THESE IN ASCENDING ORDER

pos = sort(pos, 1, 'ascend');
elapse = datestr(pos(end,1)-pos(1,1),'HH:MM:SS.FFF');


% sprintf('TimeStamps:, %s, %s, %s, %s, , %s', ...
sprintf('TimeStamps:, %s, %s, %s, %s', ...
datestr(pos(1), 'HH:MM:SS.FFF'), ...
datestr(pos(2), 'HH:MM:SS.FFF'), ...
datestr(pos(3), 'HH:MM:SS.FFF'), ...
elapse)

% datestr(pos(4), 'HH:MM:SS.FFF'), ...

% 
% if pos(1,1) < peakTime < pos(2,1)
%     disp(sprintf('Selected spike is bounded by %g at %s',peakPeak, datestr(peakTime, 'HH:MM:SS.FFF')));
% else
%     disp('Calculation failed. Peak outside selected boundaries')
% end
% 



end