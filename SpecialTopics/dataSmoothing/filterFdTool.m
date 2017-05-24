% filterFD  Launches a GUI tool for data smoothing and filtering
     %         filterFD() Launches the tool in demo mode with dummy data.
     %         filterFD(fullFile) launches the tool and loads the contents
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
     
     
function filterFdTool(fdDataFullFile)
% This is the main function for the data smoothing tool. This function
% defines constants, instantiates "shared" (ugh, I know it's global state 
% and that's bad) variables, calls the GUI generating function, and handles
% the input cases (file passed, nothing passed). The graphics area is
% populated.


    fd = newFD;
    config = MDRTConfig.getInstance;
    hs = struct();

    %% Constant Definitions

    % Slider Bounds [min default max]
        GAUSSIAN_WEIGHTED_SLIDER_BOUNDS     = [1 100 1000];
        TIME_AVERAGE_WINDOW_SLIDER_BOUNDS   = [1 10    60];
        SAMPLE_RATE_SLIDER_BOUNDS           = [1 80   100];

    % Create the tool GUI and all handles
        createSmoothingGUI();


%% Initial Conditions for testing!!!


    % Always populate the fd struct with test data when the fuction is
    % first run. That way we can cancel file loads and still have valid
    % data.
    
    t = floor(now) + 0.5 : 1/24/60/60/10 : floor(now) + 0.75;
    y = awgn( sin(t * 24), 25);

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
                warn('Attempted to open a file that does not exist');% Call file loading function since no file was passed
                loadDataFile();
            end
            
            % Call file loading function since no file was passed
            loadDataFile();
        
        otherwise
            
    end
    
    
    
        



    fdDataFullFile = fullfile(getuserdir(), 'Example-Signal.mat');
    [dataFile_path, fileName_str, extension_str] = fileparts(fdDataFullFile);
    dataFileName_str = strcat(fileName_str, extension_str);




    
    
%% Initial Plotting


        % hs.hLine1 = reduce_plot(fd.ts, '-b', 'DisplayName', 'Original');
        hs.hLine1 = plot(fd.ts, '-b', 'DisplayName', 'Original');
            dynamicDateTicks;


        hold on
        hs.hLine2 = plot(fd.ts.Time, fd.ts.Data, '-g', 'DisplayName', 'Filtered');

        initialPlot();
    
%% UI Creation and hs population ------------------------------------------
    
    function createSmoothingGUI()    
    

    %% Figure Properties

        fig = figure;

            fig.Resize = 'off';
            fig.Units = 'pixels';
            fig.Position(3:4) = [560 420];
            fig.NumberTitle = 'off';
            fig.Name = 'Data Smoothing Tool';
        %     fig.Name = strcat('Data Smoothing Tool: ', ts.Name);
            fig.ToolBar = 'figure';
            fig.MenuBar = 'none';

            % Customize Toolbar
            buttonsToDisable = {    'Standard.EditPlot';
                                    'Standard.PrintFigure';
                                    'Standard.SaveFigure';
                                    'Standard.FileOpen';
                                    'Standard.NewFigure';
                                    'Exploration.DataCursor';
                                    'Plottools.PlottoolsOn';
                                    'Plottools.PlottoolsOff';
                                    'Exploration.Rotate';
                                    'Annotation.InsertColorbar';
                                    'DataManager.Linking'};

    %                                 'Exploration.Pan';
    %                                 'Exploration.ZoomOut';
    %                                 'Exploration.ZoomIn';
    %                                 'Annotation.InsertLegend';

    for i = 1:numel(buttonsToDisable)
        tObj = findall(fig, 'Tag', buttonsToDisable{i});

        tObj.Visible = 'off';
    end


        hs.fig = fig;

    %% Axes Properties

        hs.ax           = axes('Parent', hs.fig);
        hs.ax.Units     = 'pixels';
        hs.ax.Position  = [35 163 501 238];    


    %% Panel Properties

        panelName = 'Filter Controls';
        panelUnits = 'pixels';
        panelPosition = [0 0 559 150];

        hs.panel = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition);

    %% Dropdown Properties

        dropdownContents = {    'Smooth Data';
                                'Filter Data';
                                'Make Lightweight' };

        dropdownUnits = 'pixels';
        % dropdownPos   = [ 0.1 0.1 0.5 0.5];
        dropdownPos   = [410 110 140 027];


        hs.popup = uicontrol(hs.panel, 'Style', 'popup', ...
                        'Units',        dropdownUnits, ...
                        'Position',     dropdownPos, ...
                        'String',       dropdownContents,...
                        'Value',        1);


    %% Edit Boxes

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
            hs.(editHandles{i}) = uicontrol('Parent', hs.panel, ...
                        'Style',        'edit', ...
                        'Units',        'pixels', ...
                        'Position',     editPos{i}, ...
                        'Tag',          editTag{i}, ...
                        'Callback',     @editBoxCallback);
        end


    %% Sliders

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
            hs.(sliderHandles{i}) = uicontrol('Parent', hs.panel, ...
                        'Style',        'slider', ...
                        'Units',        'pixels', ...
                        'Position',     sliderPos{i}, ...
                        'Min',          sliderParams{i}(1), ...
                        'Max',          sliderParams{i}(3),...
                        'Value',        sliderParams{i}(2), ...
                        'Tag',          sliderTag{i});
        end

        hs.listenGSSlider = addlistener(hs.hSlider_gaussSize,  'Value', 'PostSet',@sliderEventListenerCallback);
        hs.listenWSSlider = addlistener(hs.hSlider_windowSize, 'Value', 'PostSet',@sliderEventListenerCallback);
        hs.listenSRSlider = addlistener(hs.hSlider_sampleRate, 'Value', 'PostSet',@sliderEventListenerCallback);

    %% Labels

        textHandles = { 'hLabel_gaussWindow';
                        'hLabel_timeAvgWindow';
                        'hLabel_sampleRate' };

        textPos =   {   [11 107 375 13];
                        [10 70 375 13];
                        [10 31 375 13]};

        textStr =   {   'Gaussian Window Size (points)';
                        'Time Average Window (seconds)';
                        'Data Sample Rate (Hz)'};

        for i = 1:numel(sliderHandles)
            hs.(textHandles{i}) = uicontrol('Parent', hs.panel, ...
                        'Style',        'text', ...
                        'Position',     textPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       textStr{i} );
        end


    %% Button

        buttonHandles =	{   'hButton_save';
                            'hButton_load'};

        buttonFuncs  =  {   @saveFilteredData;
                            @loadDataFile };

        buttonPos = {   [417 20 116 43];
                        [417 65 116 43]};

        buttonStr = {   'Save Filterd Data';
                        'Load FD'};

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                        'Callback',     buttonFuncs{i} );
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

    
%% Signal Processing ------------------------------------------------------


    function smoothData = applySmoothing(ts)
        
        gaussWindowPoints   = round(hs.hSlider_gaussSize.Value);
        sampleRate          = round(hs.hSlider_sampleRate.Value);
        timeAverageSeconds  = round(hs.hSlider_windowSize.Value);
        
        % Define the number of points to use for a simple moving average
        window_size = sampleRate * timeAverageSeconds;

        % build the gaussian window for a weighted moving average
        semi_gaussian = gausswin(gaussWindowPoints)';
        semi_gaussian = [semi_gaussian fliplr(semi_gaussian)];

        % Calculate the weighted moving average (with the gaussian weight)
        weighted = tsmovavg(ts.Data,'w',semi_gaussian,1);
        
        % Calculate the simple moving average
        
        smoothData = tsmovavg(weighted,'s',window_size,1);

    end

    function updateSmoothedCurve
        
        hs.hLine2.YData = applySmoothing(fd.ts);
        
    end


%% File Handling ----------------------------------------------------------


    function saveFilteredData(~, ~)
        
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