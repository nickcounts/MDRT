%% readDelim.m
%
%   Opens a .delim file and extracts the relavent information. Timestamps
%   are converted to Matlab-style date/time values. Other columns are
%   extracted to vectors and cell arrays for additional processing.
%
%   This implementation automatically graphs the extracted values based on
%   the number of unique data ID tags found in the file. Future versions
%   will include customization options.
%
%   Counts, 8/19/12
%


% Delim file format:
%
% 2012/219/04:00:00.261646, , ,AIR DPT-3 Press Sensor  Mon, A,FCS DPT-3 ECS Room Pressure,----------------,1.88083333E-01    ,in H20,
% tline = '2012/219/04:00:00.261646, , ,AIR DPT-3 Press Sensor  Mon, A,FCS DPT-3 ECS Room Pressure,----------------,1.88083333E-01    ,in H20,';
%% File Opening Routine
%
%   This section is a temporary implementation - opens a .delim file
%
%   Data are extracted to a cell array "Q" for later parsing

[filename, pathname] = uigetfile( ...
{  '*.delim',  'FCS Archive File (*.delim)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');

fid = fopen([pathname filename]);
% fid = fopen('RoomPress_080712.delim');

    Q = textscan(fid, '%s %s %s %s %s %s %s %s %s', 'Delimiter', ',');

fclose(fid);

% memory management
clear fid pathname filename


%% Initial Data Parsing
%
%   Assign important data to their own cell arrays for parsing
%

timeCell        = Q{1};
parameterCell   = Q(4);
labelCell       = Q{6};
valueCell       = Q{8};

% Optional Cleanup
clear Q;

%% Timestamp Parsing
%
%   textscan(timeCell, '%d / %d / %d / %d : %d : %f')
%   Quick parse time data into a matrix

    a = textscan(sprintf('%s\n',timeCell{:}),'%f/%f/%f:%f:%f');

%timeMat is of the form [year day hour minute second]
    timeMat = [a{:}];

% generate a Matlab-style date (without time) by addition
% extract yyyy mm dd
% assemble Matlab date using datenum
    rawDate = datenum(timeMat(:,1),1,1) + timeMat(:,2);

        yearM   = str2double(datestr(rawDate, 'yyyy'));
        monthM  = str2double(datestr(rawDate, 'mm')); 
        dayM    = str2double(datestr(rawDate, 'dd'));

% TIME VARIABLE: time is a matlab-style time value (double)
    time = datenum(yearM,monthM,dayM,timeMat(:,3),timeMat(:,4),timeMat(:,5));

        % cleanup
        clear year month day rawdate timeMat a timeCell

%data cleanup
clear a

%   At this point, the active variables are:
%       time, labelCell, valueCell

%% Automatic Plotting:


% Data reduction from Excel Delim file

channels = unique(labelCell);

%Grab logical index mask for each channel
for i = 1:length(channels)
    chanIndexes(:,i) = strcmp(labelCell,channels(i));
end


% Create styles for each data set.
% Loop through so there are always enough styles for each plot
styles = { };
for i = 1:ceil(length(channels)/9)
    styles = [styles {'b-' 'g-' 'r-' 'b.-' 'g.-' 'r.-' 'b:' 'g:' 'r:'}];
end

%Plot all available channels.
% TEMP FIX: Ignore any channels that are ACK / ACK pending - command
% related data. All non-numerical channels will  be skipped
for i = 1:length(channels)
    if ~isnan(str2double(valueCell{find(chanIndexes(:,i),1 , 'first')}))
        plot( time(chanIndexes(:,i)), valueCell(chanIndexes(:,i)),styles{i},'displayname',channels{i});
    end
    hold on;
end

legend show;

dynamicDateTicks;








