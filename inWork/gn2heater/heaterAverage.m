timeAverageSeconds = 10;
sampleRate = 50;
sampleRate = 80;

window_size = sampleRate * timeAverageSeconds;

% High Sample Rate
% window_size = 3000;

% Low Sample Rate
% window_size = 800;

% Calculate the simple moving average.

simple = tsmovavg(fd.ts.Data,'s',window_size,1);
% Calculate the exponential weighted moving average moving average.

% Calculate the weighted moving average moving average.

% semi_gaussian = [0.026 0.045 0.071 0.1 0.12 0.138];

semi_gaussian = gausswin(100)';

semi_gaussian = [semi_gaussian fliplr(semi_gaussian)];
weighted = tsmovavg(fd.ts.Data/max(fd.ts.Data)*100,'w',semi_gaussian,1);

smoothed = tsmovavg(weighted,'s',window_size,1);


f = figure;

plot(fd.ts)
hold on;
plot(fd.ts.Time, weighted, 'displayname', 'Averaged')
hold on;
plot(fd.ts.Time, smoothed, 'displayname', 'Averaged')



