%% Fix datenums for FDs

%     startTimeString = input('Enter the starting time and date: ','s');
%     startTime = datenum(startTimeString);
%     startTime = datenum('10-30-15 09:01:31')
%     startTime = datenum('01-28-16 15:27:22')
%     startTime = datenum('2016/032/17:05:36.203354')
%     startTime = datenum('2016/069/10:00:00.203354')
%     startTime = datenum('2016/113/10:00:00.203354')
%     startTime = datenum('2016/221/13:15:31.347377')
    startTime = datenum('2016/219/17:00:07.855209')
    % time = startTime + (t * oneSec);

%% Generate new Time Vector
% 
    oneSec = 1/24/60/60;
    time = startTime + (t * oneSec);

%% Translate 1-5 Volt signal to 0 to 100%
% 
    PTmaxRange = 5000;
    psi = (a7 - 1)/4 * PTmaxRange;

    
%% Time Sync Data to FCS:


% look at 8020 Ctl

    reduce_plot(time, a5, 'DisplayName', '8020 Command');
    dynamicDateTicks;
    plotStyle;

    keyboard


% save cursor data as variable c
%     timeSync = datenum('10/29/2015 18:23:53.079655');
%     timeSync = datenum('10/30/2015 13:32:19.206714');
%     timeSync = datenum('01/28/2016 21:15:02.985759');

%     timeSync = datenum('August 6, 2016 13:29:40.050157');


    firstCommand = c.Position(1);
    
    
    time = time+(timeSync - firstCommand);



    
    
    
    
%% Make timeseries    
    
    
ts = timeseries();
    
    
    
    
    
    
keyboard

progressbar('Saving DAQ Data as FDs');
    
%% Pressure Sensor
% ---------------
fd = newFD;
fd.ID = 'STE PT';
fd.Type = 'PT';
fd.System = 'HSS';
fd.FullString = 'HSS STE PT-8XXX'

ts.Name = 'HSS STE PT';
ts.Time = time;
ts.Data = psi;

fd.ts = ts;

save(fullfile(dataFolderPath,['STE PT', '.mat']),'fd','-mat');

progressbar(1/7);

%% DCVNO-8020
fd.ID = '8020 Open';
fd.Type = 'DCVNO';
fd.System = 'HSS';
fd.FullString = 'HSS STE PT-8020';

ts.Name = 'DCVNO-8020 Open Switch'
ts.Time = time;
ts.Data = a1;

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(2/7);

% DCVNO-8020
fd.ID = '8020 Close';
fd.Type = 'DCVNO';
fd.System = 'HSS';
fd.FullString = 'DCVNO-8020 Close Switch'

ts.Name = 'DCVNO-8020 Close Switch';
ts.Time = time;
ts.Data = a2;

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(3/7);

%% DCVNC-8030
fd.ID = '8030 Open';
fd.Type = 'DCVNC';
fd.System = 'HSS';
fd.FullString = 'DCVNC-8030 Close Switch'

ts.Name = 'DCVNO-8030 Open Switch';
ts.Time = time;
ts.Data = a3;

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(4/7);

% DCVNO-8020
fd.ID = '8030 Close';
fd.Type = 'DCVNC';
fd.System = 'HSS';
fd.FullString = 'DCVNC-8030 Close Switch'

ts.Name = 'DCVNC-8030 Close Switch';
ts.Time = time;
ts.Data = a4;

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(5/7);

%% DCVNC-8020 Command
fd.ID = '8020 Command';
fd.Type = 'DCVNO';
fd.System = 'HSS';
fd.FullString = 'DCVNC-8020 Solenoid Voltage'

ts.Name = 'DCVNC-8020 Solenoid Voltage';
ts.Time = time;
ts.Data = a5 /4.9 * 24 ; % Convert to 24V signal (from voltage divider)

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(6/7);

%% DCVNO-8030 Command
fd.ID = '8030 Command';
fd.Type = 'DCVNC';
fd.System = 'HSS';
fd.FullString = 'DCVNC-8030 Solenoid Voltage'

ts.Name = 'DCVNC-8030 Solenoid Voltage';
ts.Time = time;
ts.Data = a6 / 4.9 * 24 ; % Convert to 24V signal (from voltage divider);

fd.ts = ts;

save(fullfile(dataFolderPath,[fd.ID, '.mat']),'fd','-mat');
progressbar(7/7);


