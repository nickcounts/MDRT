function [ availFDs ] = listAvailableFDs( path, fileType )
%listAvailableFDs 
%
%   listAvailableFDs( path, fileType )
%
%       fileType is a string
%           fileType = 'dat'
%
%       path is a string and should be a well formed directory string.
%       now checks to be sure there is an fd structure in the variable
%       before populating the list. Also cleans any empty cells.
%
%   Returns an N x 2 cell array of strings:
%
%       'FD1 name' 'fdFileName1.mat'
%       'FD2 name' 'fdFileName2.mat'
%           ...         ...
%       'FDN name' 'fdFileNameN.mat'
%
%
%   This function is now cross-platform compatible
%
%   N. Counts, Spaceport Support Services, 2014

    filesOfType = dir(fullfile(path, ['*.' fileType]));
    
    availFDs = {};

    N = numel(filesOfType);
    
    
    
    if N % Files are found!
    
        progressbar('Retrieving Available FDs');

        availFDs {N,2} = '';

        for i = 1:N
            
            if ~ strcmpi(filesOfType(i).name(1:2), '._') % Ignore weird system files hopefully
                % disp(sprintf('%s ',filesOfType(i).name));

                % TODO: Fix error case where file is named *.mat but is NOT 
                % a -mat file. Loader quits with an error

                F = load([path filesOfType(i).name],'-mat');
                % disp(sprintf('%s',[fd.Type '-' fd.ID]))

                if isfield(F, 'fd')

        %             availFDs{i,1} = sprintf('%s     %s-%s',F.fd.ID,F.fd.Type,F.fd.ID);
                    availFDs{i,1} = sprintf('%s     %s',F.fd.ID, F.fd.FullString);
                    availFDs{i,2} = filesOfType(i).name;

                end
                
            end

            progressbar(i/N);

        end

        availFDs = availFDs(~cellfun('isempty',availFDs));

        availFDs = reshape(availFDs,length(availFDs)/2,2);
    
    else % no files are found
        % return an empty cell
        
    end
    
        
end

