function h=ancestor(obj, type)
% ANCESTOR function overloaded as JCONTROL method
%
% Example:
% h=ancestor(obj, type)
% 
% returns the appropriate ancestor of the obj.hgcontainer
%
% See also builtin/ancestor
% 

h=ancestor(obj.hgcontainer, type);
return
end