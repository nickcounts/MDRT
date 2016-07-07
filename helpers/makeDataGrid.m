%% makeDataGrid
%
%   makeDataGrid is a helper script that takes a list of FDs (numerical
%   only at this time), interpolates the time series data to conform to a
%   set of supplied timestamps and then writes the values at those
%   timestamps into one large cell array with timestamps as row headers and
%   FD title as column headers.
%
%   Counts 3-14

FDList = {5902;5919;4930;4912;5917;5920;5906;5921;5909;5908;5924;5903;4913;
4901;4927;1901;1902;1909;1917;2902;2912;2913;2916;3916;3917;3918;3919;3920;
4901;4912;4913;4918;4919;4920;4927;4930;5902;5903;5906;5908;5909;5917;5919;
5920;5921;5924;5925;3905;3915};


% % newTimeVector = datenum(2014,7,13,16-7,52,14):15*(1/24/60):datenum(2014,7,13,16+2,52,14); % ORB-2
% % % newTimeVector = datenum(2014,1,9,11,0,0):15*(1/24/60):datenum(2014,1,9,20,0,0); % ORB-1
% % % newTimeVector = datenum(2013,9,18,14-7,58,0):15*(1/24/60):datenum(2013,9,18,14+2,58,0); % ORB-D1



% path = fullfile('/','Users','nick','Documents','MATLAB','Data Review','ORB-1','data'); % ORB-1 Data File Location
% path = fullfile('/','Users','nick','Documents','MATLAB','ORB-D1','Data Files'); % ORB-D1 Data File Location
% path = fullfile('/','Users','nick','Documents','MATLAB','Data Review','ORB-2','data'); % ORB-2 Data File Location
path = fullfile('~','Documents','Spaceport','Data','ORB-3','LA-2','data'); %ORB-3 r2 Data File Location
% path = fullfile('~','Documents','Spaceport','Data','ORB-3','LA-1','data'); %ORB-3 r1 Data File Location

%% Use timeHacks vector to generate the timesteps

t0 = datenum(2014,10,28,22,22,38.014); % ORB-3 r2
% t0 = datenum(2014,10,27,22,43,03.0); % ORB-3 r1
% t0 = datenum(2014, 7,13,16,52,14);   % ORB-2
% t0 = datenum(2014,1, 9,18,07,06);   % ORB-1

% %%%%%%%%%%%%%%%%%%%%%%%%%
% % Grid Setup Parameters %
% %%%%%%%%%%%%%%%%%%%%%%%%%

hoursBefore = 8;
hoursAfter  = 8;
intervalInMinutes = 15;




timeHacks = hoursBefore/24: -(1/24/60*intervalInMinutes) : -hoursAfter/24;
datestr(timeHacks, 'HH:MM:SS');
newTimeVector = t0 - timeHacks;






filePaths = cell(size(FDList));




for i = 1:length(FDList)
    
    filePaths{i} = fullfile(path, [num2str(FDList{i}) '.mat']);
    dataFileExists(i) = exist(filePaths{i},'file');

end



outputCellArray = cell(length(newTimeVector)+1, length(FDList)+1);

% Write the first column of timestamps
outputCellArray(2:end,1) = cellstr(datestr(newTimeVector));

progressbar('Processing Launch Data');

for i = 1:length(FDList)
    if dataFileExists(i)
        % A little error checking before file is loaded.
        % Data that do not exist will be skipped.
        
        load(filePaths{i});
        
        % resampling uses linear interpolation by default. If the time
        % interval extends beyond the original data, resample will return a
        % value of NaN.
        ts1 = resample(fd.ts, newTimeVector);
        
        % make a temporary variable to allow mixing cell arrays and
        % matrices
        data = num2cell(ts1.Data);
        
        % Fill in numerical Data
        outputCellArray(2:end,i+1) = data;
        
        % Fill in column header information
        outputCellArray{1,i+1} = [fd.Type, '-', fd.ID];
        
    else
        outputCellArray{1,i+1} = [FDList{i}];
    end
    
    progressbar(i/length(FDList));
        
end












