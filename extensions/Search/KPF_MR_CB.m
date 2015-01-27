function KPF_MR_CB(obj,event,edit_h)
% a mouse release callback for a java edit box for KPF_CB
% 
% Description
%     This function is meant to work in connection with KPF_CB.  It records
%     where the user has clicked, or what they have selected upon mouse
%     button release.  It also checks if the user has highlighted any text
%     and compares that to what they have previously typed.

% Version : 1.0 (10/06/2011)
% Author  : Nate Jensen
% Created : 10/06/2011
% History :
%  - v1.0 (10/06/2011) : initial release

UserData = get(edit_h,'UserData');
if isempty(UserData)
    return
end

UserData.text = UserData.word;
text1 = clipboard('paste');
java_robot('key_ctrl',{'key_normal','c'})
text2 = clipboard('paste');
click = event.getClickCount();
if ~strcmp(text1,text2) || click > 1
    pause(1e-4)
    UserData.click = click;
    UserData.jrlsd = obj.getCaretPosition();
    UserData.jflag = 1;
    UserData.jtext = text2;
end
set(edit_h,'UserData',UserData)
end