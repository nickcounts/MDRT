% Brings all plotted data to the top of the graphics stack

% Steps through all data plot handles

[maxi,maxj, maxk] = size(hDataPlot);

for i = 1: maxi
    for j = 1:maxj
        for k = 1:maxk
            if hDataPlot(i,j,k)
                
                uistack(hDataPlot(i,j,k),'top');
            else
                % Don't do anything - either the root graphics object
                % (yikes!) or not a valid data plot handle
            end
        end
    end
end
