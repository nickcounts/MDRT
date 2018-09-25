function MDRTbrushMenu(hobj, event)
% MDRTbrushMenu
% 
% MDRTbrushMenu(hobj, event) is launched by a menu item in MDRTPlot's
% 'Advanced' menu. It hooks into Matlab's data brushing and populates a
% small stand-alone gui with basic trend information about the highlighted
% data. 
%
% There is no support for brushing over multiple lines and stability is not
% guaranteed.
%
% This is an early release of a planned feature upgrade.

% Counts, VCSFA 2017


    hs.parent = gcf;

% #################################################
%             GUI Figure Generation
% #################################################

    hs.fig = figure;

                hs.fig.Name = 'MDRT Data Analysis Tool';
                hs.fig.NumberTitle = 'off';
                hs.fig.MenuBar = 'none';
                hs.fig.ToolBar = 'none';
                hs.fig.Tag = 'importFigure';
                hs.fig.Position(3:4) = [251, 391];
                hs.fig.Resize = 'off';
                hs.fig.CloseRequestFcn = @CloseOverride;
                

% #################################################
%             GUI UI Control Parameters
% #################################################

    textPos = { [11 323 72 13];
                [11 288 72 13];
                [11 253 72 13];
                [11 218 72 13];
                [11 183 72 13];
                [11 148 72 13]; };

    textStr = { 'Start Time';
                'End Time';
                'Duration';
                'Delta';
                'Slope (?/min)';
                'R^2 Value' };

    editPos = { [90 319 151 22];
                [90 284 151 22];
                [90 249 151 22];
                [90 214 151 22];
                [90 179 151 22];
                [90 144 151 22] };

    editHan = { 'start',...
                'stop',...
                'duration',...
                'delta',...
                'slope',...
                'r2value' };

% #################################################
%               Create GUI Controls
% #################################################

    for i = 1:numel(textPos)
        uicontrol(  'Style',                'text', ...
                    'Position',             textPos{i}, ...
                    'String',               textStr{i}, ...
                    'HorizontalAlignment', 'right' );
    end

    for i = 1:numel(editPos)

        hs.(editHan{i}) = ...
        uicontrol(  'Style',                'edit', ...
                    'Position',             editPos{i}, ...
                    'String',               '', ...
                    'HorizontalAlignment',  'center', ...
                    'Enable',               'on');
    end

    hs.brushButton = uicontrol('Style',     'toggle', ...
                    'Position',             [51 358 149 21], ...
                    'String',               'Brushing OFF', ...
                    'Callback',             @enableButtonCallback ...
                    );

                
% #################################################
%            Brush Callback Definitions
% #################################################
                
                
    hs.mybrush = brush(hs.parent);
    hs.mybrush.Enable= 'off';    
    hs.mybrush.ActionPostCallback = @updateBrushData;
 
    
% #################################################
%            Event Listener Definitions
% #################################################   
    
    hbb = findall(1,'ToolTipString','Brush/Select Data');
    hl = addlistener(hbb, 'State', 'PostSet', @brushToolClickCallback);
    
    
    
% #################################################
%               Callback Definitions
% #################################################
    
    function enableButtonCallback(hobj, event)
        
        if hobj.Value
            % Turn on data brushing
            hs.mybrush.Enable= 'on';
            
            % Toggle button state
            hbb.State = 'on';
            hobj.String = 'Brushing ON';
            % hobj.Value = 0
        else
            %Turn brushing off!
            hs.mybrush.Enable= 'off';
            
            % Toggle button state
            hbb.State = 'off';
            hobj.String = 'Brushing OFF';
            % hobj.Value = 1
        end
    end


    function updateBrushData(hobj, event)

        hch = event.Axes.Children;       
        hLine = hch(isprop(hch, 'BrushHandles'));
        
        dataName = {};
        xData = {};
        yData = {};

        for ii = 1:numel(hLine)
                        
            brushedIdx = logical(hLine(ii).BrushData);  % logical array
            
            if sum(brushedIdx) ~= 0
                
                xData = vertcat(xData, hLine(ii).XData(brushedIdx));
                yData = vertcat(yData, hLine(ii).YData(brushedIdx));
                dataName = vertcat(dataName, hLine(ii).DisplayName);
                        
                trend = trendMath([xData{:}',yData{:}']);

                hs.start.String = trend.start;
                hs.stop.String  = trend.stop;
                hs.duration.String = trend.durations;
                hs.delta.String = trend.delta;
                hs.slope.String = trend.rate;
                hs.r2value.String = trend.rsquare;
                
            end
            
        end
        
        
        
    end % updateBrushData

    
    function CloseOverride(hobj, event)

        if exist('hs.mybrush', 'var')
            hs.mybrush.ActionPostCallback = [];
        end
        
        hl.delete;
%         delete(hs.fig);
        delete(gcf);
        
    end


    function brushToolClickCallback(hobj, event)
        
        switch hbb.State
            case 'on'
                hs.brushButton.Value = 1;
                hs.brushButton.String = 'Brushing ON';
            case 'off'
                hs.brushButton.Value = 0;
                hs.brushButton.String = 'Brushing OFF';
        end
        
    end
    


end % main function
        
        