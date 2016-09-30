function delete(obj)
% DELETE method overloaded for the JCONTROL class
%
% DELETE acts on the hgcontainer of the target object. Call this on the
% parent JCONTROL to delete all its contents.
%
% Example:
% delete(obj)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

% Vector on input
if numel(obj)>1
    for k=1:numel(obj)
        % Recursive
        delete(obj(k));
    end
    return
end

% If we have a parent uipanel delete it - check still valid as may have
% been deleted already if shared by other jcontrols
if ~isempty(obj.uipanel) && ishandle(obj.uipanel)
    delete(obj.uipanel);
end
% Check the hgcontainer is still valid - may have been deleted with uipanel
% above or in previous call to delete with multiple jcontrols
if ishandle(obj.hgcontainer)
    delete(obj.hgcontainer);
end
return
end
