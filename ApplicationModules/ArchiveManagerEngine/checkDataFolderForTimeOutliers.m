[fds, startstop, times] = indexTimeAndFDNames('/Users/engineer/Data Repository/2017-11-12 - OA-8 Launch/data')

times(times==0) = []

times = reshape(times, length(times)/2, 2)
figure
plot((times(:,2)-median(times(:,2))))
hold on; plot( (times(:,1)-median(times(:,1))), 'g')

%use data brush to highlight the outliers and export to variable named 'cd'

% show filenames of questionable data
fds([cd(:,1)]',2)

