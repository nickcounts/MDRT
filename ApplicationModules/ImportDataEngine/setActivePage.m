function setActivePage(activePage, progressIndicators, pageContents)

if numel(progressIndicators) < activePage
    return
end

for i = 1:numel(progressIndicators)
    
    visibleValue = 'off';
    
    % Change page indicator
    % --------------------------------------------------------------------
    if activePage == i
        progressIndicators{i}.Value = 1;
        visibleValue = 'on';
    else
        progressIndicators{i}.Value = 0;
        visibleValue = 'off';
    end
    
    
    % Change page indicator
    % --------------------------------------------------------------------
    for n = 1:numel(pageContents{i});
        pageContents{i}{n}.Visible = visibleValue;
    end

end