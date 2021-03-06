%% Plot Styles

    colors = {  [0 0 1],        ... % Blue
                [0 .5 0],       ... % Green
                [.75 0 .75],    ... % Magenta
                [0 .75 .75],    ... % Teal
                [.68 .46 0]};       % Amber

    lineStyle = {'-','--',':'};


%% Operation Comparison Variables

%     load(fullfile('/Users/nickcounts/Documents/Spaceport/Data/Stage Test/WDR/data','timeline.mat'));
%     timelineWDR = timeline;
% 
%     load(fullfile('/Users/nickcounts/Documents/Spaceport/Data/Stage Test/A230 Stage Test/data','timeline.mat'));
%     timelineST = timeline;
% 
%     offset = timelineST.t0.time - timelineWDR.t0.time;

%% LO2 Plot #1

%     filenames = {'2117' '2905' '2116' '2912' '2118' '2908'};
%     path = '~/Documents/Spaceport/Data/Stage Test/WDR/data/';
% 
% hold on;
%     
% i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 5; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 6; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i-5}, 'displayname', [fd.Type '-' fd.ID], 'linestyle', '--')
% 
% hline([-293.8 -297.4], {'--r' '--r'});


%% LO2 Plot #2

%     filenames = {'2913' '2916' 'LOLS Storage Tank Pressure Set Point' '2069' '2059' '4168'};
%     path = '~/Documents/Spaceport/Data/Stage Test/WDR/data/';
% 
% hold on;
% 
% i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', 'r', 'displayname', ['LOLS Storage Tank Press SP'])
% i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.position.Time + offset, fd.position.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 5; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.position.Time + offset, fd.position.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
% i = 6; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.position.Time + offset, fd.position.Data, 'color', colors{i-5}, 'displayname', [fd.Type '-' fd.ID], 'linestyle', '--')

%% LO2 Plot #3

% hold on;
% 
%     filenames = {'2015' '2016' 'LO2 Flow Control Max SP' 'LO2 Flow Control Min'};
%     path = '~/Documents/Spaceport/Data/Stage Test/WDR/data/';
%     
%     i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
%     i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
%     i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', 'r', 'displayname', 'SP-Flow Control')
%     i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', 'r', 'displayname', 'SP-Flow Control')
% 
% 
% hold on;



%% LO2 Plot #4


hold on;

    offset = -105.03751978;

    filenames = {
                    '2112 LO2 PT-2112 Press Sensor Mon'
                    '2909 LO2 PT-2909 Press Sensor Mon'
                    '2904 LO2 PT-2904 Press Sensor Mon'
                    '2918 LO2 PT-2918 Press Sensor Mon'
                 };
                
    path = '~/Documents/Spaceport/Data/Testing/2016-08-08 - LO2 Decay Check/data/';
    
    i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
    i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
    i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
    i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])


hold on;










