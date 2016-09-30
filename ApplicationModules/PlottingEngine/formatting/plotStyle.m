%% Sets Plot Style
%
% X and Y grids (major/minor)
% X and Y ticks (major/minor)
% 14 pt, Bold Title Text
%


% dynamicDateTicks

set(get(gcf,'CurrentAxes'),'XGrid','on');
set(get(gcf,'CurrentAxes'),'XMinorGrid','on');
set(get(gcf,'CurrentAxes'),'XMinorTick','on');
set(get(gcf,'CurrentAxes'),'YGrid','on');
set(get(gcf,'CurrentAxes'),'YMinorGrid','on');
set(get(gcf,'CurrentAxes'),'YMinorTick','on');

% set(get(get(gcf,'CurrentAxes'),'Title'),'FontWeight','bold');
set(get(get(gcf,'CurrentAxes'),'Title'),'FontSize',12);