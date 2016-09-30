function setappdata(obj, name, data)
% SETAPPDATA function overloaded for JCONTROL class
%
% SETAPPDATA places data in the application data area of the hgcontrol
% component of a JCONTROL
%
% Example:
% setappdata(obj, fieldname, data)
%
% See also: JCONTROL, JCONTROL/GETAPPDATA, JCONTROL/ISAPPDATA
% JCONTROL/RMAPPDATA 
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

% Revisions:
% 17.08.07  Check class of obj. This method gets called when data is a
%           jcontrol objectrather than obj

if strcmpi(class(obj),'jcontrol')
    setappdata(obj.hgcontrol, name, data);
else
    % Get here because data is a jcontrol object
    builtin('setappdata', obj, name, data)
end
return
end
