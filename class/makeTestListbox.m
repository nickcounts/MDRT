hs.fig = figure;
hs.listbox = uicontrol(hs.fig, 'style','listbox','Units','normalized','Position',[0.1,0.1,0.8,0.8]);
hs.editbox = uicontrol(hs.fig, 'style','edit','Units','normalized','Position',[0.1,0.95,0.8,0.05],'HorizontalAlignment','left');

% hs.listbox.Units = 'normalized'
% hs.listbox.Position = [0.1,0.1,0.8,0.8]

cfg = MDRTConfig;
load(fullfile(cfg.dataArchivePath, 'dataIndex.mat'));

fdc = FDCollection(dataIndex(1:2), hs.listbox);
fdc.searchUI = hs.editbox;
fdc.populateListbox;

