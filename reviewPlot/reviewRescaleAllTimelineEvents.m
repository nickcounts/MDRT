function reviewRescaleAllTimelineEvents( varargin )
% reviewRescaleAllTimelineEvents 
%
% TODO: Add documentation
%
% Counts 2016 VCSFA

    vscale = 0.95;


    lines = findall(0,'Tag','vline');
    labels = findall(0,'Tag','vlinetext');

    for i = 1:length(lines)
        YLim = get(get(lines(i), 'Parent'),'YLim');
        set(lines(i),'YData',YLim);

        pos = get(labels(i),'Position');
        pos(2) = min(YLim) + abs(diff(YLim))*vscale;
        set(labels(i),'Position',pos)

    end
    
    