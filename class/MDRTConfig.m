classdef MDRTConfig
    %MDRTConfig All MARS DRT Configuration information, paths, etc. are
    %handled by this class.
    %   Get and Set methods, 
    %
    %
    % Currently supports Data Archive Path and Graph Configuration Path
    
    properties
%         outputFolderPath
%         dataFolderPath
%         delimFolderPath

        graphConfigFolderPath
        
        dataArchivePath
        
        userSavePath
        
        newDataFolderPath
        newDelimFolderPath
        
    end
    
    methods
        
%% Constructor         
        function config = MDRTConfig()
           
           %% Data Archive Path
           if isempty( getenv('MDRT_dataArchivePath') )
               % No data archive path is available.
               warning('No data archive path was found. Please set a valid path to the MDRT data archive root directory');
               
           else
               % Check for valid path and load
               
           end
           
           %% Graph Configuration Path
           if isempty( getenv('MDRT_graphConfigFolderPath') )
               % No graph configuration path is available.
               warning('No graph configuration path was found. Please set a valid path to the MDRT data archive root directory');
               
               
           else
               % Check for valid path and load
               
           end
            
        end
        
        
    end
    
end

