classdef mdrtDataBrowser_controller < handle
    %mdrtDataBrowser_controller(model) conforms to MVC paradigm 
    
    properties
        model
        view
    end
    
    methods
        
        % Constructor
        function obj = mdrtDataBrowser_controller(model)
            obj.model = model;
            obj.view = mdrtDataBrowser_view(obj);
        end
        
        
        function selectDataSet(obj, dataSetIndex)
            obj.model.setSelectedDataSet(dataSetIndex)
        end
        
        function filterBySearchBox(self, searchString)
            self.model.filterBySearchString(searchString)
        end
        
        
        
        
    end
    
end

