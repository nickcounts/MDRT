%8-10-17
     %J. Singh, VCSFA
     %Tool designed to simulate EREG time domain responses.
     %Currently only loaded with ER5531 data. See "Documentation" Panel


function PIDSimulator
%% Constant Definitions

    % Slider/Value Bounds [min default max]
        P_Value   = [0 1500 30000];
        I_Value   = [0 200 1000];
        D_Value   = [0 150 500];
        psi_range = [0 100];
        start_psi =0;
        end_psi = 10;
        
        
    % Initialize important variables 
        
        hs = struct();
        factor=1;
        Kp=1500;
        Ki=200;
        Kd=200;
      %  num=[];
      %  den=[];
        num=[(0.01002*Kd) (0.01002*Kp) (0.01002*Ki)];
        den=[(1) (0.01002*Kd+9.9985) (0.01002*Kp+1.31832) (0.01002*Ki-0.002002)];
        sys = tf(num,den);
        
        
    % Create the tool GUI and all handles
        createPIDGUI();


%% Initial Conditions

hs.hEdit_P.String=Kp;
hs.hEdit_I.String=Ki;
hs.hEdit_D.String=Kd;
hs.hEdit_Set1.String=start_psi;
hs.hEdit_Set2.String=end_psi;


    

%% Initial Plotting


        % hs.hLine1 = reduce_plot(fd.ts, '-b', 'DisplayName', 'Original');
    %    original_fd_ts=fd.ts;
    %    hs.hLine1 = plot(original_fd_ts, '-k', 'DisplayName', 'Original');
       % dynamicDateTicks;
     %   hold on  
     %   hs.hLine2 = plot(fd.ts.Time, fd.ts.Data, '-r', 'DisplayName', 'Smoothed');
        
       
        
        
        responsePlot();
        
        
    %% General Functions
    
    function createPIDGUI()
         fig = figure;

            fig.Resize = 'on';
            fig.Units = 'pixels';
            fig.Position = [380 159 853 599];
            fig.NumberTitle = 'off';
            fig.Name = 'PID Simulation';
            fig.ToolBar = 'figure';
            
            hs.fig=fig;
            
%% Axes
        hs.ax           = axes('Parent', hs.fig);
        hs.ax.Units     = 'pixels';
        hs.ax.Position  = [40 305 800 285];  
        hs.ax.Units     = 'Normalize';
        
        
    %    hs.ax.Title     = 'System Response';
        
%% System Management Panel Properties

        panelName = 'System Management';
        panelUnits = 'pixels';
        panelPosition = [15 75 253 175];

        hs.panel_systemManagement = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize');
             
%% System Management Buttons

