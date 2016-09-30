function data=getappdata(obj, name)
% GETAPPDATA function overloaded for JCONTROL class
%
% GETAPPDATA returns data from the application data area of the hgcontrol
% component of a JCONTROL
%
% Example:
% data=gatappdata(obj)
% data=getappdata(obj, FieldName)
%
% See also: JCONTROL, JCONTROL/GETAPPDATA, JCONTROL/ISAPPDATA,
% JCONTROL/RMAPPDATA, GETAPPDATA
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

if nargin==1
    data=getappdata(obj.hgcontrol);
else
    data=getappdata(obj.hgcontrol, name);
end
return
end
