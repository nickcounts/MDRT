classdef ConfigFile
    %ConfigFile object to handle reading and writing to config files
    %   Detailed explanation goes here
    
    properties
        configuration
        fileContents
        validConfigStrings
    end
    
    properties (Constant)
        commentSymbol = '#';
        validConfigStrings
    end
    
    methods
        function thisConfigFile = ConfigFile
            
            validConfigStrings = MDRTConfig.validConfigKeyNames
            
            
            
        end
    end
    
end

