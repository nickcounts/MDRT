function useSelectedEvent( hobj, event )

hs = getappdata(gcf, 'hs');

timeString = hs.events.String{hs.events.Value};
cctDateStamp = timeString(1:24);
eventTime = makeMatlabTimeVector({cctDateStamp}, false, false);

fdString = hs.master.String{hs.master.Value};
fdHumanReadable = hs.infoString.String;

% Instantiate a default milestone struct
% -------------------------------------------------------------------------
    milestone = struct(     'String',       fdHumanReadable, ...
                            'FD',           fdString, ...
                            'Time',         eventTime);

                        
milestones = getappdata(gcf, 'milestones');

if numel(milestones)                        
    milestones = vertcat(milestones, milestone);
    
else
    milestones = milestone; 
end

                       

setappdata(gcf, 'milestones', milestones);
end

