function [ fullFilePath ] = getResource( resourceName )
%getResource returns a full filename and path to an MDRT resource file
%   getResource is the deployment safe way to access application images and
%   other resource files



if isdeployed
    rootPath = fullfile(ctfroot, 'resources');
else
    rootPath = fileparts(which('getResource.m'));
end

% TODO: Check for non-image resources and look in the appropriate location

fullFilePath = fullfile(rootPath, 'images', resourceName);

end

