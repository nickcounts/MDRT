function reviewRescaleAllTimelineEvents( varargin )
% reviewRescaleAllTimelineEvents 
%
% TODO: Add documentation
%
% Counts 2016 VCSFA

% Set default search location to the root graphics object
parentFigure = 0;

switch nargin
    case 1
        % passed a figure handle

        % test - is it actually a figure handle?

        % assign the root search handle
        parentFigure = varargin{1};
    
    case 2

        if strcmpi(class(varargin{2}), 'matlab.ui.eventdata.ActionData')
            % We were passed an ActionData object
            
            % Extract figure number
            parentFigure = varargin{2}.Source.Parent.Parent.Number;
        end
        
    otherwise
        % assume nothing was passed, or a malformed query
        % default to old behavior, which was to rescale ALL objects on ALL
        % figures
end


    vscale = 0.95;


    lines   = findall(parentFigure,'Tag','vline');
    labels  = findall(parentFigure,'Tag','vlinetext');

    for i = 1:length(lines)
        YLim = get(get(lines(i), 'Parent'),'YLim');
        set(lines(i),'YData',YLim);

        pos = get(labels(i),'Position');
        pos(2) = min(YLim) + abs(diff(YLim))*vscale;
        set(labels(i),'Position',pos)

    end
    
    