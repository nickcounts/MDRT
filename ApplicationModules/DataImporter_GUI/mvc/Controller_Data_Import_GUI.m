classdef Controller_Data_Import_GUI < handle
    %Controller_Data_Import_GUI
    %   Controller_Data_Import_GUI is the model class for the MVC implementation
    %   of the MDRT Data Import Tool.
    %
    
    properties
        model
        view
    end
    
    methods
        
        % Constructor
        function self = Controller_Data_Import_GUI(model)
            %Controller_Data_Import_GUI(model)
            %
            %   Constructor for the controller object.
            %   Instantiates a view object with a reference to self and
            %   retains as a property
            %   Sets model property to the model reference passed to the
            %   constructor.
            
            
            % Link to the model
            self.model = model;
            
            % Instantiate the view object, and pass a reference to self
            self.view  = View_Data_Import_GUI(self);
        
        end
        
        function self = dragDrop(varargin)
            keyboard
            
            
        end
        
        
    end
    
end

