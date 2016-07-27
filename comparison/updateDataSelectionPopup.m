function updateDataSelectionPopup( pUp, ~ )
%updateDataSelectionPopup 
%
% pass handle of updateTarget, source 1 and source 2


hsource1 = findobj(pUp.Parent, 'Tag', 'opList1');
hsource2 = findobj(pUp.Parent, 'Tag', 'opList2');
htarget = findobj(pUp.Parent, 'Tag', 'selectDataList');


    % Get selection from top/bottom plot data set popup
    dataSetSelections = { hsource1.String{hsource1.Value}  ;
                          hsource2.String{hsource2.Value} };

    % Remove duplicate if both have been selected
    dataSetSelections = unique(dataSetSelections);
    if htarget.Value > numel(dataSetSelections)
        newValue  = 1;
    elseif htarget.Value == 1
        newValue = 1;
        debugout('The top string was selected')
    elseif htarget.Value == 2
        newValue = 2;
        debugout('The bottom string was selected')
    end

    htarget.Value = 1;
    htarget.String = dataSetSelections;
    htarget.Value = newValue;
    
    
    % update the contents of event popups on data set selection
    [el1, el2] = updateEventDropdowns(pUp);
    
    % update appdata to store eventTimes
    setappdata(pUp.Parent,'eventTimes1', el1);
    setappdata(pUp.Parent,'eventTimes2', el2);

end

