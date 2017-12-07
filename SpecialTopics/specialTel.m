%% Script to process TELHS data and resample the listed FDs
% This allows direct comparison (subtraction, etc) and can be easily
% exported to Excel... We did it for Stevens

path = '/Users/nickcounts/Documents/Spaceport/Data/Testing/2017-09-27 - TEL Cyl Test/data'

% PT30 has the most data points

names = {'pt30', 'pt31', 'pt35', 'pt36', 'pt45', 'pt46', 'pt50', 'pt51'};

files = {   'TELHS_SYS2 PT30 Mon.mat';
            'TELHS_SYS1 PT31 Mon.mat';
            'TELHS_SYS2 PT35 Mon.mat';
            'TELHS_SYS1 PT36 Mon.mat';
            'TELHS_SYS2 PT45 Mon.mat';
            'TELHS_SYS1 PT46 Mon.mat';
            'TELHS_SYS2 PT50 Mon.mat';
            'TELHS_SYS1 PT51 Mon.mat'};


data = struct;

for i = 1:numel(names)
    
	data.(names{i}) = load(fullfile(path, files{i}),'fd');
    
end



newdata = struct;

timeIndexStreamNumber = 1;

for i = 1:numel(names);
    
    newData.(names{i}) = resample(data.(names{i}).fd.ts, data.(names{timeIndexStreamNumber}).fd.ts.Time);
    
end

bigMatrix = zeros(length(newData.(names{1}).Time), (1 + numel(names)) );
bigMatrix(:,1) = m2xdate(newData.(names{1}).Time );

for i = 1:numel(names)
    
    bigMatrix(:,i+1) = newData.(names{i}).Data;
    disp(newData.(names{i}).Name);
    
end


newData.s1capav  = timeseries(mean([newData.pt30.Data(:), newData.pt31.Data],2),    newData.pt30.Time, 'name', 'P_cap Avg CylA')
newData.s1rodav  = timeseries(mean([newData.pt35.Data(:), newData.pt36.Data],2),    newData.pt30.Time, 'name', 'P_rod Avg CylA')
newData.s1deltap = timeseries( -[newData.s1capav.Data - newData.s1rodav.Data],      newData.pt30.Time, 'name', '\DeltaP CylA')

newData.s2capav  = timeseries(mean([newData.pt45.Data(:), newData.pt46.Data],2),    newData.pt30.Time, 'name', 'P_cap Avg CylB')
newData.s2rodav  = timeseries(mean([newData.pt50.Data(:), newData.pt51.Data],2),    newData.pt30.Time, 'name', 'P_rod Avg CylB')
newData.s2deltap = timeseries( -[newData.s2capav.Data - newData.s2rodav.Data],      newData.pt30.Time, 'name', '\DeltaP CylB')


fd = newFD;

fd.FullString       = 'TELHS_CYL_A P_cap Avg';
    fd.ID           = 'CylA Pcap';
    fd.isValve      = false;
    fd.Type         = 'PT';
    fd.System       = 'TELHS';
    fd.ts = newData.s1capav;

save(fullfile(path, [fd.FullString, '.mat']), 'fd')

fd.FullString       = 'TELHS_CYL_A P_rod Avg';
    fd.ID           = 'CylA Prod';
    fd.isValve      = false;
    fd.Type         = 'PT';
    fd.System       = 'TELHS';
    fd.ts = newData.s1rodav;

    save(fullfile(path, [fd.FullString, '.mat']), 'fd')

fd.FullString       = 'TELHS_CYL_A P_cap_rod_delta';
    fd.ID           = 'CylA P\DeltaP';
    fd.isValve      = false;
    fd.Type         = 'DERIVED';
    fd.System       = 'TELHS';
    fd.ts = newData.s1deltap;

    save(fullfile(path, [fd.FullString, '.mat']), 'fd')

fd.FullString       = 'TELHS_CYL_B P_cap Avg';
    fd.ID           = 'CylB Pcap';
    fd.isValve      = false;
    fd.Type         = 'PT';
    fd.System       = 'TELHS';
    fd.ts = newData.s2capav;

    save(fullfile(path, [fd.FullString, '.mat']), 'fd')

fd.FullString       = 'TELHS_CYL_B P_rod Avg';
    fd.ID           = 'CylB Prod';
    fd.isValve      = false;
    fd.Type         = 'PT';
    fd.System       = 'TELHS';
    fd.ts = newData.s2rodav;

    save(fullfile(path, [fd.FullString, '.mat']), 'fd')

fd.FullString       = 'TELHS_CYL_B P_cap_rod_delta';
    fd.ID           = 'CylB P\DeltaP';
    fd.isValve      = false;
    fd.Type         = 'DERIVED';
    fd.System       = 'TELHS';
    fd.ts = newData.s2deltap;

    save(fullfile(path, [fd.FullString, '.mat']), 'fd')
