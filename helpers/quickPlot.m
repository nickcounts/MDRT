function [ output_args ] = quickPlot( fdName )
%



figure;

% load(['/Users/nick/Documents/MATLAB/ORB-D1/Data Files/' fdName '.mat']);
load([fdName '.mat']);



switch upper(fd.Type)
    case {['DCVNC' 'DCVNO']}
        h_plot = stairs(fd.ts.Time, fd.ts.Data*1);
    otherwise
        h_plot = plot(fd.ts);
end

hZoom = zoom;
set(hZoom,'Motion','horizontal','Enable','on');

dynamicDateTicks;
plotStyle;



end

