%% makeDataGrid
%
%   makeDataGrid is a helper script that takes a list of FDs (numerical
%   only at this time), interpolates the time series data to conform to a
%   set of supplied timestamps and then writes the values at those
%   timestamps into one large cell array with timestamps as row headers and
%   FD title as column headers.
%
%   Counts 3-14

FDList = {4931,4905,4912,4921};


% newTimeVector = datenum(2014,1,9,11,0,0):15*(1/24/60):datenum(2014,1,9,20,0,0); % ORB-1
% newTimeVector = datenum(2013,9,18,14-7,58,0):15*(1/24/60):datenum(2013,9,18,14+2,58,0); % ORB-D1
newTimeVector = [datenum(2014,7,13,15,32,14.1) datenum(2014,7,13,16,19,59.8) datenum(2014,7,13,16,42,14.1) datenum(2014,7,13,16,49,14.1) datenum(2014,7,13,16,52,14)]; % ORB-2



% path = fullfile('.','ORB-1','data'); % ORB-1 Data File Location
% path = fullfile('/','Users','nick','Documents','MATLAB','ORB-D1','Data Files'); % ORB-D1 Data File Location
path = fullfile('/','Users','nick','Documents','MATLAB','Data Review','ORB-2','data'); % ORB-D1 Data File Location


filePaths = cell(size(FDList));

for i = 1:length(FDList)
    
    filePaths{i} = fullfile(path, [num2str(FDList{i}) '.mat']);
    dataFileExists(i) = exist(filePaths{i},'file');

end



outputCellArray = cell(length(newTimeVector)+1, length(FDList)+1);

% Write the first column of timestamps
outputCellArray(2:end,1) = cellstr(datestr(newTimeVector));

for i = 1:length(FDList)
    if dataFileExists(i)
        % A little error checking before file is loaded.
        % Data that do not exist will be skipped.
        
        load(filePaths{i});
        
        % resampling uses linear interpolation by default. If the time
        % interval extends beyond the original data, resample will return a
        % value of NaN.
        
%         ts1 = resample(fd.ts, newTimeVector);
        
        ts1 = timeseries(interp1(fd.ts.Time,fd.ts.Data,newTimeVector,'spline'),newTimeVector);
        
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
        
end












