function [ varargout ] = dataRepositoryPath( varargin )
%dataRepositoryPath sets or gets the dataRepositoryPath.
%   This function stores a critical path string in environment variables
%   for MARS DRT applications.
%
%   <strong>Example:</strong>
%
%   path = dataRepositoryPath('get')
% 
%   path =
% 
%   /Users/nickcounts/Documents/Spaceport/Data
%
%   <strong>Example 2:</strong>
%
%   dataRepositoryPath('set',uigetdir)
%
%   Counts, VCSFA, July 2016



%

switch nargin
    case 1
        % Should be a 'get' command
        if strcmpi(varargin{1}, 'get')
            varargout = {getenv('MDRTdataRepositoryPath')};
        else
            % bad argument.
            warning('dataRepositoryPath does not support that input');
        end
        
    case 2
        % Should be a 'set' command and a path
        cmd = varargin{1};
        pth = varargin{2};
        
        if strcmpi(varargin{1}, 'set')
        
            if exist(pth,'dir')
                setenv('MDRTdataRepositoryPath',pth);
            else
                warning('invalid path specified. Please pass a path to a valid folder');
            end
            
        else
            warning('dataRepositoryPath does not support that input');
        end
        
    otherwise
        
        
end


end

