function obj=subsasgn(obj, index, val)
% SUBSASGN method overloaded for JCONTROL class
%
% subsasgn provides access to JCONTROL properties via MATLAB's dot notation
% Examples:
% obj.Units='characters';
% obj.Enabled=1
% obj.hgcontainer.Opaque='on'
%
% obj may be an element of a JCONTROL vector e.g.
% obj(3).Units='pixels';
%
% See also: jcontrol
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 06/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------

% Note: Left-hand assignments are not needed with dot assignments
% because both the hgcontainer and the hgcontrol are passed by reference
% rather than by value.
% With () calls, left-hand assignments are needed when initializing an
% element. In these cases the caller workspace will contain a reference to
% the JCONTROL set up by subsasgn or passed to subsasgn by MATLAB in val.
% In all cases, changes here to JCONTROL properties affect the original
% JCONTROL contents, and all copies of them in all MATLAB workspaces.

% 22.01.09 Use try/catch sequence Line 68, isprop always returns zero for
%               hgcontrol (R2009aPR)

switch index(1).type
    case '.'
        switch lower(index(1).subs)
            case {'hgcontainer' 'hgcontrol' 'hghandle'}
                if length(index)==1 || strcmp(index(1).subs,'hghandle')
                    error('The %s property is not settable',index(1).subs);
                else
                    subsasgn(obj.(index(1).subs), index(2:end), val);
                end
            otherwise
                % obj.property/method where the property could be in hgcontainer
                % or hgcontrol. Find out which and invoke appropriate subsasgn
                if isprop(obj.hgcontainer, index(1).subs) &&...
                        isprop(obj.hgcontrol, index(1).subs)
                    if strcmpi(index(end).subs,'visible')
                        % Set Visible property in the container, MATLAB will
                        % update the hgcontrol
                        obj.hgcontainer.Visible=VisibleProperty(val);
                        return
                    else
                        error('Shared property name ''%s''\nYou must explicitly specify the target object',...
                            index(1).subs);
                    end
                end
                if isprop(obj.hgcontainer, index(1).subs)
                    % hgcontainer property
                    subsasgn(obj.hgcontainer, index, val);
                    if ~isempty(obj.uipanel) && ~isstruct(obj.uipanel)
                        switch lower(index(1).subs)
                            case 'units'
                                set(obj.uipanel, index(1).subs, val);
                            case 'position'
                                if numel(val)==4
                                    set(obj.uipanel, index(1).subs, val);
                                else
                                    temp=obj.hgcontainer.Position;
                                    temp(index(2).subs{1:end})=val(1:end);
                                    set(obj.uipanel, index(1).subs, temp);
                                end
                        end
                    end
                else% isprop(obj.hgcontrol, index(1).subs) || ismethod(obj.hgcontrol,index(1).subs)%22.01.09
                    % assume hgcontrol property or method
                    try
                        subsasgn(obj.hgcontrol, index, val);
                    catch %#ok<CTCH>
                        error('No such property or method');
                    end
                end
        end
    case '()'
        % obj is empty so initialize
        if isempty(obj)
            % Assign first element - avoids conversion to double errors
            % when initializing with subscripts
            obj=jcontrol();
            % Set the target element - need not already exist
            obj(index(1).subs{1})=val;
            return
        end
        
        if strcmp(class(val),'jcontrol')
            % Initializing or adding element to an array
            obj(index(1).subs{1})=val;
        else
            % Assigning field to pre-existing element
            if isvector(obj) && length(index(1).subs)==1 &&...
                    index(1).subs{1}<=length(obj)
                subsasgn(obj(index(1).subs{1}), index(2:end), val);
            elseif ~isvector(obj) || length(index(1).subs)>1
                error('Scalar or vector JCONTROL and index required on input');
            elseif index(1).subs{1}>length(obj)
                error('Index exceeds length of JCONTROL vector');
            end
        end
end
return
end

