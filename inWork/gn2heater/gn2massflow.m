%% Constant Definitions

    secondsInADay = 24*60*60;

    targetSampleRate = 20; % samples/second (Hz)
    sampleStep = (secondsInADay * targetSampleRate)^-1;
    
    R = 0.3830; % psia * ft^3 / lbm °R
    
    FarenheitToRankine = 459.67;
    
    mmGN2 = 28.013; % lbm / lbmol
    
    lbmToKg = 0.45; % multiply lbms to get kg

    cubicFeetToCubicMeters = 0.0283168;
    
    volumeToMass = 1.161; % cubic meters to kilograms
    
%% Load Data

    load('/Users/nickcounts/Documents/Spaceport/Data/Testing/03-18-16 ECS GN2 Test/data/ECS-FM-0003.mat')
        fm = fd.ts;

    load('/Users/nickcounts/Documents/Spaceport/Data/Testing/03-18-16 ECS GN2 Test/data/5923.mat')
        tc = fd.ts;

    clear fd;


%% Make Common Time Data


    elapsed = (fm.Time(end)-fm.Time(1)) * secondsInADay;

    % Get time interval that spans all recorded samples
        startTime = min([fm.Time(1) tc.Time(1)]);
        stopTime = max([fm.Time(end) tc.Time(end)]);

    % Generate new time vector for data resampling
        newTimeVector = startTime:sampleStep:stopTime;

    % Create new time series
        temp = tc.resample(newTimeVector);
        flow = fm.resample(newTimeVector);

%% Calculate mass flow rate

% %     P V = ( mass / mm ) R T
% % 
% %     D = mass / V
% % 
% %     P mm / R T = mass / V
% % 
% %     D = P mm / (R T)
% %     
% %     R units: psia * ft^3 / lbm °R
% 
% % R = F -  459.67
% P = 14.7; % psia
% % 1 lbm = 0.45 kg;
% 
% % 1.44 ft^3/lbmol
% 
% 
%     % Convert temperature stream to Rankine
%     TempRankine = temp.Data + FarenheitToRankine;
%     
%     % Make Density Vector (lbm/ft^3)
%     D = P .* mmGN2 ./ (R .* TempRankine);
%     
%     % Make Mass/sec vector;
%     M = D .* flow.Data ./ 60;
%     


    cubicMetersMinute = flow.Data .* cubicFeetToCubicMeters;
    massPerMinute = cubicMetersMinute .* volumeToMass;
    massPerSecond = massPerMinute ./ 60;
    

massFlow = timeseries;
massFlow.Data = massPerSecond;
massFlow.Time = flow.Time;
massFlow.Name = 'Mass Flow of GN2 in kg/s';

%% Build fd to save

    fd = newFD;
        fd.ts = massFlow;
        fd.FullString = 'ECS GN2 Mass Flow Rate in kg/s';
        fd.ID = 'FM-0003';
        fd.Type = 'Flow Rate';
        fd.System = 'ECS GN2';

        
%% Save Data for Later Use

    % Bring up the save-as dialog prepopulated with the current working
    % directory and the default filename
    [file,path] = uiputfile('*.mat','Save data file as:');
    
    if file
        % User did not hit cancel
        
        save(fullfile(path,file),'fd')
    else
        % User hit cancel button
        disp('User cancelled save');
    end










