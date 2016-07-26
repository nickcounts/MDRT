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
                
                switch(hListbox.Tag)
                    case 'op1FDlist'
                        debugout('loaded topPlot fd list')
                        plotList = getappdata(hListbox.Parent, 'topPlot');
                    case 'op2FDlist'
                        debugout('loaded botPlot fd list')
                        plotList = getappdata(hListbox.Parent, 'botPlot');
                end
                            
                    
                
                i = hListbox.Value;
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
                switch(hListbox.Tag)
                    case 'op1FDlist'
                        setappdata(hListbox.Parent, 'topPlot', plotList);
                    case 'op2FDlist'
                        setappdata(hListbox.Parent, 'botPlot', plotList);
                end
                
            case {'listSearchResults'}
                % Function originated in the search results list
                              
                mdrt = getappdata(hListbox.Parent);
                
                % Fix for weird bug where matlab sets listbox Value=[] when
                % clicking inside an empty listbox
                if isempty(mdrt.targetOpFDList.Value) || mdrt.targetOpFDList.Value == 0
                    mdrt.targetOpFDList.Value = 1;
                end
                
                % get the appdata with the target list contents
                switch mdrt.targetOpFDList.Tag
                    case 'op1FDlist'
                        listData = mdrt.topPlot;
                    case 'op2FDlist'
                        listData = mdrt.botPlot;
                    otherwise
                        
                end
                
                

                % Get the contents of the target list
%                 tfdl = cellstr(mdrt.targetOpFDList.String);
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
                mdrt.targetOpFDList.String = vertcat(tfdl, fds);
                
                % Add the newListDataRow to the appdata
                switch mdrt.targetOpFDList.Tag
                    case 'op1FDlist'
                        setappdata(hListbox.Parent, 'topPlot', vertcat(listData, newListDataRow));
                    case 'op2FDlist'
                        setappdata(hListbox.Parent, 'botPlot', vertcat(listData, newListDataRow));
                    otherwise
                        
                end
                
            otherwise
                % Nothing else I can think of for now
        end
        
    end
    
end