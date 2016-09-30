function val=VisibleProperty(val)
% VisibleProperty - helper function for JCONTROL methods
%
% Converts numeric inputs to string for visibility property.
%
% Example:
% val=VisibleProperty(val)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

switch val
    case 0
        val='off';
    case 1
        val='on';
    %otherwise
        % return unchanged
end
return
end