%% Plot Styles

colors = {  [0 0 1],        ... % Blue
            [0 .5 0],       ... % Green
            [.75 0 .75],    ... % Magenta
            [0 .75 .75],    ... % Teal
            [.68 .46 0]};       % Amber
        
lineStyle = {'-','--',':'};


%% Operation Comparison Variables

load(fullfile('/Users/nickcounts/Documents/Spaceport/Data/Stage Test/WDR/data','timeline.mat');
timelineWDR = timeline;

load(fullfile('/Users/nickcounts/Documents/Spaceport/Data/Stage Test/A230 Stage Test/data','timeline.mat');
timelineST = timeline;

offset = timelineST.t0.time - timelineWDR.t0.time;

%% LO2 Plot #1

filenames = {'2117' '2905' '2116' '2912' '2118' '2908'};
path = '~/Documents/Spaceport/Data/Stage Test/WDR/data/';


i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 5; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 6; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i-5}, 'displayname', [fd.Type '--' fd.ID])