function controllerDataImportGUI( hobj, event, varargin )
%controllerDataImportGUI
%   controllerDataImportGUI is the controller and callback function for the
%   makeDataImportGUI function. This function controls all 




switch hobj.Style
    
    case 'checkbox'
        
        targetOffString = '';
        targetOnString = '';
        targetOffMode = 'off';
        targetOnMode = 'on';
        
        switch hobj.Tag
            case 'checkbox_autoName'
                target = findobj('Tag', 'edit_folderName');
                % targetOnString = makeAutoString;
                targetOffString = target.String;
                
                targetOffMode = 'on';
                targetOnMode  = 'inactive';

            case 'checkbox_isOperation'
                target = findobj('Tag', 'edit_operationName');
                
            case 'checkbox_isMARS'
                target = findobj('Tag', 'edit_procedureName');
                
            case 'checkbox_hasUID'
                target = findobj('Tag', 'edit_UID');
                
            case 'checkbox_vehicleSupport'
                
            otherwise
                return
                
        end
        
        if hobj.Value
            target.Enable = targetOnMode;
        else
            target.Enable = targetOffMode;
            target.String = targetOffString;
        end    

    case 'button'
        
        switch hobj.Tag
            case 'button_newSession'
                
            otherwise
                return
                
        end
        
        
    otherwise
        
        
end



end

