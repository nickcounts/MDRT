startTime = datenum('19-Mar-2014 23:50:00');
endTime = datenum('20-Mar-2014 02:20:00');
timeStep = 1/24/60/60;
newTimeVector = startTime:timeStep:endTime;

origPath = '~/Desktop/data/';
savePath = '~/Desktop/data/evenTime/';
fileList = dir(fullfile(origPath,'*.mat'));



for i = 1:length(fileList)
    
        load(fullfile(origPath, fileList(i).name));
        
        % resampling uses linear interpolation by default. If the time
        % interval extends beyond the original data, resample will return a
        % value of NaN.
        ts1 = resample(fd.ts, newTimeVector);
        
        
        fd.ts = ts1;
        
        save(fullfile(savePath, fileList(i).name),'fd')
        
end