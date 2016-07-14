function [ titleString ] = makeDataSetTitleStringFromActiveConfig( varargin )
%makeDataSetTitleStringFromActiveConfig Summary of this function goes here
%   makeDataSetTitleStringFromActiveConfig( configStruct )
%   makeDataSetTitleStringFromActiveConfig( metadataStruct )
%   makeDataSetTitleStringFromActiveConfig() - don't be a jerk
%
%   Counts 2016 VCSFA

titleString = '';

dbug = true;



switch nargin
    case 1 % Caller passed either a config struct or a metadata struct
        
        switch checkStructureType( varargin{1} )
            case 'metadata'
                % it was a metadata struct
                
                disp('passed a metadata struct')
                
                
            case 'config'
                % it was a config struct
                % load the metadata struct
                
                config = varargin{1};
                
                metaData = loadMetadataFromConfig(config);
                
                disp('passed a config struct, loaded metadata')
                
            otherwise
                % User passed a bogus/unsupported variable type
                % Soft fail by returning empty string
                return
                
        end
        
        
    case 0
        % Caller was a jerk and did give you anything!
        % Try to load config, grab metadata and then do the work
        
        disp('you''re a jerk')
        
        metaData = loadMetadataFromConfig(getConfig);
        
        disp('but it worked out')
        
    otherwise
        % If it's more than 1 variable passed I don't know what happened?
        % Soft fail and return empty set
        return
end

% If you made it this far, there is a valid metaData variable/struct in
% memory

titleString = makeStringFromMetaData(metaData);

end

function metaData = loadMetadataFromConfig(config)

filename = fullfile(config.dataFolderPath,'metadata.mat');
                
    if exist(filename,'file') == 2 % File exists

        % Test that the file contains the right variable
        s = whos('-file', filename);

        if strcmp('metaData', s.name ) && strcmp('struct', s.class)
            % Pretty confident we have the real deal here
            load(filename);
            % now metaData is loaded. Should I do this explicitely?
        else
           % If I failed this test, bad shit is happeneing.
           % Soft fail by returning empty string
           disp('passed a config struct, no metadata found')
           return
        end
        

    else % no metadata file found
        
        disp('passed a config struct, metadata file missing')
        % Soft fail by returning empty string
        return
    end
                

end



function titleString = makeStringFromMetaData(metaData)

    titleString = '';

    
    
    
end



