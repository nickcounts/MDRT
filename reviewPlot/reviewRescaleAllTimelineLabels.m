function reviewRescaleAllTimelineLabels( varargin )
% reviewRescaleAllTimelineLabels toggles event label text size for viewing
% or printing
%
% reviewRescaleAllTimelineLabels is a script that toggles all text labels
% and legend text between a screen viewable size and the correct size for
% printing to PDF.
%
% Counts, Spaceport Support Services 2014


%% Define working parameters

legendLargeFontSize = 14;
legendPrintFontSize = 8;

eventTextLargeFontSize = 12;
eventTextPrintFontSize = 6;

% Parent object for finding objects. 0 is the root object
parentObject = 0;


%% Find all event labels in parentObject

lines = findall(parentObject,'Tag','vline');
labels = findall(parentObject,'Tag','vlinetext');

for i = 1:length(lines)
    
    YLim = get(get(lines(i), 'Parent'),'YLim');
    set(lines(i),'YData',YLim);
    
    fntSz = get(labels(i),'FontSize');
    
    if fntSz == eventTextLargeFontSize
        fntSz = eventTextPrintFontSize;
    else
        fntSz = eventTextLargeFontSize;
    end
    
    set(labels(i),'FontSize',fntSz);

end



%% Find all legends in parentObject

legends = findall(parentObject,'Tag','legend');

for i = 1:length(legends)
    fntSz = get(legends(i), 'FontSize');
    
    if fntSz == legendLargeFontSize
        fntSz = legendPrintFontSize;
    else
        fntSz = legendLargeFontSize;
    end
    
    set(legends(i), 'FontSize', fntSz);
    
end


