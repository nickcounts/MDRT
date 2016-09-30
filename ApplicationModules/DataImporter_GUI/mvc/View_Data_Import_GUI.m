classdef View_Data_Import_GUI
    %View_Data_Import_GUI
    %   View_Data_Import_GUI is the view class for the MVC implementation
    %   of the MDRT Data Import Tool.
    %
    
    properties (Constant)
        guiControls = {              
            'button_importData';
            'panel_metaData';
            'checkbox_autoName';
            'panel_fileList';
            'button_newDataImportSession';
            'edit_folderName';

            'edit_marsUID';
            'edit_marsProcedure';
            'edit_operationName';
            'checkbox_marsUID';
            'checkbox_isOperation';
            'checkbox_marsProcedure';
            'checkbox_vehicleSupport';

            'button_selectFiles';
            'listbox_filesToProcess';
        };
    
    end
    
    properties
        gui
        model
        controller
        
        
    end
    
    properties (Hidden)
        dndControl
    end
    
    % Public Methods
    methods
        
        % ##############################
        % #     Constructor Method     #
        % ##############################
        function self = View_Data_Import_GUI(controller)
            
            % Link to Model, Controller and link View to the GUI figure
            self.controller = controller;
            self.model = controller.model;
            self.gui = Data_Import_GUI('controller', self.controller);
            
            % Add Drag-and-drop controller to listbox
            
            
            listbox = findobj(self.gui, 'tag', 'listbox_filesToProcess');
            
            dndcontrol.initJava;
            
            dndc = dndcontrol(findjobj(listbox));
            
            dndc.DropFileFcn = @self.controller.dragDrop;
            
            keyboard
            
            % Initialize any GUI uicontrols with default values
            
            % Add Listeners to model variables
            
            % Add Listeners to GUI components
            
        end
        

        
    end
    
    % Static Methods
    methods (Static)

        
        % Callback function
        function dropFunction(~,evt)
            switch evt.DropType
                case 'file'
                    jTextArea.append(sprintf('Dropped files:\n'));
                    for n = 1:numel(evt.Data)
                        jTextArea.append(sprintf('%d %s\n',n,evt.Data{n}));
                    end
                case 'string'
                    jTextArea.append(sprintf('Dropped text:\n%s\n',evt.Data));
            end
            jTextArea.append(sprintf('\n'));
        end
            
        
        
        function respondToModel(self, src, event)
            
            
        end
        
        
        
        function respondToView(self, src, event)
            
            eventobj = event.AffectedObject;
            
            switch eventobj.Tag
                case 'button_newDataImportSession'

                    % If New Data Import Session Button is pressed
                    % self.controller.selectDataSet(eventobj.Value);
                    
                otherwise
                    disp('eventobj')
                        
            end
            
        end
        
    end
    
    
end

