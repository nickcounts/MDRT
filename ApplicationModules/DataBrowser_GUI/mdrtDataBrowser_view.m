classdef mdrtDataBrowser_view
    %mdrtDataBrowser_model Summary of this class goes here
    
    
    properties
        gui
        model
        controller
    end
    
    properties (Hidden)
        
        jhEdit1
        
    end
    
    methods
        % Constructor
        % -----------------------------------------------------------------
        function obj = mdrtDataBrowser_view(controller)
            
            obj.controller = controller;
            obj.model = controller.model;
            obj.gui = dataBrowserGui('controller',obj.controller);
            
            handles = guidata(obj.gui);
            
            % Initialize any GUI uicontrols with default values
            % -------------------------------------------------------------
            
            handles.edit1.String = '';
            
            
            % Add Listeners to model variables
            % -------------------------------------------------------------
            
            addlistener(obj.model,'selectedDataSet','PostSet', ...
                @(src,evnt)mdrtDataBrowser_view.handlePropertyEvents(obj,src,evnt));
            
            addlistener(obj.model,'dataSetCollectionList','PostSet', ...
                @(src,evnt)mdrtDataBrowser_view.handlePropertyEvents(obj,src,evnt));
            
            addlistener(obj.model,'dataStreamsInSelectedDataSet','PostSet', ...
                @(src,evnt)mdrtDataBrowser_view.handlePropertyEvents(obj,src,evnt));
            
            % Add listeners and handlers for GUI updates
            % -------------------------------------------------------------
            
            addlistener(handles.popupmenu1, 'Value', 'PostSet', ...
                @(src,evnt)mdrtDataBrowser_view.handleGuiEvents(obj,src,evnt));

            obj.jhEdit1 = findjobj(handles.edit1);

            addlistener(handles.edit1, 'KeyRelease', ...
                @(src,evnt)mdrtDataBrowser_view.searchCallback(obj,src,evnt));
            
            
        end
        
    end
    
        methods (Static)
           
            function handlePropertyEvents(obj, src, event)
                
                eventobj = event.AffectedObject;
                handles = guidata(obj.gui);
               
%                 disp(src.Name)
                
                switch src.Name
                    case 'dataSetCollectionList'
                        handles.popupmenu1.String = obj.model.dataSetCollectionList;
                    case 'selectedDataSet'
                        handles.popupmenu1.Value = obj.model.selectedDataSet;
                    case 'dataStreamsInSelectedDataSet'
                        handles.listbox1.String = obj.model.dataStreamsInSelectedDataSet;
                    otherwise
%                         disp(src.Name)
                        
                end
                
            end
            
            
            
            function handleGuiEvents(obj, src, event)
                
                eventobj = event.AffectedObject;
%                 handles = guidata(obj.gui);
               
                switch eventobj.Tag
                    case 'popupmenu1'
                        % If popup menu is changed
                        obj.controller.selectDataSet(eventobj.Value);
                    
                    otherwise
                end
                
            end
            
            function searchCallback(obj, src, event)
                searchString = char(obj.jhEdit1.getText);
                obj.controller.filterBySearchBox(searchString);
            end
            
        end
    
end

