function markerMath ( fig )
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


% dataIndex(1) = c_info(1).DataIndex;
% dataIndex(2) = c_info(2).DataIndex;

% SORT THESE IN ASCENDING ORDER
if pos(1,1) > pos(2,1)
    pos(3,:) = pos(1,:);
    pos(1,:) = [];
    
%     dataIndex(3) = dataIndex(1);
%     dataIndex(1) = [];
end

trendMath(pos);

% 
% if pos(1,1) < peakTime < pos(2,1)
%     disp(sprintf('Selected spike is bounded by %g at %s',peakPeak, datestr(peakTime, 'HH:MM:SS.FFF')));
% else
%     disp('Calculation failed. Peak outside selected boundaries')
% end
% 



end