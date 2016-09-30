function flag=isappdata(obj, name)
% ISAPPDATA function oveloaded for the JCONTROL class
%
% Examples:
% flag=isappdata(obj)
% flag=isappdata(obj, FieldName);
%
% See also: JCONTROL, JCONTROL/GETAPPDATA, JCONTROL/GETAPPDATA
% JCONTROL/ISAPPDATA ISAPPDATA
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------
%
% Revisions
%   05.10.2010  Add output! Thanks Richard Voigt 

flag=isappdata(obj.hgcontrol, name);
return
end