buttonHandles =	{   'hButton_addNewSystem';
                    'hButton_editDeleteSystem'};

        buttonFuncs  =  {   @addNewSystemButtonCallback;
                            @editDeleteSystemButtonCallback};
                            

        buttonPos = {   [28 55 182 32];
                        [28 17 182 32]};
                    

        buttonStr = {   'Add New System';
                        'Edit/Delete System'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel_systemManagement, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                     'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
        end
       
 %% System Management Dropdown

        dropdownContents = {    'ER5531'; };

        dropdownUnits = 'pixels';
        dropdownPos   = [35 95 162 29];


        hs.popupSM = uicontrol(hs.panel_systemManagement, 'Style', 'popup', ...
                        'Units',        dropdownUnits, ...
                        'Position',     dropdownPos, ...
                        'String',       dropdownContents,...
                        'Value',        1,...
                        'Units',        'Normalize',...
                        'Callback',     @dropDownSMCallback);
                    
%% System Management Static Text
 
        textHandles = { 'hLabel_selectSystem'};

        textPos =   {   [35 125 159 20]};

        textStr =   {   'Select System'};

        for i = 1:numel(textHandles)
            hs.(textHandles{i}) = uicontrol('Parent', hs.panel_systemManagement, ...
                        'Style',        'text', ...
                        'Position',     textPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       textStr{i}, ...
                        'Units',        'Normalize');
        end
%% Modeling Panel Properties

        panelName = 'Modeling Apps';
        panelUnits = 'pixels';
        panelPosition = [275 75 162 175];

        hs.panel_modelingApps = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize');
                    
                    
 %% Modeling Buttons
                    
buttonHandles =	{   'hButton_PIDDesignApp';
                    'hButton_systemIdentification'};

        buttonFuncs  =  {   @PIDDesignAppButtonCallback;
                            @systemIdentificationButtonCallback};
                            

        buttonPos = {   [15 90 118 45];
                        [15 25 118 45]};
                    

        buttonStr = {   'PID Design App';
                        'System Identification'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel_modelingApps, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                     'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
        end
        

%% Simulation Panel Properties

        panelName = 'Simulation';
        panelUnits = 'pixels';
        panelPosition = [450 75 387 175];

        hs.panel_simulation = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize');
                    
%% Simulation Sliders

        sliderHandles = {   'hSlider_P';
                            'hSlider_I';
                            'hSlider_D'};

        sliderPos =     {   [20 130 164 22];
                            [20 100 164 22];
                            [20 70 164 22]};

        sliderParams =  {   P_Value;
                            I_Value;
                            D_Value };

        sliderTag   = { 'sliderP';
                        'sliderI';
                        'sliderD'};

        for i = 1:numel(sliderHandles)
            hs.(sliderHandles{i}) = uicontrol('Parent', hs.panel_simulation, ...
                        'Style',        'slider', ...
                        'Units',        'pixels', ...
                        'Position',     sliderPos{i}, ...
                        'Min',          sliderParams{i}(1), ...
                        'Max',          sliderParams{i}(3),...
                        'Value',        sliderParams{i}(2), ...
                        'Tag',          sliderTag{i},...
                        'Units',        'Normalize');
        end

        hs.listenGSSlider = addlistener(hs.hSlider_P,  'Value', 'PostSet',@PIDsliderEventListenerCallback);
        hs.listenWSSlider = addlistener(hs.hSlider_I, 'Value', 'PostSet',@PIDsliderEventListenerCallback);
        hs.listenSRSlider = addlistener(hs.hSlider_D, 'Value', 'PostSet',@PIDsliderEventListenerCallback);

        
 %% Simulation Labels

        textHandles = { 'hLabel_P';
                        'hLabel_I';
                        'hLabel_D' ;
                        'hLabel_Setpoint1';
                        'hLabel_Setpoint2';
                        'hLabel_To'};

        textPos =   {   [260 130 72 22];
                        [260 100 72 22];
                        [260 70 72 22];
                        [25 12 84 17];
                        [151 12 84 17];
                        [100 38 51 14]};

        textStr =   {   'P Term';
                        'I Term';
                        'D Term';
                        'Setpoint #1 (psi)';
                        'Setpoint #2 (psi)';
                        'To'};

        for i = 1:numel(textHandles)
            hs.(textHandles{i}) = uicontrol('Parent', hs.panel_simulation, ...
                        'Style',        'text', ...
                        'Position',     textPos{i}, ...
                        'HorizontalAlignment', 'center', ...
                        'String',       textStr{i}, ...
                        'Units',        'Normalize');
        end        
        
%% Simulation Edit Boxes

        editHandles = { 'hEdit_P';
                        'hEdit_I';
                        'hEdit_D';
                        'hEdit_Set1';
                        'hEdit_Set2'};

        editPos     = { [205 130 60 22];
                        [205 100 60 22];
                        [205 70 60 22];
                        [32 30 68 25];
                        [158 30 68 25]};

        editTag     = { 'editP';
                        'editI';
                        'editD';
                        'edit1';
                        'edit2'};

        for i = 1:numel(editHandles)
            hs.(editHandles{i}) = uicontrol('Parent', hs.panel_simulation, ...
                        'Style',        'edit', ...
                        'Units',        'pixels', ...
                        'Position',     editPos{i}, ...
                        'Tag',          editTag{i}, ...
                        'Units',        'Normalize', ...
                        'Callback',     @editBoxCallback);
        end
        
%% Simulation Buttons

        buttonHandles =	{   'hButton_stepResponse';
                            'hButton_impulse'};

        buttonFuncs  =  {   @responsePlot;
                            @impulsePlot};
                            

        buttonPos = {   [250 35 124 27];
                        [250 5 124 27]};
                    

        buttonStr = {   'Step Response';
                        'Impulse Response'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel_simulation, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                     'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
        end
%% Documentation Panel Properties

        panelName = 'Documentation';
        panelUnits = 'pixels';
        panelPosition = [0 1 853 67];

        hs.panel_documentation = uipanel(hs.fig, ...
                        'Title',        panelName, ...
                        'Units',        panelUnits, ...
                        'Position',     panelPosition, ...
                        'Units',        'Normalize');
                    
%% Documentation Buttons

        buttonHandles =	{   'hButton_MARSSim';
                            'hButton_userManual'};

        buttonFuncs  =  {   @MARSDocument;
                            @UserManual};
                            

        buttonPos = {   [22 17 116 32];
                        [150 17 116 32]};
                    

        buttonStr = {   'MARS PID Simulation';
                        'ER5000 User Manual'};
                        

        for i = 1:numel(buttonHandles)
            hs.(buttonHandles{i}) = uicontrol('Parent', hs.panel_documentation, ...
                        'Style',        'pushbutton', ...
                        'Position',     buttonPos{i}, ...
                        'String',       buttonStr{i}, ...
                     'Callback',     buttonFuncs{i}, ...
                        'Units',         'Normalize');
        end
    end

    function responsePlot(~,~)
        
       Kp     = round(hs.hSlider_P.Value);
       Ki     = round(hs.hSlider_I.Value);
       Kd     = round(hs.hSlider_D.Value);
       num=[(0.01002*Kd) (0.01002*Kp) (0.01002*Ki)];
       den=[(1) (0.01002*Kd+9.9985) (0.01002*Kp+1.31832) (0.01002*Ki-0.002002)];
       
       sys = tf(num,den);
       factor = end_psi-start_psi;
       opt = stepDataOptions('InputOffset',start_psi,'StepAmplitude',factor);
       step(sys,opt);
       title('EREG Setpoint Change Response');
       ylabel('Feedback (psi)');
    end
        
    function impulsePlot(~,~)
        
       Kp     = round(hs.hSlider_P.Value);
       Ki     = round(hs.hSlider_I.Value);
       Kd     = round(hs.hSlider_D.Value);
       num=[(0.01002*Kd) (0.01002*Kp) (0.01002*Ki)];
       den=[(1) (0.01002*Kd+9.9985) (0.01002*Kp+1.31832) (0.01002*Ki-0.002002)];
       
       sys = tf(num,den);
       impulse(sys);
       title('EREG Impulse Response');
       ylabel('Feedback (psi)');
    end
        
%% UI Callbacks
        
    function PIDsliderEventListenerCallback(~,event)
        sliderValue = round(event.AffectedObject.Value);
        switch event.AffectedObject.Tag
            case 'sliderP'
                targetObj = hs.hEdit_P;
            case 'sliderI'
                targetObj = hs.hEdit_I;
            case 'sliderD'
                targetObj = hs.hEdit_D;
            otherwise
                % Something is super wrong
                return
        end
        
        targetObj.String = sliderValue;
        
        
        
    end

    function editBoxCallback(hobj, ~)

        editInput = hobj.String;
        editInput = round(str2double(editInput));
        
        switch hobj.Tag
            case 'editP'
                
                if editInput < P_Value (1)
                    editInput = P_Value(1);
                elseif editInput > P_Value(3)
                    editInput = P_Value(3);
                end
                
                hTarget = hs.hSlider_P;
                
            case 'editI'
                
                if editInput < I_Value (1)
                    editInput = I_Value(1);
                elseif editInput > I_Value(3)
                    editInput = I_Value(3);
                end
                
                hTarget = hs.hSlider_I;
                
            case 'editD'
                
                if editInput < D_Value(1)
                    editInput = D_Value(1);
                elseif editInput > D_Value(3)
                    editInput = D_Value(3);
                end
                
                hTarget = hs.hSlider_D;
                
            case 'edit1'
                if editInput < psi_range(1)
                    editInput = psi_range(1);
                elseif editInput > psi_range(2)
                    editInput = psi_range(2);
                end
                
                start_psi = editInput;
                
            case 'edit2'
                if editInput < psi_range(1)
                    editInput = psi_range(1);
                elseif editInput > psi_range(2)
                    editInput = psi_range(2);
                end
                
                end_psi = editInput;
                
            otherwise
                
                return
        end
        
        
        hobj.String = sprintf('%d', editInput);
        hTarget.Value = editInput;
        
        
        
    end

    function PIDDesignAppButtonCallback(~,~)
        pidTuner;
    end

    function systemIdentificationButtonCallback(~,~)
        systemIdentification;
    end

    function addNewSystemButtonCallback(~,~)
              %do something (bring up a new window, probably) to add a new system and have its name added to the system dropdown menu              
    end

    function editDeleteSystemButtonCallback(~,~)
        %do something to edit or a delete a system (probably bring up a new
        %window again)
    end

    function MARSDocument(~,~)
        web('https://github.com/nickcounts/MDRT/blob/master/MARS_PIDSimulationDocumentation.docx')
    end

    function UserManual(~,~)
        web('https://github.com/nickcounts/MDRT/blob/master/ER5000.pdf')
    end
        
end