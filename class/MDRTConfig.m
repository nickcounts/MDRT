classdef MDRTConfig
    %MDRTConfig All MARS DRT Configuration information, paths, etc. are
    %handled by this class.
    %   Get and Set methods, 
    %     
    %     set.dataArchivePath
    %     set.graphConfigFolderPath
    %     set.userSavePath
    %     set.userWorkingPath
    %   
    %   makeWorkingDirectoryStructure( newWorkingDirectoryRootPath )
    %   makeWorkingDirectoryStructure()
    %
    % Currently supports Data Archive Path and Graph Configuration Path
    
    properties
%         outputFolderPath
%         dataFolderPath
%         delimFolderPath

        % 
        graphConfigFolderPath
        dataArchivePath
        userSavePath
        userWorkingPath
        
    end
    
    properties (Dependent)
        
        workingDataPath
        workingDelimPath

    end
    
    methods
        
    % Constructor         
        function thisMDRTConfig = MDRTConfig()

            %% Data Archive Path
            if isempty( getenv('MDRT_DATA_ARCHIVE_PATH') )
                % No data archive path is available.
                warning('No data archive path was found. Please set a valid path to the MDRT data archive root directory');

            else
                % load the valid path
                thisMDRTConfig.dataArchivePath = getenv('MDRT_DATA_ARCHIVE_PATH');
            end
           
           %% Graph Configuration Path
           if isempty( getenv('MDRT_GRAPH_CONFIG_PATH') )
               % No graph configuration path is available.
               warning('No graph configuration path was found. Please set a valid path to the MDRT data archive root directory');
           else
               % load the valid path
               thisMDRTConfig.graphConfigFolderPath = getenv('MDRT_GRAPH_CONFIG_PATH');
           end
           
           %% User Working Path
           if isempty( getenv('MDRT_WORKING_PATH') )
               % No working path is available
               warning('No user working path was found. Please set a valid path to the MDRT data archive root directory');
           else
               % load the valid path
               thisMDRTConfig.userWorkingPath = getenv('MDRT_WORKING_PATH');
           end
            
        end
        
    %% Set Methods
    %  --------------------------------------------------------------------    
        function obj = set.dataArchivePath(obj,val)
            % Only set if it is a valid path.
            if exist( fullfile(val), 'dir' )
                setenv('MDRT_DATA_ARCHIVE_PATH', fullfile(val) );
                obj.dataArchivePath = fullfile(val);
            else
                
                warning('Invalid path specified. MDRT_DATA_ARCHIVE_PATH not set');
                
                % Invalid path specified. Check if existing value is good
                % and retain or clear
                if exist(obj.dataArchivePath, 'dir')
                    % there is a valid path in the object. Do nothing?
                    
                else
                    % Bad path passed and invalid directory in object.
                    % Clearing object 
                    warning('MDRTConfig.dataArchivePath set to empty string');
                    obj.dataArchivePath = '';
                end
                
                return
            end
            
        end
        
        
        function obj = set.graphConfigFolderPath(obj,val)
            % Only set if it is a valid path.
            if exist( fullfile(val), 'dir' )
                setenv('MDRT_GRAPH_CONFIG_PATH', fullfile(val) );
                obj.graphConfigFolderPath = fullfile(val);
            else
                
                warning('Invalid path specified. MDRT_GRAPH_CONFIG_PATH not set');
                
                % Invalid path specified. Check if existing value is good
                % and retain or clear
                if exist(obj.graphConfigFolderPath, 'dir')
                    % there is a valid path in the object. Do nothing?
                    
                else
                    % Bad path passed and invalid directory in object.
                    % Clearing object 
                    warning('MDRTConfig.graphConfigFolderPath set to empty string');
                    obj.graphConfigFolderPath = '';
                end
                
                return
            end
            
        end

        
        function obj = set.userSavePath(obj,val)
            % Only set if it is a valid path.
            if exist( fullfile(val), 'dir' )
                setenv('MDRT_USER_OUTPUT_PATH', fullfile(val) );
                obj.userSavePath = fullfile(val);
            else
                
                warning('Invalid path specified. MDRT_USER_OUTPUT_PATH not set');
                
                % Invalid path specified. Check if existing value is good
                % and retain or clear
                if exist(obj.userSavePath, 'dir')
                    % there is a valid path in the object. Do nothing?
                    
                else
                    % Bad path passed and invalid directory in object.
                    % Clearing object 
                    warning('MDRTConfig.userSavePath set to empty string');
                    obj.userSavePath = '';
                end
                
                return
            end
            
        end
        
        
        function obj = set.userWorkingPath(obj,val)
            % Only set if it is a valid path.
            if exist( fullfile(val), 'dir' )
                setenv('MDRT_WORKING_PATH', fullfile(val) );
                obj.userWorkingPath = fullfile(val);

            else
                
                warning('Invalid path specified. MDRT_WORKING_PATH not set');
                
                % Invalid path specified. Check if existing value is good
                % and retain or clear
                if exist(obj.userWorkingPath, 'dir')
                    % there is a valid path in the object. Do nothing?
                    
                else
                    % Bad path passed and invalid directory in object.
                    % Clearing object 
                    warning('MDRTConfig.userSavePath set to empty string');
                    obj.userWorkingPath = '';
                end
                
                return
            end
            
        end
        
    %% Get Methods
    %  --------------------------------------------------------------------    
        
        function dataArchivePath = get.dataArchivePath(this)
            
            tryPath = getenv('MDRT_DATA_ARCHIVE_PATH');
            
            if strcmp(tryPath, this.dataArchivePath)
                % matching, so no worries
                dataArchivePath = tryPath;
            else
                % there is a mismatch - 
                % Just use the one from the object and set the envvar?
                warning('Mismatch between envvar and MDRTConfig object property value. Defaulting to envvar');
                dataArchivePath = getenv('MDRT_DATA_ARCHIVE_PATH');
            end
            
        end
        
        
        function graphConfigFolderPath = get.graphConfigFolderPath(this)
            
            tryPath = getenv('MDRT_GRAPH_CONFIG_PATH');
            
            if strcmp(tryPath, this.graphConfigFolderPath)
                % matching, so no worries
                graphConfigFolderPath = tryPath;
            else
                % there is a mismatch - 
                % Just use the one from the object and set the envvar?
                warning('Mismatch between envvar and MDRTConfig object property value. Defaulting to envvar');
                graphConfigFolderPath = getenv('MDRT_GRAPH_CONFIG_PATH');
            end
            
        end

        
        function userSavePath = get.userSavePath(this)
            
            tryPath = getenv('MDRT_USER_OUTPUT_PATH');
            
            if strcmp(tryPath, this.userSavePath)
                % matching, so no worries
                userSavePath = tryPath;
            else
                % there is a mismatch - 
                % Just use the one from the object and set the envvar?
                warning('Mismatch between envvar and MDRTConfig object property value. Defaulting to envvar');
                userSavePath = getenv('MDRT_USER_OUTPUT_PATH');
            end
            
        end
        
        
        function userWorkingPath = get.userWorkingPath(this)
            
            tryPath = getenv('MDRT_WORKING_PATH');
            
            if strcmp(tryPath, this.userWorkingPath)
                % matching, so no worries
                userWorkingPath = tryPath;
            else
                % there is a mismatch - 
                % Just use the one from the object and set the envvar?
                warning('Mismatch between envvar and MDRTConfig object property value. Defaulting to envvar');
                userWorkingPath = getenv('MDRT_WORKING_PATH');
            end
            
        end
       
        
        
    %% Get Methods for Dependent Properties
        function workingDataPath = get.workingDataPath(this)
            
            root = this.userWorkingPath;
            
            if exist( fullfile(root, 'data'), 'dir' )
                workingDataPath = fullfile(root, 'data');
            else
                % No data folder - set output to empty variable
                workingDataPath = '';
            end
             
        end
        
        
        function workingDelimPath = get.workingDelimPath(this)
            
            root = this.userWorkingPath;
                        
            if exist( fullfile(root, 'delim'), 'dir' )
                workingDelimPath = fullfile(root, 'delim');
                
                
                
            else
                % No data folder - set output to empty variable
                workingDelimPath = '';
            end
             
        end
        
        
    %% Class Methods
        function this = makeWorkingDirectoryStructure(this, varargin)
            %makeWorkingDirectoryStructure creates the default directory
            %structure for processing delim files.
            %
            % With no arguments, the function defaults to the stored path
            % Pass a path (string) to a desired working directory and the
            % function will create the higherarchy and set the working path
            % envvar.
            
            if nargin == 1
                % Use the existing MDRT_WORKING_PATH
                wpath = this.userWorkingPath;
            elseif nargin == 2
                wpath = fullfile( varargin{1} );
            else
                warning('Too many arguments passed');
                % fail soft for now
                return
            end
             
            datapath  = fullfile( wpath, 'data');
            delimpath = fullfile( wpath, 'delim');
            
            % Check for existing folders and create if necessary
            
            % Create/verify data folder
            if exist( datapath, 'dir')
                
            else
                mkdir(datapath);
            end
            
            % Create/verify delim folder
            if exist( delimpath, 'dir')
                
                % Check for sub-directories and create
                if ~exist(fullfile(delimpath, 'original'), 'dir')
                    mkdir(fullfile(delimpath, 'original'));
                end
                
                % Check for sub-directories and create
                if ~exist( fullfile(delimpath, 'ignore'), 'dir')
                    mkdir(fullfile(delimpath, 'ignore'));
                end
                
            else
                % Delim folder wasn't there - make delim folder tree
                mkdir(delimpath);
                mkdir(fullfile(delimpath, 'original'));
                mkdir(fullfile(delimpath, 'ignore'));
            end
            
            
            % At this point all folders exist
            %     workingDirectory Root
            %         data
            %         delim
            %             original
            %             ignore
            
            % Update Object pointer to working directory root.
            this.userWorkingPath = wpath;
            
        end
        
    end
    
end

