function updateDataSelectionPopup( ~, ~, htarget, hsource1, hsource2 )
%updateDataSelectionPopup 
%
% pass handle of updateTarget, source 1 and source 2

    % Get selection from top/bottom plot data set popup
    dataSetSelections = { hsource1.String{hsource1.Value}  ;
                          hsource2.String{hsource2.Value} };

    % Remove duplicate if both have been selected
    dataSetSelections = unique(dataSetSelections);
    if htarget.Value > numel(dataSetSelections)
        htarget.Value  = 1;
    end

    htarget.String = dataSetSelections;

end

