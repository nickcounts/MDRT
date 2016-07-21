
function updateMatchingFDList( dsl, event )
%
% dsl is a handle to the popup list containing the list of valid data set
% selections (the master list for the search box)
%
%

mdrt = getappdata(dsl.Parent);

    % get handle to the Operation Data Set Popup Lists
    hol1 = findobj(dsl.Parent.Children,'tag', 'opList1');
    hol2 = findobj(dsl.Parent.Children,'tag', 'opList2');
    


    ds1 = hol1.String{hol1.Value};
    ds2 = hol2.String{hol2.Value};
    
    ts = dsl.String{dsl.Value};
      
    switch find(ismember({ds1;ds2},ts), 1, 'first')
        case 1
            % Plot 1 Active. Even if both have the same selection
            setappdata(dsl.Parent,'targetOpFDList', findobj(dsl.Parent.Children,'tag', 'op1FDlist'));
            debugout('selected list 1')
        case 2
            % Plot 2 active
            setappdata(dsl.Parent,'targetOpFDList', findobj(dsl.Parent.Children,'tag', 'op2FDlist'));
            debugout('selected list 2')
    end
    


ind = strcmpi(ts, mdrt.dataSetNames);

if isempty( mdrt.dataIndex(ind).FDList )
    % There isn't anything in the list of FDs - which would be weird
    % Soft fail by populating the fdMasterList and matchingFDlist with
    % empty cell array of strings
    
    fdMasterList = {''};
    
else
    % There's something there, hooray!
    
    % build fdMasterList from dataIndex
    % What happens if there is more than one matching index!?
    % That shouldn't be possible, but maybe I should handle that case in
    % the future
    fdMasterList = mdrt.dataIndex(ind).FDList(:,1);
    
end

% hs.listSearchResults.String = dataIndex(1).FDList(:,1);

% Update appdata
    setappdata(dsl.Parent, 'fdMasterList', fdMasterList );
    
% Repopulate the matchingFDs by updating the searchbox results    
    updateSearchResults(dsl, []);
    
    
    
    
    
    
    
    
    
    
    