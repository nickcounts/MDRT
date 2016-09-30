function rmappdata(obj, name)
% RMAPPDATA function oveloaded for the JCONTROL class
%
% Examples:
% rmappdata(obj)
% rmappdata(obj, FieldName);
%
% See also: JCONTROL, JCONTROL/GETAPPDATA, JCONTROL/GETAPPDATA
% JCONTROL/ISAPPDATA RMAPPDATA
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

rmappdata(obj.hgcontrol, name);
return
end
