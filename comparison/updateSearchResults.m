function updateSearchResults(hEdit, eventData, varargin)
 
    mdrt = getappdata(hEdit.Parent);

    masterList = mdrt.fdMasterList;


    lsr = findobj(hEdit.Parent.Children,'tag',          'listSearchResults');
    

    % Access the Java object to get the stupid text. Why, Matlab? Why?
    ebh = findjobj(hEdit);
    searchString =  char(ebh.getText);    
    
    % TODO: Modify search to allow multiple search tokens in any order.
    % Break abart using whitespace and assemble indeces for each token?
   
        searchToks = strsplit(searchString);

        % searchToks = {'RP1';'Tur'};

        % remove stray whitespace
        searchToks = strtrim(searchToks);
        searchToks(strcmp('',searchToks)) = [];

        % start with empty match index variable
        ind = [];

        % create an index of matches for each token
        for i = 1:numel(searchToks)

            ind = [ind, cellfun(@(x)( ~isempty(x) ), regexpi(masterList, searchToks{i}))];

        end

        % combine matches (and searching, not or)
        ind = boolean(prod(ind,2));

 
    
   length(searchString)
   
   if length(searchString)
       
       % A non-empty search string means search!
       if length(masterList(ind)) >= lsr.Value
           % selected an item in the new list
           % lsr.Value = length(masterList(ind));
           % lsr.String = masterList(ind);
       elseif ~length(masterList(ind))
           % New results are empty!
           lsr.Value = 1;
       else
           % Selection is outside new (nonzero)result list
           lsr.Value = length(masterList(ind));
       end
       
           lsr.String = masterList(ind);
   else
       % No search string means return everything
       lsr.String = masterList;
   end
   
end