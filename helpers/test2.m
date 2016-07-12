
function demo
% Listen to zoom events
load('./ORB-1/data/5903.mat')

% plot(1:10);
plot(fd.ts)

h = zoom;
set(h,'ActionPreCallback',@myprecallback);
set(h,'ActionPostCallback',@mypostcallback);
set(h,'Enable','on');

function myprecallback(obj,evd)
disp('A zoom is about to occur.');



function mypostcallback(obj,evd)
newLim = get(evd.Axes,'XLim');
msgbox(sprintf('The new X-Limits are [%.2f %.2f].',newLim));



