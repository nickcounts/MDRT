function fdListClickCallback(hListbox, eventData, varargin)
    persistent lastTime
    ONE_SEC = 1/(60*60*24);
    if isempty(lastTime) || now-lastTime > 0.3*ONE_SEC
        lastTime = now;
        % process the event (single-click)
        
    else
        % double-click
        
    end
end