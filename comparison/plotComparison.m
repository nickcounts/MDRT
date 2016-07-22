function [ output_args ] = plotComparison( bh, eventdata )
%plotComparison 
%
%

filename = 'timeline.mat';

%% Load important information from GUI and appdata



    mdrt = getappdata(bh.Parent);

    el1 = findobj(bh.Parent,'tag','eventList1');
    el2 = findobj(bh.Parent,'tag','eventList2');

    tpul = findobj(bh.Parent, 'Tag', 'opList1');
    bpul = findobj(bh.Parent, 'Tag', 'opList2');
    
    hpteb = findobj(bh.Parent,'tag','plotTitle');






%% Instantiate blank comparisonGraph structure

    CG = newComparisonGraph;

        CG.Title = hpteb.String;
        
%% Make top and bottom plot data file lists


        CG.topPlot = mdrt.topPlot;
        CG.botPlot = mdrt.botPlot;

    %Filter out FDs from the wrong data sets         

        % Check Top FD list

            dataSet = tpul.Value;

            goodFdIndex = cell2mat(mdrt.topPlot(:,3)) == dataSet;

            filenames = mdrt.topPlot(goodFdIndex,2);
            fullFileNames = fullfile(mdrt.dataIndex(dataSet).pathToData,filenames);
            
            % Store in structure!
            CG.topPlot = fullFileNames;
            CG.topMetaData = mdrt.dataIndex(dataSet).metaData;

        % Check Bottom FD list

            dataSet = bpul.Value;

            goodFdIndex = cell2mat(mdrt.botPlot(:,3)) == dataSet;

            filenames = mdrt.botPlot(goodFdIndex,2);
            fullFileNames = fullfile(mdrt.dataIndex(dataSet).pathToData,filenames);
            
            % Store in structure!
            CG.botPlot = fullFileNames;
            CG.botMetaData = mdrt.dataIndex(dataSet).metaData;

            
            
            
%% Store Timeline (top)
    % Check that a timeline file exists!
    if exist(fullfile(mdrt.dataIndex(tpul.Value).pathToData, filename),'file')
        load(fullfile(mdrt.dataIndex(tpul.Value).pathToData, filename))

        CG.topTimeline = timeline;

    else
        % No timeline data found
        CG.topTimeline = [];
        
    end

%% Store Timeline (bottom)
    % Check that a timeline file exists!
    if exist(fullfile(mdrt.dataIndex(bpul.Value).pathToData, filename),'file')
        load(fullfile(mdrt.dataIndex(bpul.Value).pathToData, filename))

        CG.botTimeline = timeline;

    else
        % No timeline data found
        CG.botTimeline = [];
        
    end

        
%% Calculate time shift and store in structure

    deltaT = mdrt.eventTimes1(el1.Value) - mdrt.eventTimes2(el2.Value);
    
    debugout( sprintf('bottom plot is timeshifted: %f', deltaT))

    if isempty(deltaT)
        CG.bottomTimeShift = 0;
    else
        CG.bottomTimeShift = deltaT;
    end


    plotComparisonFromStruct(CG);
    
end

