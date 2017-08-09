% filterFD  Launches a GUI tool for data smoothing and filtering
     %         filterFdTool() Launches the tool in demo mode with dummy data.
     %         filterFdTool(fullFile) launches the tool and loads the contents
     %         of fullFile.
     %
     %         This tool is designed to work with data files produced by
     %         MDRT. Data files will contain a structure 'fd' which
     %         contains a timeseries 'ts'.
     %
     % Examples:
     %   filterFD();
     %
     %   filterFD(fullfile('~/DataFolder', 'dataFile.mat'))
     %
     
     % See also PLUS, SUM.
     
     %8-10-17
     %J. Singh, VCSFA
     %Smoothing function rewritten, bugs fixed, lightweight and filter
     %functionality added, new GUI.
     
     
function filterFdTool(fdDataFullFile)
% This is the main function for the data smoothing tool. This function
% defines constants, instantiates "shared" (ugh, I know it's global state 
% and that's bad) variables, calls the GUI generating function, and handles
% the input cases (file passed, nothing passed). The graphics area is
% populated.



    %% Constant Definitions

    % Slider Bounds [min default max]
        GAUSSIAN_WEIGHTED_SLIDER_BOUNDS     = [0 0 10];
        TIME_AVERAGE_WINDOW_SLIDER_BOUNDS   = [1  1    60];
        SAMPLE_RATE_SLIDER_BOUNDS           = [1 1   100];
        DECIMATION_PERCENTAGE               = [1 50 100];
        FILTER_FREQUENCY                    = [0.000 1.000 1.000];
        FILTER_ORDER                        = [1 2 15];
        
    % Initialize important variables 
        sampleRate=SAMPLE_RATE_SLIDER_BOUNDS(2);
        fd = newFD;
        config = MDRTConfig.getInstance;
        hs = struct();
        delayOn=1; %default setting. This reflects the initial state of the
                   %checkbox being checked (value is 1)
                   
       %these are used for keeping track of delay correction updates:
       windowState=TIME_AVERAGE_WINDOW_SLIDER_BOUNDS(2)*sampleRate;
       window=TIME_AVERAGE_WINDOW_SLIDER_BOUNDS(2)*sampleRate;
       delayState=1;
       FOState=2;
       
       %Radio Button Indicators for certain functions
       LWradioIndicator=1;
       FradioIndicator=1;
       
       %To hold data where decimation or filtering has been applied
       filteredY=[];
       lightweightY=[];
       lightweightX=[];
       
       %To hold databrushed values
       brushedData=[];
        
    % Create the tool GUI and all handles
        createSmoothingGUI();


%% Initial Conditions for testing!!!


    % Always populate the fd struct with test data when the fuction is
    % first run. That way we can cancel file loads and still have valid
    % data.
    
    %Create noise of +/- 1% on y=sin(t*24) signal
    t = floor(now) + 0.5 : 1/24/60/60 : floor(now) + 0.75;
    %t=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
   
  noise=(-1+2*rand(size(t)))/100;
    noiseSignal=1+noise;
    signal=sin(t*24);
    y=signal.*noiseSignal;
    
   
    fd.FullString = 'Example Signal';
    fd.ts = timeseries(y', t');
    fd.ts.Name = fd.FullString;

    switch nargin
        case 0
                            
            % Is there any reason to look at this case anymore?
            
            % '/Users/nickcounts/Documents/Spaceport/Data/Testing/2017-01-11 - ITR-1555 LNSS-2/data/3917 LN2 PT-3917 Press Sensor Mon.mat';
            %         vars = load(testFullFile, 'fd', '-mat');
            %         fd = vars.fd;
            
        case 1
            
            if ~ exist(fdDataFullFile, 'file')
                warn('Attempted to open a file that does not exist');
                % Call file loading function since no file was passed
                % Pass a dummy argument to trigger the uigetfile
                loadDataFile(true);
            else
                % A fullfile was passed and it exists. Try to load the
                % file. No arguments passed means loadDataFile will skip
                % the uigetfile() routine and try to open fdDataFullFile
                loadDataFile();
                debugout(sprintf('Loading passed file: %s', fdDataFullFile));
            end
            
        
        otherwise
            
    end
    
    
    
        



    fdDataFullFile = fullfile(getuserdir(), 'Example-Signal.mat');
    [dataFile_path, fileName_str, extension_str] = fileparts(fdDataFullFile);
    dataFileName_str = strcat(fileName_str, extension_str);




    

%% Initial Plotting


        % hs.hLine1 = reduce_plot(fd.ts, '-b', 'DisplayName', 'Original');
        original_fd_ts=fd.ts;
        hs.hLine1 = plot(original_fd_ts, '-k', 'DisplayName', 'Original');
            dynamicDateTicks;
        

        hold on  
        hs.hLine2 = plot(fd.ts.Time, fd.ts.Data, '-r', 'DisplayName', 'Smoothed');
        hs.hLine3 = plot(fd.ts.Time, fd.ts.Data, '-g', 'DisplayName', 'Filtered');
        hs.hLine4 = plot(fd.ts.Time, fd.ts.Data, '-m', 'DisplayName', 'Decimated');
        hs.hLine5 = plot(fd.ts.Time, fd.ts.Data, '-b', 'DisplayName', 'Working Signal');
        %Initial Conditions
        set(hs.hLine2, 'Visible', 'On');
        set(hs.hLine3, 'Visible', 'Off');
        set(hs.hLine4, 'Visible', 'Off');
        set(hs.hLine5, 'Visible', 'Off');
        legend('show')
        
       
        
        initialPlot();
        
        

        
        
%% UI Creation and hs population ------------------------------------------
    
    function createSmoothingGUI()    
    

    %% Figure Properties

        fig = figure;

            fig.Resize = 'on';
            fig.Units = 'pixels';
            fig.Position(3:4) = [560 420];
            fig.NumberTitle = 'off';
            fig.Name = 'Data Filtering Tool';
        %     fig.Name = strcat('Data Smoothing Tool: ', ts.Name);
            fig.ToolBar = 'figure';
            
         %  fig.MenuBar = 'none';

           

  


        hs.fig = fig;

    %% Axes Properties

        hs.ax           = axes('Parent', hs.fig);
        hs.ax.Units     = 'pixels';
        hs.ax.Position  = [35 163 501 238];  
        hs.ax.Units     = 'Normalize';
        


    %% Smoothing Panel Properties

        panelName = 'Smoothing Controls';
        panelUnits = 'pixels';
        panelPosition = [0 0 559 150];

        hs.panel_smoothing = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize');
                    
    %% Filter Panel Properties
    
        panelName = 'Filtering Controls';
        panelUnits = 'pixels';
        panelPosition = [0 0 559 150];
        
        hs.panel_filter = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize',...
                        'Visible',      'Off');
    
    %% Decimation Panel Properties
    
        panelName = 'Decimation Controls';
        panelUnits = 'pixels';
        panelPosition = [0 0 559 150];
        
        hs.panel_lightweight = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize',...
                        'Visible',      'Off');

    %% Dropdown Properties

        dropdownContents = {    'Smooth Data';
                                'Filter Data';
                                'Make Lightweight' };

        dropdownUnits = 'pixels';
        % dropdownPos   = [ 0.1 0.1 0.5 0.5];
        dropdownPos   = [410 110 140 027];


        hs.popup = uicontrol(hs.fig, 'Style', 'popup', ...
                        'Units',        dropdownUnits, ...
                        'Position',     dropdownPos, ...
                        'String',       dropdownContents,...
                        'Value',        1,...
                        'Units',        'Normalize',...
                        'Callback',     @dropDownCallback);


    %% SMOOTHING Edit Boxes

        editHandles = { 'hEdit_gaussSize';
                        'hEdit_windowSize';
                        'hEdit_sampleRate'};

        editPos     = { [10 86 70 22];
                        [10 48 70 22];
                        [10 11 70 22]};

        editTag     = { 'gaussSize';
                        'windowSize';
                        'sampleRate'};

        for i = 1:numel(editHandles)
            hs.(editHandles{i}) = uicontrol('Parent', hs.panel_smoothing, ...
                        'Style',        'edit', ...
                        'Units',        'pixels', ...
                        'Position',     editPos{i}, ...
                        'Tag',          editTag{i}, ...
                        'Units',        'Normalize', ...
                        'Callback',     @editBoxCallback);
        end


    %% SMOOTHING Sliders

        sliderHandles = {   'hSlider_gaussSize';
                            'hSlider_windowSize';
                            'hSlider_sampleRate'};

        sliderPos =     {   [87 88 300 18];
                            [87 50 300 18];
                            [87 13 300 18]};

        sliderParams =  {   GAUSSIAN_WEIGHTED_SLIDER_BOUNDS;
                            TIME_AVERAGE_WINDOW_SLIDER_BOUNDS;
                            SAMPLE_RATE_SLIDER_BOUNDS };

        sliderTag   = { 'sliderGaussSize';
                        'sliderWindowSize';
                        'sliderSampleRate'};

        for i = 1:numel(sliderHandles)
            hs.(sliderHandles{i}) = uicontrol('Parent', hs.panel_smoothing, ...
                        'Style',        'slider', ...
                        'Units',        'pixels', ...
                        'Position',     sliderPos{i}, ...
                        'Min',          sliderParams{i}(1), ...
                        'Max',          sliderParams{i}(3),...
                        'Value',        sliderParams{i}(2), ...
                        'Tag',          sliderTag{i},...
                        'Units',        'Normalize');
        end

        hs.listenGSSlider = addlistener(hs.hSlider_gaussSize,  'Value', 'PostSet',@sliderEventListenerCallback);
        hs.listenWSSlider = addlistener(hs.hSlider_windowSize, 'Value', 'PostSet',@sliderEventListenerCallback);
        hs.listenSRSlider = addlistener(hs.hSlider_sampleRate, 'Value', 'PostSet',@sliderEventListenerCallback);

    %% SMOOTHING Labels

        textHandles = { 'hLabel_gaussWindow';
                        'hLabel_timeAvgWindow';
                        'hLabel_sampleRate' };

        textPos =   {   [150 110 190 13];
                        [150 71 190 13];
                        [150 31 190 13]};

        textStr =   {   'Gaussian Weighting Strength (points)';
                        'Moving Average Window (seconds)';
                        'Data Sample Rate (Hz)'};

        for i = 1:numel(textHandles)
            hs.(textHandles{i}) = uicontrol('Parent', hs.panel_smoothing, ...
                        'Style',        'text', ...
                        'Position',     textPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       textStr{i}, ...
                        'Units',        'Normalize');
        end

    %% SMOOTHING Checkbox

       hs.hCheckbox_delay = uicontrol('Parent', hs.panel_smoothing, ...
                        'Style', 'checkbox', ...
                        'Value', 1, ...
                        'Position', [11 110 110 23], ...
                        'Units',    'Normalize', ...
                        'String', 'Delay Correction', ...
                        'Callback', @delayCheckboxCallback );
                        
    
    %% LIGHTWEIGHT Radio Button Panel
        hs.lightweightRadioPanel = uibuttongroup('Parent',hs.panel_lightweight, ...
                        'Position', [0 0 400 100],...
                        'Units', 'Pixels',...
                        'Units', 'Normalize',...
                        'SelectionChangedFcn', @lightweightRadioPanel);
    %% LIGHTWEIGHT Radio Buttons
        lwradioHandles = {'hRadio_full';
                        'hRadio_dataBrush'};

        lwradioPos     = {[10 100 100 22];
                        [10 60 100 22]};

        lwradioTag     = {'radioFull';
                        'radioDataBrush'};
                    
        lwradioString  = { 'Whole Signal';
                         'Use DataBrush'};

        for i = 1:numel(lwradioHandles)
            hs.(lwradioHandles{i}) = uicontrol('Parent', hs.lightweightRadioPanel, ...
                        'Style',        'radiobutton', ...
                        'String',       lwradioString{i},...
                        'Units',        'pixels', ...
                        'Position',     lwradioPos{i}, ...
                        'Tag',          lwradioTag{i}, ...
                        'Units',        'Normalize');
        end

        %% LIGHTWEIGHT Labels
         
         lwtextHandles = { 'hLabel_lightweightSliderFull';
                           'hLabel_dataBrushHelp'};

        lwtextPos =   {   [180 120 190 13];
                          [105 20 190 55]};

        lwtextStr =   {   'Decimation Level (%)';
                          'Select a range of data with the brush then right click the data. Save as a variable titled "brushedData" then press the "Apply" button.'};

        for i = 1:numel(lwtextHandles)
            hs.(lwtextHandles{i}) = uicontrol('Parent', hs.panel_lightweight, ...
                        'Style',        'text', ...
                        'Position',     lwtextPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       lwtextStr{i}, ...
                        'Units',        'Normalize');
        end
        
        
        set(hs.hLabel_dataBrushHelp, 'Visible', 'Off');
        
        %% LIGHTWEIGHT Sliders
        
        lwsliderHandles = {   'hSlider_lightweightFull'};

        lwsliderPos =     {   [160 85 240 30]};

        lwsliderParams =  {   DECIMATION_PERCENTAGE};

        lwsliderTag   = { 'sliderLightweightFull'};

        for i = 1:numel(lwsliderHandles)
            hs.(lwsliderHandles{i}) = uicontrol('Parent', hs.panel_lightweight, ...
                        'Style',        'slider', ...
                        'Units',        'pixels', ...
                        'Position',     lwsliderPos{i}, ...
                        'Min',          lwsliderParams{i}(1), ...
                        'Max',          lwsliderParams{i}(3),...
                        'Value',        lwsliderParams{i}(2), ...
                        'Tag',          lwsliderTag{i},...
                        'Units',        'Normalize');
        end
        
        hs.listenLWSlider = addlistener(hs.hSlider_lightweightFull,  'Value', 'PostSet',@LWsliderEventListenerCallback);
        
        %% LIGHTWEIGHT Edit Boxes
        
        lwEditHandles = {'hEdit_lwFullPercent';
                         'hEdit_lwStartTime';
                         'hEdit_lwEndTime'};

        lwEditPos     = { [110 85 45 30] ;
                          [145 26 45 30];
                          [225 26 45 30]};

        lwEditTag     = {'lwFullPercent';
                         'lwStartTime';
                         'lwEndTime'};

        for i = 1:numel(lwEditHandles)
            hs.(lwEditHandles{i}) = uicontrol('Parent', hs.panel_lightweight, ...
                        'Style',        'edit', ...
                        'Units',        'pixels', ...
                        'Position',     lwEditPos{i}, ...
                        'Tag',          lwEditTag{i}, ...
                        'Units',        'Normalize', ...
                        'Callback',     @lightweightEditBoxCallback);
        end
        
        set(hs.hEdit_lwStartTime, 'Visible', 'Off');
        set(hs.hEdit_lwEndTime, 'Visible', 'Off');
        
        %% LIGHTWEIGHT Static Text
        
        %% LIGHTWEIGHT Push Buttons
        
        lwbuttonHandles =	{   'hButton_applyLightweight'};

        lwbuttonFuncs  =  {   @lightweightButtonCallback};
                            

        lwbuttonPos = {   [284 20 116 43]};
                    

        lwbuttonStr = {   'Apply'};
                        

        for i = 1:numel(lwbuttonHandles)
            hs.(lwbuttonHandles{i}) = uicontrol('Parent', hs.panel_lightweight, ...
                        'Style',        'pushbutton', ...
                        'Position',     lwbuttonPos{i}, ...
                        'String',       lwbuttonStr{i}, ...
                     'Callback',     lwbuttonFuncs{i}, ...
                        'Units',         'Normalize');
       end

        
        %% FILTER Radio Button Panel
        hs.filterRadioPanel = uibuttongroup('Parent',hs.panel_filter, ...
                        'Position', [0 0 400 100],...
                        'Units', 'Pixels',...
                        'Units', 'Normalize', ...
                        'SelectionChangedFcn', @filterRadioPanel);
         %% FILTER Radio Buttons
       
         radioHandles = {'hRadio_low';
                        'hRadio_high';
                        'hRadio_band'};

        radioPos     = {[10 100 100 22];
                        [10 60 100 22];
                        [10 20 100 22]};

        radioTag     = {'radioLow';
                        'radioHigh';
                        'radioBand'};
                    
        radioString  = { 'Low Pass';
                         'High Pass';
                         'Band Pass'};

        for i = 1:numel(radioHandles)
            hs.(radioHandles{i}) = uicontrol('Parent', hs.filterRadioPanel, ...
                        'Style',        'radiobutton', ...
                        'String',       radioString{i},...
                        'Units',        'pixels', ...
                        'Position',     radioPos{i}, ...
                        'Tag',          radioTag{i}, ...
                        'Units',        'Normalize');
        end
        
        %% FILTER Sliders
        
        sliderHandles = {   'hSlider_filterLow';
                            'hSlider_filterHigh';
                            'hSlider_filterBottom';
                            'hSlider_filterTop'};

        sliderPos =     {   [160 85 240 30];
                            [160 85 240 30];
                            [160 100 240 15];
                            [160 65 240 15]};

        sliderParams =  {   FILTER_FREQUENCY;
                            FILTER_FREQUENCY;
                            FILTER_FREQUENCY;
                            FILTER_FREQUENCY};

        sliderTag   = { 'sliderFilterLow';
                        'sliderFilterHigh';
                        'sliderFilterBottom';
                        'sliderFilterTop'};

        for i = 1:numel(sliderHandles)
            hs.(sliderHandles{i}) = uicontrol('Parent', hs.panel_filter, ...
                        'Style',        'slider', ...
                        'Units',        'pixels', ...
                        'Position',     sliderPos{i}, ...
                        'Min',          sliderParams{i}(1), ...
                        'Max',          sliderParams{i}(3),...
                        'Value',        sliderParams{i}(2), ...
                        'Tag',          sliderTag{i},...
                        'Units',        'Normalize');
        end
        
        set(hs.hSlider_filterHigh, 'Visible', 'Off');
        set(hs.hSlider_filterBottom, 'Visible', 'Off');
        set(hs.hSlider_filterTop, 'Visible', 'Off');
        
        hs.listenFilterLowSlider = addlistener(hs.hSlider_filterLow,  'Value', 'PostSet',@FsliderEventListenerCallback);
        hs.listenFilterHighSlider = addlistener(hs.hSlider_filterHigh, 'Value', 'PostSet',@FsliderEventListenerCallback);
        hs.listenFilterBottomSlider = addlistener(hs.hSlider_filterBottom, 'Value', 'PostSet',@FsliderEventListenerCallback);
        hs.listenFilterTopSlider = addlistener(hs.hSlider_filterTop,  'Value', 'PostSet',@FsliderEventListenerCallback);
        
        
        %% FILTER Labels
        
       textHandles = { 'hLabel_filterLow';
                       'hLabel_filterHigh'
                       'hLabel_filterBottom';
                       'hLabel_filterTop';
                       'hLabel_filterOrder'};

        textPos =   {   [180 117 190 13];
                        [180 117 190 13];
                        [180 117 190 13];
                        [180 84 190 13];
                        [95 10 90 13]};

        textStr =   {   'Normalized Frequency (pi*rad/sample)';
                        'Normalized Frequency (pi*rad/sample)';
                        'Low Bound (pi*rad/sample)';
                        'High Bound (pi*rad/sample)';
                        'Filter Order (1-15)'};

        for i = 1:numel(textHandles)
            hs.(textHandles{i}) = uicontrol('Parent', hs.panel_filter, ...
                        'Style',        'text', ...
                        'Position',     textPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       textStr{i}, ...
                        'Units',        'Normalize');
        end
        
         set(hs.hLabel_filterLow, 'Visible', 'On');
         set(hs.hLabel_filterHigh, 'Visible', 'Off');
         set(hs.hLabel_filterBottom, 'Visible', 'Off');
         set(hs.hLabel_filterTop, 'Visible', 'Off');
        
        %% FILTER Edit Boxes
        
       fEditHandles = { 'hEdit_filterLow';
                        'hEdit_filterHigh';
                        'hEdit_filterBottom';
                        'hEdit_filterTop';
                        'hEdit_filterOrder'};

        fEditPos     = {[110 85 45 30];
                        [110 85 45 30];
                        [110 100 45 15];
                        [110 65 45 15];
                        [110 25 45 30]};

        fEditTag     = {'editFilterLow';
                        'editFilterHigh';
                        'editFilterBottom';
                        'editFilterTop';
                        'editFilterOrder'};

        for i = 1:numel(fEditHandles)
           hs.(fEditHandles{i}) = uicontrol('Parent', hs.panel_filter, ...
                        'Style',        'edit', ...
                        'Units',        'pixels', ...
                        'Position',     fEditPos{i}, ...
                        'Tag',          fEditTag{i}, ...
                        'Units',        'Normalize', ...
                        'Callback',     @filterEditBoxCallback);
        end
        
        %Intial Settings
        set(hs.hEdit_filterHigh, 'Visible', 'Off');
        set(hs.hEdit_filterBottom, 'Visible', 'Off');
        set(hs.hEdit_filterTop, 'Visible', 'Off');
        set(hs.hEdit_filterOrder, 'Value', 2);
        hs.hEdit_filterOrder.String = hs.hEdit_filterOrder.Value;
        
        
        %% FILTER Push Buttons
        
        buttonHandles =	{   'hButton_applyLightweight';
                            'hButton_FFT'};

        buttonFuncs  =  {   @applyFiltering;
                            @fourierButtonCallback};
                            

        buttonPos = {   [294 20 106 43]
                        [184 20 106 43]};
                    

        buttonStr = {   'Apply';
                        'Show FFT'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel_filter, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                     'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
       end
    %% Buttons

        buttonHandles =	{   'hButton_save';
                            'hButton_load'};

        buttonFuncs  =  {   @saveFilteredData;
                            @loadDataFile};
                            

        buttonPos = {   [417 20 116 43];
                        [417 65 116 43]};
                    

        buttonStr = {   'Save Filtered Data';
                        'Load FD'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.fig, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                        'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
        end



    
    end
    
    
%% Functions --------------------------------------------------------------
    
    function initialPlot
        
        sampleRateGuess = round(getSampleRate([fd.ts.Time, fd.ts.Data]));
        
        if sampleRateGuess < SAMPLE_RATE_SLIDER_BOUNDS(1)
            sampleRateGuess = SAMPLE_RATE_SLIDER_BOUNDS(1);
        elseif sampleRateGuess > SAMPLE_RATE_SLIDER_BOUNDS(3)
            sampleRateGuess = SAMPLE_RATE_SLIDER_BOUNDS(3);
        else
            
        end
        
        hs.hSlider_sampleRate.Value = sampleRateGuess;
        hs.hEdit_sampleRate.String = sampleRateGuess;
        
        hs.hEdit_gaussSize.String = hs.hSlider_gaussSize.Value;
        hs.hEdit_windowSize.String = hs.hSlider_windowSize.Value;
        
        hs.hEdit_lwFullPercent.String = hs.hSlider_lightweightFull.Value;
        
        hs.hEdit_filterLow.String = hs.hSlider_filterLow.Value;
        hs.hEdit_filterHigh.String = hs.hSlider_filterHigh.Value;
        hs.hEdit_filterBottom.String = hs.hSlider_filterBottom.Value;
        hs.hEdit_filterTop.String = hs.hSlider_filterTop.Value;
        
        %intitial delay correction
         hs.hLine2.XData = hs.hLine2.XData-((windowState-1)/2)/24/60/60/sampleRate;
        
    end

    function [Z, P, G] = myButter(n, W, pass)
% Digital Butterworth filter, either 2 or 3 outputs
% Jan Simon, 2014, BSD licence
% See docs of BUTTER for input and output
% Fast hack with limited accuracy: Handle with care!
% Until n=15 the relative difference to Matlab's BUTTER is < 100*eps
V = tan(W * 1.5707963267948966);
Q = exp((1.5707963267948966i / n) * ((2 + n - 1):2:(3 * n - 1)));
nQ = length(Q);
switch lower(pass)
   case 'stop'
      Sg = 1 / prod(-Q);
      c  = -V(1) * V(2);
      b  = (V(2) - V(1)) * 0.5 ./ Q;
      d  = sqrt(b .* b + c);
      Sp = [b + d, b - d];
      Sz = sqrt(c) * (-1) .^ (0:2 * nQ - 1);
   case 'bandpass'
      Sg = (V(2) - V(1)) ^ nQ;
      b  = (V(2) - V(1)) * 0.5 * Q;
      d  = sqrt(b .* b - V(1) * V(2));
      Sp = [b + d, b - d];
      Sz = zeros(1, nQ);
   case 'high'
      Sg = 1 ./ prod(-Q);
      Sp = V ./ Q;
      Sz = zeros(1, nQ);
   case 'low'
      Sg = V ^ nQ;
      Sp = V * Q;
      Sz = [];
   otherwise
      error('user:myButter:badFilter', 'Unknown filter type: %s', pass)
end
% Bilinear transform:
P = (1 + Sp) ./ (1 - Sp);
Z = repmat(-1, size(P));
if isempty(Sz)
   G = real(Sg / prod(1 - Sp));
else
   G = real(Sg * prod(1 - Sz) / prod(1 - Sp));
   Z(1:length(Sz)) = (1 + Sz) ./ (1 - Sz);
end
% From Zeros, Poles and Gain to B (numerator) and A (denominator):
if nargout == 2
   Z = G * real(poly(Z'));
   P = real(poly(P));
end

end
    
%% UI Callbacks -----------------------------------------------------------


    function sliderEventListenerCallback(~, event)

        sliderValue = round(event.AffectedObject.Value);
        
        switch event.AffectedObject.Tag
            case 'sliderGaussSize'
                targetObj = hs.hEdit_gaussSize;
            case 'sliderWindowSize'
                targetObj = hs.hEdit_windowSize;
            case 'sliderSampleRate'
                targetObj = hs.hEdit_sampleRate;
            otherwise
                % Something is super wrong
                return
        end
        
        targetObj.String = sliderValue;
        
        updateSmoothedCurve;

    end

    function editBoxCallback(hobj, ~)

        editInput = hobj.String;
        editInput = round(str2double(editInput));
        
        switch hobj.Tag
            case 'gaussSize'
                
                if editInput < GAUSSIAN_WEIGHTED_SLIDER_BOUNDS (1)
                    editInput = GAUSSIAN_WEIGHTED_SLIDER_BOUNDS(1);
                elseif editInput > GAUSSIAN_WEIGHTED_SLIDER_BOUNDS(3)
                    editInput = GAUSSIAN_WEIGHTED_SLIDER_BOUNDS(3);
                end
                
                hTarget = hs.hSlider_gaussSize;
                
            case 'windowSize'
                
                if editInput < TIME_AVERAGE_WINDOW_SLIDER_BOUNDS (1)
                    editInput = TIME_AVERAGE_WINDOW_SLIDER_BOUNDS(1);
                elseif editInput > TIME_AVERAGE_WINDOW_SLIDER_BOUNDS(3)
                    editInput = TIME_AVERAGE_WINDOW_SLIDER_BOUNDS(3);
                end
                
                hTarget = hs.hSlider_windowSize;
                
            case 'sampleRate'
                
                if editInput < SAMPLE_RATE_SLIDER_BOUNDS(1)
                    editInput = SAMPLE_RATE_SLIDER_BOUNDS(1);
                elseif editInput > SAMPLE_RATE_SLIDER_BOUNDS(3)
                    editInput = SAMPLE_RATE_SLIDER_BOUNDS(3);
                end
                
                hTarget = hs.hSlider_sampleRate;
                
            otherwise
                % What the heck happened?
                % I don't know, so I'm gonna just fail
                return
        end
        
        
        hobj.String = sprintf('%d', editInput);
        hTarget.Value = editInput;
        
        updateSmoothedCurve;
        
    end

    function delayCheckboxCallback(hobj, ~)
       
        switch hobj.Value
            case 0
                delayOn=0; 
            case 1
                delayOn=1;
        end
       
        updateSmoothedCurve;
    end
    
    function dropDownCallback(hobj, ~)
        switch hobj.Value
            case 1
                set(hs.panel_smoothing, 'Visible', 'On');
                set(hs.panel_filter, 'Visible', 'Off');
                set(hs.panel_lightweight, 'Visible', 'Off');
                set(hs.hLine2, 'Visible', 'On');
                set(hs.hLine3, 'Visible', 'Off');
                set(hs.hLine4, 'Visible', 'Off');
                
            case 2
                set(hs.panel_filter, 'Visible', 'On');
                set(hs.panel_smoothing, 'Visible', 'Off');
                set(hs.panel_lightweight, 'Visible', 'Off');
                set(hs.hLine2, 'Visible', 'Off');
                set(hs.hLine3, 'Visible', 'On');
                set(hs.hLine4, 'Visible', 'Off');
                
            case 3
                set(hs.panel_lightweight, 'Visible', 'On');
                set(hs.panel_filter, 'Visible', 'Off');
                set(hs.panel_smoothing, 'Visible', 'Off');
                set(hs.hLine2, 'Visible', 'Off');
                set(hs.hLine3, 'Visible', 'Off');
                set(hs.hLine4, 'Visible', 'On');
                
        end
    end



    function FsliderEventListenerCallback(~, event)
       
        FsliderValue = event.AffectedObject.Value;
        
        switch event.AffectedObject.Tag
            case 'sliderFilterLow'
                targetObj = hs.hEdit_filterLow;
            case 'sliderFilterHigh'
                targetObj = hs.hEdit_filterHigh;
            case 'sliderFilterBottom'
                targetObj = hs.hEdit_filterBottom;
            case 'sliderFilterTop'
                targetObj = hs.hEdit_filterTop;
            otherwise
                % Something is super wrong
                return
        end
        
        targetObj.String = FsliderValue;
        
        showFiltering;
    end

    function filterRadioPanel(~, eventdata)
        switch get(eventdata.NewValue,'Tag')
            case 'radioLow'
                 set(hs.hSlider_filterLow, 'Visible', 'On');
                 set(hs.hSlider_filterHigh, 'Visible', 'Off');
                 set(hs.hSlider_filterBottom, 'Visible', 'Off');
                 set(hs.hSlider_filterTop, 'Visible', 'Off');
                 
                 set(hs.hEdit_filterLow, 'Visible', 'On');
                 set(hs.hEdit_filterHigh, 'Visible', 'Off');
                 set(hs.hEdit_filterBottom, 'Visible', 'Off');
                 set(hs.hEdit_filterTop, 'Visible', 'Off');
                 
                 set(hs.hLabel_filterLow, 'Visible', 'On');
                 set(hs.hLabel_filterHigh, 'Visible', 'Off');
                 set(hs.hLabel_filterBottom, 'Visible', 'Off');
                 set(hs.hLabel_filterTop, 'Visible', 'Off');
                 
                 
                 
                 FradioIndicator=1;
                 showFiltering;
                 
            case 'radioHigh'
                 set(hs.hSlider_filterLow, 'Visible', 'Off');
                 set(hs.hSlider_filterHigh, 'Visible', 'On');
                 set(hs.hSlider_filterBottom, 'Visible', 'Off');
                 set(hs.hSlider_filterTop, 'Visible', 'Off');
                 
                 set(hs.hEdit_filterLow, 'Visible', 'Off');
                 set(hs.hEdit_filterHigh, 'Visible', 'On');
                 set(hs.hEdit_filterBottom, 'Visible', 'Off');
                 set(hs.hEdit_filterTop, 'Visible', 'Off');
                 
                 set(hs.hLabel_filterLow, 'Visible', 'Off');
                 set(hs.hLabel_filterHigh, 'Visible', 'On');
                 set(hs.hLabel_filterBottom, 'Visible', 'Off');
                 set(hs.hLabel_filterTop, 'Visible', 'Off');
                 
                
                 
                 FradioIndicator=2;
                 showFiltering;
                 
            case 'radioBand'
                 set(hs.hSlider_filterLow, 'Visible', 'Off');
                 set(hs.hSlider_filterHigh, 'Visible', 'Off');
                 set(hs.hSlider_filterBottom, 'Visible', 'On');
                 set(hs.hSlider_filterTop, 'Visible', 'On');
                 
                 set(hs.hEdit_filterLow, 'Visible', 'Off');
                 set(hs.hEdit_filterHigh, 'Visible', 'Off');
                 set(hs.hEdit_filterBottom, 'Visible', 'On');
                 set(hs.hEdit_filterTop, 'Visible', 'On');
                 
                 set(hs.hLabel_filterLow, 'Visible', 'Off');
                 set(hs.hLabel_filterHigh, 'Visible', 'Off');
                 set(hs.hLabel_filterBottom, 'Visible', 'On');
                 set(hs.hLabel_filterTop, 'Visible', 'On');
                 
                
                 
                 FradioIndicator=3;
                 showFiltering;
            
        end
    end

    function filterEditBoxCallback(hobj, ~)
         FeditInput = hobj.String;
        FeditInput = str2double(FeditInput);
        
        switch hobj.Tag
            case 'editFilterLow'
                
                if FeditInput < FILTER_FREQUENCY (1)
                    FeditInput = FILTER_FREQUENCY(1);
                elseif FeditInput > FILTER_FREQUENCY(3)
                    FeditInput = FILTER_FREQUENCY(3);
                end
                
                hTarget = hs.hSlider_filterLow;
            case 'editFilterHigh'
                 if FeditInput < FILTER_FREQUENCY (1)
                    FeditInput = FILTER_FREQUENCY(1);
                elseif FeditInput > FILTER_FREQUENCY(3)
                    FeditInput = FILTER_FREQUENCY(3);
                end
                
                hTarget = hs.hSlider_filterHigh;
            case 'editFilterBottom'
                 if FeditInput < FILTER_FREQUENCY (1)
                    FeditInput = FILTER_FREQUENCY(1);
                elseif FeditInput > FILTER_FREQUENCY(3)
                    FeditInput = FILTER_FREQUENCY(3);
                end
                
                hTarget = hs.hSlider_filterBottom;
            case 'editFilterTop'
                 if FeditInput < FILTER_FREQUENCY (1)
                    FeditInput = FILTER_FREQUENCY(1);
                elseif FeditInput > FILTER_FREQUENCY(3)
                    FeditInput = FILTER_FREQUENCY(3);
                end
                
                hTarget = hs.hSlider_filterTop;
            case 'editFilterOrder'
                if FeditInput < FILTER_ORDER (1)
                    FeditInput = FILTER_ORDER(1);
                elseif FeditInput > FILTER_ORDER(3)
                    FeditInput = FILTER_ORDER(3);
                end
                
                hTarget = hs.hEdit_filterOrder;
               
            otherwise     
                return       
        end
        
        hobj.String = sprintf('%d', FeditInput);
        hTarget.Value = FeditInput;
        
        showFiltering;
    end



    function lightweightRadioPanel(~, eventdata)
        switch get(eventdata.NewValue,'Tag')
            case 'radioFull'
                 set(hs.hSlider_lightweightFull, 'Visible', 'On');
                 
                 set(hs.hLabel_lightweightSliderFull, 'Visible', 'On' );
                
                 set(hs.hLabel_dataBrushHelp, 'Visible', 'Off');
                 LWradioIndicator=1;
                 
                 
            case 'radioDataBrush'
                 set(hs.hSlider_lightweightFull, 'Visible', 'On');
                 
                 
                 set(hs.hLabel_lightweightSliderFull, 'Visible', 'On' );
                 set(hs.hLabel_dataBrushHelp, 'Visible', 'On');
                 LWradioIndicator=2;
                 
                 brush on;
                 
                 
                 
          
                 
            case 'radioTime'
                 set(hs.hSlider_lightweightFull, 'Visible', 'On');
                 
                 set(hs.hEdit_lwStartTime, 'Visible', 'On');
                 set(hs.hEdit_lwEndTime, 'Visible', 'On');
                 
                 set(hs.hLabel_lightweightSliderFull, 'Visible', 'On' );
                 set(hs.hLabel_lwFrom, 'Visible', 'On' );
                 set(hs.hLabel_lwTo, 'Visible', 'On' );
                 set(hs.hLabel_dataBrushHelp, 'Visible', 'Off');
                 LWradioIndicator=3;
                
        end
    end

    function lightweightEditBoxCallback(hobj, ~)
        
        LWeditInput = hobj.String;
        LWeditInput = round(str2double(LWeditInput));
        
        switch hobj.Tag
            case 'lwFullPercent'
                
                if LWeditInput < DECIMATION_PERCENTAGE (1)
                    LWeditInput = DECIMATION_PERCENTAGE(1);
                elseif LWeditInput > DECIMATION_PERCENTAGE(3)
                    LWeditInput = DECIMATION_PERCENTAGE(3);
                end
                
                hTarget = hs.hSlider_lightweightFull;
            case 'lwStartTime'
                 if LWeditInput < fd.ts.Time(1)
                    LWeditInput = fd.ts.Time(1);
                elseif LWeditInput > fd.ts.Time(length(fd.ts.Time))
                    LWeditInput = fd.ts.Time(length(fd.ts.Time));
                end
            case 'lwEndTime'
               if LWeditInput < fd.ts.Time(1)
                    LWeditInput = fd.ts.Time(1);
                elseif LWeditInput > fd.ts.Time(length(fd.ts.Time))
                    LWeditInput = fd.ts.Time(length(fd.ts.Time));
                end
            otherwise     
                return       
        end
        
        hobj.String = sprintf('%d', LWeditInput);
        hTarget.Value = LWeditInput;
        
        showLightweight;
    end

    function lightweightButtonCallback(~,~)
        applyLightweight;
    
    end

    function LWsliderEventListenerCallback(~, event)
        
        LWsliderValue = round(event.AffectedObject.Value);
        
        switch event.AffectedObject.Tag
            case 'sliderLightweightFull'
                targetObj = hs.hEdit_lwFullPercent;
     
            otherwise
                % Something is super wrong
                return
        end
        
        targetObj.String = LWsliderValue;
        
        showLightweight;
    end



    function fourierButtonCallback(~,~)
        freqData= abs(fft(hs.hLine5.YData));
        figure
        
        %freqData= make this equal the current stuff
        plot(freqData)
        
        %plot first half of DFT (normalised frequency)
        num_bins = length(freqData);
        plot(0:1/(num_bins/2 -1):1, freqData(1:num_bins/2));
        title('Fourier Frequency Transform : Noisy Signal')
        xlabel('Normalised frequency (\pi rads/sample)')
        ylabel('Magnitude');
        
    end

    

   
%% Signal Processing ------------------------------------------------------

    function smoothData = applySmoothing(ts)
        
       gaussian   = round(hs.hSlider_gaussSize.Value);
       sampleRate = round(hs.hSlider_sampleRate.Value);
       window_size     = round(hs.hSlider_windowSize.Value);
        
        % Define the number of points to use for a simple moving average
         window = sampleRate * window_size;
       
        
       
        %% Binomial expansion using filter() function. Large values of "gaussian" approximate a normal curve.
        if gaussian>0
            h = [1/2 1/2];
            for n = 1:gaussian 
                binomialCoeff = conv(h,h);
            end
            weightedData = filter(binomialCoeff, 1, ts.Data);
        else
            weightedData=ts.Data;
        end

       %delay correction setting
      % mDelay=((window-1)/2)/24/60/60/10;


        %% Custom moving average method. Averaging window begins at the element and moves backwards (asymmetric). 
        %  Clips window size if window hits the first element. 
       
        newData=ones(size(weightedData));
        for i=1:length(weightedData)
            windowTooBig=0;
            sum=0;
            for j=0:(window-1)


                if (i-j) < 1
                    % window hits the beginning of the data array. Set flag and stop
                    % adding to the sum
                windowTooBig=windowTooBig+1;

                else
                    % window is fitting in the data array. Sum up elements for
                    % averaging 
                sum = sum+ weightedData(i-j);

                end


                if windowTooBig>0
                    %calculate average for clipped window
                    avg=sum/(window-windowTooBig);
                else
                    %window fit fine
                avg=sum/window;
                end

            end
            
                newData(i)=avg;
            
        end
        %End moving average method
        
        smoothData=newData;
        
    end


    function showFiltering()
        
        switch FradioIndicator
            case 1
                [b,a] = myButter(hs.hEdit_filterOrder.Value,hs.hSlider_filterLow.Value,'low');
            case 2
                [b,a] = myButter(hs.hEdit_filterOrder.Value,hs.hSlider_filterHigh.Value,'high');
            case 3
                [b,a] = myButter(hs.hEdit_filterOrder.Value,[hs.hSlider_filterBottom.Value hs.hSlider_filterTop.Value],'bandpass');
        end
        
        hs.hLine3.YData=filter(b,a,hs.hLine5.YData);
        filteredY=hs.hLine3.YData;
        
  

        
         %IF delay is on and just window size changes, fix delay correction
        if  hs.hEdit_filterOrder.Value ~= FOState
            hs.hLine2.XData=hs.hLine2.XData+((FOState-1)/2)/24/60/60/sampleRate;
            hs.hLine2.XData=hs.hLine2.XData-((hs.hEdit_filterOrder.Value-1)/2)/24/60/60/sampleRate;
            FOState=hs.hEdit_filterOrder.Value;
        end
        
        

    end

    function applyFiltering(~,~)
        hs.hLine5.YData=filteredY;
        
        set(hs.hLine5, 'Visible', 'On');
        set(hs.hLine1, 'Visible', 'Off');
        
    end


    function showLightweight()
        
        switch LWradioIndicator
            case 1
        percentDecimation = round(hs.hSlider_lightweightFull.Value);
        currentTS=fd.ts;
        newTS=fd.ts;
        dataSize=length(currentTS.Data);

        
 %       percentDecimation=90;
newDataSize=ceil(((100-percentDecimation)/100)*dataSize);
pointsToBeRemoved=dataSize-newDataSize;
        roughPeriod=dataSize/pointsToBeRemoved;
%flagValue=(max(ts.Data)+1);

% Start Timing
%tic;

% i=2;
% iTrue=i;
% 
% while i<dataSize 
%     newTS.Data(i)=flagValue;
%     iTrue=iTrue+roughPeriod;
%     i=round(iTrue);
% end
% 
% 
% newLength=length(newTS.Data);
% j=1;
% while j<newLength+1
%     if newTS.Data(j)==flagValue
%         newTS=delsample(newTS,'Index',j);
%         newLength=length(newTS.Data);
%     else
%         j=j+1;
%     end
% end

toKillIndex = round(2:roughPeriod:length(currentTS.Data)-1);
newTS=delsample(newTS,'index', toKillIndex);

        lightweightY=newTS.Data;
        lightweightX=newTS.Time;
         hs.hLine4.YData = newTS.Data;
         hs.hLine4.XData = newTS.Time;
            case 2
            %do nothing
                
        end
        
        
    end

    function applyLightweight()
        switch LWradioIndicator
            case 1
                hs.hLine5.YData=lightweightY;
                hs.hLine5.XData=lightweightX;
        set(hs.hLine5, 'Visible', 'On');
        set(hs.hLine1, 'Visible', 'Off');
            
            case 2
                
        percentDecimation = round(hs.hSlider_lightweightFull.Value);
        newTS=fd.ts;
        
               brushedData=evalin('base', 'brushedData');
                if ~ isempty(brushedData)
                    dataSize=length(brushedData(:,2));
                    newDataSize=ceil(((100-percentDecimation)/100)*dataSize);
                    pointsToBeRemoved=dataSize-newDataSize;
                    roughPeriod=dataSize/pointsToBeRemoved;
                    [~, loc]=ismember(brushedData(:,1), newTS.Time);
                    startPoint=loc(2);
                    endPoint=loc(length(loc)-1);
                    toKillIndex = round(startPoint:roughPeriod:endPoint);
                    newTS=delsample(newTS,'index', toKillIndex);
                    
                    lightweightY=newTS.Data;
                    lightweightX=newTS.Time;
                    hs.hLine4.YData = newTS.Data;
                    hs.hLine4.XData = newTS.Time;
                     
                else
                end
             
                
                brushedData=[];
            
            
        end
        
    end

   
    function updateSmoothedCurve
       
        hs.hLine2.YData = applySmoothing(fd.ts);
        
        
        %IF delay is on and just window size changes, fix delay correction
        if delayOn==1 && delayOn==delayState && window ~= windowState
            hs.hLine2.XData=hs.hLine2.XData+((windowState-1)/2)/24/60/60/sampleRate;
            hs.hLine2.XData=hs.hLine2.XData-((window-1)/2)/24/60/60/sampleRate;
            windowState=window;
        end
        
        %Then, IF just delay correction is turned off...
        if delayOn==0 && delayOn~=delayState
            hs.hLine2.XData=hs.hLine2.XData+((window-1)/2)/24/60/60/sampleRate;
            
            delayState=delayOn;
        end
        
       %Also IF delay is off but turned back on...
      if delayOn==1 && delayOn~=delayState
           hs.hLine2.XData=hs.hLine2.XData-((window-1)/2)/24/60/60/sampleRate;
           delayState=delayOn;
       end
        
        
       
    end


%% File Handling ----------------------------------------------------------


    function saveFilteredData(~, ~)
        fd.ts.Data=hs.hLine5.YData;
        fd.ts.Time=hs.hLine5.XData;
        switch hs.popup.String{hs.popup.Value}
            case 'Smooth Data'
                filterKind_str = 'Smoothed';
            case 'Filter Data'
                filterKind_str = 'Filtered';
            case 'Make Lightweight'
                filterKind_str = 'Lightweight';
            otherwise
                % Invalid popup selection - did the programmer screw up the
                % strings and break this switch statement?
                warning('Invalid popup selection. Nothing to do for given selection');
                return
        end
        
        newEnding_str = [' - ', filterKind_str];
        
        fd.ts.Name = strcat(fd.ts.Name, newEnding_str);
        fd.FullString = strcat(fd.FullString, newEnding_str);
        
        newfileName_str =     [fileName_str, newEnding_str];
        newFileNameFullFile = fullfile(dataFile_path, [newfileName_str, extension_str]);
        
        [saveFile_str, savePath] = uiputfile(newFileNameFullFile, ['Save ', filterKind_str, ' Data File']);
        
        if saveFile_str == 0
            % User cancelled file save operation
            return
        end
        
        save(fullfile(savePath, saveFile_str), 'fd', '-mat');

    end


    function loadDataFile(~, ~)
        
        % If called from GUI, this executes. Otherwise, it's because of a
        % fullfile passed to the main function on launch. 
        % If no arguments are passed, it skips the uigetfile routine
        if nargin
            % Define paths from config structure
            % delimPath = '~/Documents/MATLAB/Data Review/ORB-2/delim';
            dataPath = config.workingDataPath;
            loadFilePath = fullfile(dataPath, '..');

            [loadFileName_str, loadFilePath] = uigetfile( {...
                            '*.mat', 'MDRT Data File'; ...
                            '*.*',     'All Files (*.*)'}, ...
                            'Pick a file', fullfile(loadFilePath, '*.mat'));

            if isnumeric(loadFileName_str)
                % User cancelled .delim pre-parse
                disp('User cancelled .delim pre-parse');
                return
            end
            
            % Load file and get FD variable!!!
    
            fdDataFullFile = fullfile(loadFilePath, loadFileName_str);
 
        end
        
       
        [dataFile_path, fileName_str, extension_str] = fileparts(fdDataFullFile);
        dataFileName_str = strcat(fileName_str, extension_str);
        
        listOfVariables = who('-file', fdDataFullFile);
        if ismember('fd', listOfVariables)
            s = load(fdDataFullFile, '-mat', 'fd');
            fd = s.fd;
        else
            % FD variable not in selected file
            warndlg('Selected file does not contain MDRT data');
        end
        
        hs.hLine1.XData = fd.ts.Time;
        hs.hLine1.YData = fd.ts.Data;
        
        hs.hLine2.XData = fd.ts.Time;
        hs.hLine2.YData = fd.ts.Data;
        
        updateSmoothedCurve;
        
        hs.ax.Title.String = strcat('Time Series Plot:', fd.ts.Name);

        hs.ax.XLim = [min(fd.ts.Time), max(fd.ts.Time)];
        hs.ax.YLim = [min(fd.ts.Data), max(fd.ts.Data)];
    end
    

end