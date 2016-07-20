function updateSearchResults(hEdit, eventData, varargin)
 
   mdrt = getappdata(hEdit.Parent);
   
   masterList = mdrt.fdMasterList;
%    sbs = mdrt.searchBoxString;

% 	java.lang.Thread.sleep(50)  % in mysec!
    
% if isequal(eventData.Key,'downarrow')
% 
%     import java.awt.Robot;
%     import java.awt.event.KeyEvent;
%     robot=Robot;
%     robot.keyPress(KeyEvent.VK_ENTER);
%     pause(0.01)
%     robot.keyRelease(KeyEvent.VK_ENTER);
%     disp(get(hEdit,'String'));
% end
   

% if strcmp(eventData.Key,'backspace')
%     sbs = sbs(1:end-1);
% elseif isempty(eventData.Character)
%     return
% else
%     sbs = [sbs eventData.Character];
% end
% 
% setappdata(hEdit.Parent, 'searchBoxString', sbs);



    lsr = findobj(hEdit.Parent.Children,'tag',          'listSearchResults');
    
    % Toggle focus to update edit box contents?
    uicontrol(lsr);
    uicontrol(hEdit);


    
    
    searchString = hEdit.String;
    
   
   ind = cellfun(@(x)( ~isempty(x) ), regexp(masterList, searchString));
   
   
   
   
   
   if length(searchString)
       
       % A non-empty search string means search!
       if length(masterList(ind)) >= lsr.Value
           % selected an item in the new list
           % lsr.Value = length(masterList(ind));
           lsr.String = masterList(ind);
       elseif ~length(masterList(ind))
           % New results are empty!
           lsr.Value = 0;
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