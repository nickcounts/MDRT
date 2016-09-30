function close(obj)
% Close methods overloaded for JCONTROL objects
%
% Simply calls delete. Included as JCONTROL objects can sometimes be used
% to replace figures/waitbars etc where existing code may call close instead
% of delete.
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007-
% -------------------------------------------------------------------------

delete(obj)
return
end