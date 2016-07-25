%% Contains custom event indicators - not added to events.mat




vlh = vline(datenum(2013,9,18,8,24,23.172835),'-k','Pressurization Fan ON',[0.05,-1])
uistack(vlh,'bottom')

vlh = vline(datenum(2013,9,18,15,56,26.072807),'-k','Pressurization Fan OFF',[0.05,-1])
uistack(vlh,'bottom')