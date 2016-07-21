function fdListClickCallback(hListbox, eventData, varargin)
%fdListClickCallback
%
% fdListClickCallback( listboxHandle, ~, ~)
%
% Will move the double-clicked list item from a list tagged
% 'listSearchResults' to the any list whos handle is stored in appdata as
% 'targetOpFDList'
%
% Will delete an item from a list tagged 'op1FDlist' or 'op2FDlist' if
% double clicked.
%
% No single-click behavior as yet.
%
% Counts, VCSFA 2016


    persistent lastTime
    
    ONE_SEC = 1/(60*60*24);
    
    if isempty(lastTime) || now-lastTime > 0.3*ONE_SEC
        lastTime = now;
        % process a single-click
        
    else
        % Process a double-click
        
        
        switch hListbox.Tag
            case {'op1FDlist', 'op2FDlist'}
                
                i = hListbox.Value;
                fdl = hListbox.String;
                
                % Basic deletion of list string
                if isempty(fdl)
                    fdl = {};
                else
                    fdl(i) = [];
                end
                
                % If you delete at the end of a list, reset the selection
                if i > length(fdl)
                    hListbox.Value = length(fdl);
                elseif isempty(fdl)
                    % Handle empty list
                    hListbox.Value = 1;
                end
                
                hListbox.String = fdl;
                
            case {'listSearchResults'}
                % Function originated in the search results list
                              
                mdrt = getappdata(hListbox.Parent);

                % Get the contents of the target list
                tfdl = cellstr(mdrt.targetOpFDList.String);

                % Remove any blank cells left over from the initial list
                tfdl = tfdl(~cellfun('isempty',tfdl));

                % Get the selected FD String
                fds = cellstr(hListbox.String{ hListbox.Value });

                % Find match in masterFDList ?

                % Add selected FD String to the target list
                mdrt.targetOpFDList.String = vertcat(tfdl, fds);
                
            otherwise
                % Nothing else I can think of for now
        end
        
    end
    
end