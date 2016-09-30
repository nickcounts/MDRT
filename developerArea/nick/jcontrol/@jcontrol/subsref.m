function ret=subsref(obj, index)
% SUBSREF method overloaded for jcontrol class
%
% subsref provides access to jcontrol properties via MATLAB's dot notation
% Examples:
% obj.hgcontainer
% obj.hgcontrol.Name
%
% subsref also provides access to the java component's methods
% Example:
% obj.setToolTipText('MyText');
% a=obj.getToolTipText();
%
% See also: jcontrol
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 07/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

% Revisions:
% 21.08.07    Methods now called properly when index(1).subs=='hgcontrol'.
%             Previously subsref(obj.hgcontrol,...) was called from here with
%             index(1:end) instead of index(2:end).
% 21.08.07    Tests nargout before calling hgcontrol methods. No output is
%             requested if nargout==0. This prevents "One or more output 
%             arguments not assigned..." errors being generated internally
%             e.g calling setXXXX calls. These errors will still be generated
%             (as they should)if an output is requested when none is
%             available. See 09.09.07 below.
% 09.09.07    Improve above fix with try/catch blocks. Now getXXXX calls
%             return in ans if nargout==0
% 20.09.07    Nest try/catch blocks to reduce isprop() and ismethod()
%             calls. This is substantially faster.
% 24.01.09    Remove isprop calls on hgcontrols - R2009aPR compatability
%             change
% 05.05.09    Add uipanel to case statement
% 01.03.10    Add User to case statement

switch index(1).type
    case '.'
        switch lower(index(1).subs)
            case 'hgcontainer'
                if length(index)==1
                    % obj.hgcontainer
                    ret=obj.hgcontainer;
                elseif isprop(obj.hgcontainer, index(2).subs)
                    % obj.hgcontainer.property
                    ret=subsref(obj.hgcontainer,index(2:end));
                elseif isempty(obj.hgcontainer)
                    % Empty default object?
                    ret=[];
                else
                    % Otherwise no property with this name
                    error('No appropriate property %s',index(2).subs);
                end
            case 'hgcontrol'
                if length(index)==1
                    % obj.hgcontrol
                    ret=obj.hgcontrol;
                else
                    try
                        ret=subsref(obj.hgcontrol, index(2:end));
                    catch %#ok<CTCH>
                        try
                            CheckErr();
                            subsref(obj.hgcontrol, index(2:end));
                        catch %#ok<CTCH>
                            if isempty(obj.hghandle)
                                % Maybe subsref failed because obj has
                                % empty properties
                                ret=[];
                            elseif ~isprop(obj.hghandle, index(2).subs) &&...
                                    ~ismethod(obj.hghandle, index(2).subs)
                                error('jcontrol:subsref: No such property or method');
                            else
                                error('jcontrol:subsref: Unexpected error');
                            end
                        end
                    end
                end
            case 'hghandle'
                ret=obj.hghandle;
            case 'uipanel'
                % Added 05.05.09
                if length(index)==1
                    ret=obj.uipanel;
                else
                    ret=subsref(obj.uipanel, index(2:end));
                end
            case 'user'
                % Added 01.03.10
                ret=obj.User;
            case 'super'
                ret=obj.super;
            otherwise
                % obj.property/method where the property could be in hgcontainer
                % or hgcontrol. Find out which and invoke subsref
                % recursively
                if isprop(obj.hgcontainer, index(1).subs) &&...
                        isfield(get(obj.hgcontrol), index(1).subs)
                    % 24.01.09 Change for R2009a from isprop(obj.hgcontrol, index(1).subs)
                    % Visible is an exception -  take this from the container, MATLAB
                    % links this property for the container and object
                    if strcmpi(index(1).subs,'visible')
                        ret=obj.hgcontainer.Visible;
                        return
                    else
                    error('Shared property name ''%s''\nYou must explicitly specify the target object',...
                        index(1).subs);
                    end
                end

                if isprop(obj.hgcontainer, index(1).subs)
                    % hgcontainer property
                    ret=subsref(obj.hgcontainer, index);
                else
                    % hgcontrol property or method?
                    try
                        ret=subsref(obj.hgcontrol, index);
                    catch %#ok<CTCH>
                        try
                            CheckErr();
                            subsref(obj.hgcontrol, index);
                        catch %#ok<CTCH>
                            if isempty(obj.hghandle)
                                % Maybe subsref failed because obj has
                                % empty properties
                                ret=[];
                            elseif ~(~isfield(get(obj.hgcontrol), index(1).subs) & ~ismethod(obj.hghandle, index(1).subs))%14.06.10
                                error('jcontrol:subsref: No such property or method');
                            else
                                rethrow(lasterror());
                            end
                        end
                    end
                end
        end
    case '()'
        % array of jcontrols
        if length(index)==1
            % One or more elements or a JCONTROL array/matrix wanted
            ret=obj(index(1).subs{:});
        else
            obj=obj(index(1).subs{:});
            if numel(obj)==1
                ret=subsref(obj, index(2:end));
            else
                error('Single element of ''%s'' must be specified', inputname(1));
            end
        end
end
return
end

%-------------------------------------------------------------------------
function CheckErr()
% CheckErr checks that the exception has been thrown for the expected
% reason - if not rethrow it.
err=lasterror();
if strcmp(err.identifier,'MATLAB:unassignedOutputs');
    return
else
    rethrow(err);
end
return
end
%-------------------------------------------------------------------------
