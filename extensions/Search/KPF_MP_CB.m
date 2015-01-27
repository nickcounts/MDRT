function KPF_MP_CB(obj,~,edit_h)
% a mouse press callback for a java edit box for KPF_CB
% 
% Description
%     This function is meant to work in connection with KPF_CB.  It records
%     where the user has clicked.

% Version : 1.0 (10/06/2011)
% Author  : Nate Jensen
% Created : 10/06/2011
% History :
%  - v1.0 (10/06/2011) : initial release

UserData = get(edit_h,'UserData');
if isempty(UserData)
    return
end
pause(1e-4)
UserData.jprsd = obj.getCaretPosition();
set(edit_h,'UserData',UserData)
end