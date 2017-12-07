function reviewEventLabelsToTop( figureHandle, varargin )
% reviewEventLabelsToTop restacks the event marker labels to ensure they
% are above the event vertical lines.
%
% Use:
%
%   reviewEventLabelsToTop( figureNumber )
%
%   reviewEventLabelsToTop( toolbar.PushTool, eventdata.ActionData )
%
%   Counts 2017 VCSFA


% Default the search to the graphics root
parentFigure = 0;

% uistack(h,stackopt)

switch nargin
    case 0
        % Assume we were passed a figure number/handle directly
        parentFigure = figureHandle;
        
    otherwise
        % Other things I want to do? Not sure right now

end
    
%     lines   = findall(parentFigure, 'Tag',  'vline');
    labels  = findall(parentFigure, 'Tag',  'vlinetext');
            
    for j = 1:length(labels)
        
        uistack(labels(j),'top');
        
    end
    
    debugout('Set all event label text to top of the visual stack');

end
