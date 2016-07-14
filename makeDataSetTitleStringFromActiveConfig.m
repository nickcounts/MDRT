function [ titleString ] = makeDataSetTitleStringFromActiveConfig( input_args )
%makeDataSetTitleStringFromActiveConfig Summary of this function goes here
%   makeDataSetTitleStringFromActiveConfig( configStruct )
%   makeDataSetTitleStringFromActiveConfig( metadataStruct )
%   makeDataSetTitleStringFromActiveConfig() - don't be a jerk
%
%   Counts 2016 VCSFA

titleString = '';

switch nargin
    case 1 % Caller passed either a config struct or a metadata struct
        
        switch checkStructureType(varargin{1}
            case 'metadata'
                % it was a metadata struct
                
                
            case 'config'
                % it was a config struct
                
                % load the metadata struct
                
                filename = fullfile(config.dataFolderPath,'metadata.mat');
                
                s = whos('-file', filename);
                
                if strcmp('metaData', s.name ) && strcmp('struct', s.class)
                    % Pretty confident we have the real deal here
                    load(filename);
                else
                   % If I failed this test, bad shit is happeneing.
                   % Soft fail by returning empty string
                   return
                end
                
                
            otherwise
                % User passed a bogus/unsupported variable type
                % Soft fail by returning empty string
                return
                
        end
        
        
        
        
        % Check to see if it was a config struct and load the metadata
        % struct first, then behave
        
        
    case 0
        % Caller was a jerk and did give you anything!
        % Try to load config, grab metadata and then do the work
    otherwise
        % If it's more than 1 variable passed I don't know what happened?
        % Soft fail and return empty set
end



end

