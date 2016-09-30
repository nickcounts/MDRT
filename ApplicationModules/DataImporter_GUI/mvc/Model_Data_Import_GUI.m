classdef Model_Data_Import_GUI < handle
    %Model_Data_Import_GUI
    %   Model_Data_Import_GUI is the model class for the MVC implementation
    %   of the MDRT Data Import Tool.
    %
    
    
    properties
        
    end
    
    properties (Access = private)
        config
    end
    
    methods
        
        function self = Model_Data_Import_GUI()
            self.config = MDRTConfig.getInstance;
        end
        
        
        
    end
    
end

