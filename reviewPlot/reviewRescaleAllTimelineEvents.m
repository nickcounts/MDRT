function reviewRescaleAllTimelineEvents( varargin )
% reviewRescaleAllTimelineEvents 
%
% TODO: Add documentation
%
%   Major revision to toggle event label visibility based on parent figure
%   toolbar "show/hide" togglebutton state.
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
            
            c = varargin{1}.Parent.Children;
            
            for i = 1:numel(c)
                if strcmpi(c(i).Type,'uitoggletool')
                    calledFromButton = true;
                    expectedVisible  = c(i).State;
                    break
                else
                    calledFromButton = false;
                    expectedVisible = [];
                end
            end
            
            
            
        end
        
    otherwise
        % assume nothing was passed, or a malformed query
        % default to old behavior, which was to rescale ALL objects on ALL
        % figures
end


    vscale = 0.95;


    lines   = findall(parentFigure,'Tag','vline');
    labels  = findall(parentFigure,'Tag','vlinetext');
    
    labelsOnAxis = [];
    labelsOutsideAxis = [];
    

    for i = 1:length(lines)
        YLim = get(get(lines(i), 'Parent'),'YLim');
        XLim = lines(i).Parent.XLim;
        
        set(lines(i),'YData',YLim);

        pos = get(labels(i),'Position');
        pos(2) = min(YLim) + abs(diff(YLim))*vscale;
        set(labels(i),'Position',pos)
        

        % Build a list of labels that are inside and outside the x axis
        if isOutside(labels(i).Position(1), XLim(1), XLim(2) )
            labelsOutsideAxis = vertcat(labelsOutsideAxis, labels(i));
        else
            labelsOnAxis = vertcat(labelsOnAxis, labels(i));
        end
        
        % Toggle visibility using rules for each case:
        fixOffAxisLabelVisibility(labelsOutsideAxis);
        fixOnAxisLabelVisibility(labelsOnAxis);

    end
    
end

function state = getExpectedStateForLabel(label)
    
    state = [];
    
    tbut = findobj(label.Parent.Parent.Children, 'type','uitoggletool');
    state = tbut.State;

end



function fixOnAxisLabelVisibility(label)
    for i = 1:numel(label)
        
        % get expected label state based on toggle button
        state = getExpectedStateForLabel(label(i)); 
        
        % change labels inside the axis to their expected state
        label(i).Visible = state;

    end

end


function fixOffAxisLabelVisibility(label)
    for i = 1:numel(label)
        label(i).Visible = 'off';
    end

end




function r = isOutside(x, low,hi)
   % returns logical true if low < x < hi

   r = ~(x>low & x<hi);
   
end

function r = isWithin(x, low,hi)
   % returns logical true if low < x < hi

   r = x>low & x<hi;
   
end