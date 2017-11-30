function listClickCallback(hListbox, eventData, varargin)
%fdListClickCallback
%
% listClickCallback( listboxHandle, ~, ~)
%
% Will move the double-clicked list item from a list tagged
% 'listSearchResults' to the any list whos handle is stored in appdata as
% 'targetList'
%
% Will delete an item from a list tagged 'op1FDlist' or 'op2FDlist' if
% double clicked.
%
% No single-click behavior as yet.
%
% Counts, VCSFA 2017

    lists = struct;
    lists.master = 'listSearchResults';
    lists.selected = {'selectedList'};
    
    % Load appdata from calling GUI
    mdrt = getappdata(hListbox.Parent);

    persistent lastTime
    
    ONE_SEC = 1/(60*60*24);
    
    if isempty(lastTime) || now-lastTime > 0.3*ONE_SEC
        lastTime = now;
        % process a single-click
        
    else
        % Process a double-click
        
        
        switch hListbox.Tag
            case {'selectedList'}
                
                % ---------------------------------------------------------
                % The user double clicked in the list of selected items. We
                % want to remove this item from the list.
                % ---------------------------------------------------------
                
                plotList = mdrt.selectedList;
                debugout('loaded selectedList fd list')
                
                i   = hListbox.Value;
                fdl = hListbox.String;
                
                % Basic deletion of list string
                if isempty(fdl)
                    fdl = {};
                    plotList = {};
                else
                    fdl(i) = [];
                    plotList(i,:) = [];
                end
                
                % If you delete at the end of a list, reset the selection
                if i > length(fdl)
                    hListbox.Value = length(fdl);
                elseif isempty(fdl)
                    % Handle empty list
                    debugout('plot fd list is empty')
                    hListbox.Value = 1;
                end
                
                hListbox.String = fdl;
                
                % update appdata
                setappdata(hListbox.Parent, 'selectedList', plotList);
                
            case {'listSearchResults'}
                
                % Function originated in the search results list

                % ---------------------------------------------------------
                % The user double clicked in the master list of items. We
                % want to add this item to the selected list.
                % ---------------------------------------------------------
                
                % Fix for weird bug where matlab sets listbox Value=[] when
                % clicking inside an empty listbox
                
                if isempty(mdrt.targetList.Value) || mdrt.targetList.Value == 0
                    mdrt.targetList.Value = 1;
                end
                
                % get the appdata with the target list contents
                    listData = mdrt.selectedList;

                % Get the contents of the target list
                % tfdl = cellstr(mdrt.targetList.String);
                
                if isempty(listData)
                    tfdl = {};
                else
                    tfdl = listData(:,1);
                end
                
                % Remove any blank cells left over from the initial list
                tfdl = tfdl(~cellfun('isempty',tfdl));

                % Get the selected FD String
                fds = cellstr(hListbox.String{ hListbox.Value });
                
                % Find match in masterFDList ?
                
                cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));
                fdIndex = cellfun(cellfind(fds),mdrt.fdMasterList(:,1));
                
                newListDataRow = mdrt.fdMasterList(fdIndex,:);
                

                % Add selected FD String to the target list
                mdrt.targetList.String = vertcat(tfdl, fds);
                
                % Add the newListDataRow to the appdata

                setappdata(hListbox.Parent, 'selectedList', vertcat(listData, newListDataRow));

                
            otherwise
                % Nothing else I can think of for now
        end
        
    end
    
end