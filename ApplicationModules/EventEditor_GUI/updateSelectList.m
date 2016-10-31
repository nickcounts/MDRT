function updateSelectList(hobj, event)

t = getappdata(hobj.Parent, 't');
c1 = getappdata(hobj.Parent, 'c1');
c2 = getappdata(hobj.Parent, 'c2');
uc1 = getappdata(hobj.Parent, 'uc1');
uc2 = getappdata(hobj.Parent, 'uc2');


% keyboard

searchToks = uc1(hobj.Value)

ind = cellfun(@(x)( ~isempty(x) ), regexpi(c1, searchToks))

times = t(ind)
fdstings = c1(ind)
readables = c2(ind)

selectedEvents = {};

for i = 1:length(times)
    
   selectedEvents = vertcat(selectedEvents,  {sprintf('%s    %s', times{i}, fdstings{i}) } );
    
end

hs = getappdata(gcf, 'hs');

hs.events.String = selectedEvents
hs.events.Value = 1
hs.infoString.String = readables{1};

