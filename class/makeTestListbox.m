hs.fig = figure;
hs.listbox = uicontrol(hs.fig, 'style','listbox','Units','normalized','Position',[0.1,0.1,0.8,0.8]);
hs.editbox = uicontrol(hs.fig, 'style','edit','Units','normalized','Position',[0.1,0.95,0.8,0.05],'HorizontalAlignment','left');

% hs.listbox.Units = 'normalized'
% hs.listbox.Position = [0.1,0.1,0.8,0.8]


fdc = FDCollection(dataIndex(1), hs.listbox);
fdc.searchUI = hs.editbox;
fdc.populateListbox;

