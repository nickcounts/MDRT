function [ availFDs, timespan ] = indexTimeAndFDNames( path  )
%indexTimeAndFDNames 
%
%   indexTimeAndFDNames( path, fileType )
%
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
%   Returns a 1 x 2 matrix of datenums
%
%       [firstDataPointTimestamp, lastDataPointTimestamp]
%
%   This function is now cross-platform compatible
%
%   N. Counts, Spaceport Support Services, 2017

    filesOfType = dir( fullfile( path, '*.mat') );
    
    availFDs = {};
    timespan = [];

    N = numel(filesOfType);
    
    
    
    if N % Files are found!
    
        progressbar('Retrieving Available FDs');

        availFDs {N,2} = '';

        for i = 1:N
            
            if ~ strcmpi(filesOfType(i).name(1:2), '._') % Ignore weird system files hopefully
                % disp(sprintf('%s ',filesOfType(i).name));

                % TODO: Fix error case where file is named *.mat but is NOT 
                % a -mat file. Loader quits with an error

                F = load( fullfile(path, filesOfType(i).name),'-mat');
                % disp(sprintf('%s',[fd.Type '-' fd.ID]))

                if isfield(F, 'fd')
                    % we loaded a structure called fd

                    availFDs{i,1} = F.fd.FullString;
                    availFDs{i,2} = filesOfType(i).name;
                    
                    thisTimeSpan = [F.fd.ts.Time(1), F.fd.ts.Time(end)];
                    
                    if isempty(timespan)
                        timespan = thisTimeSpan;
                    end
                    
                    
                    
                    timespan(1) = min( min(timespan), min(thisTimeSpan) );
                    timespan(2) = max( max(timespan), max(thisTimeSpan) );

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

