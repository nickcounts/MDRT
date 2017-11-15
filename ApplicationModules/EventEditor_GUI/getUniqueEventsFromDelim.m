function [t, c1, c2, uc1, uc2] = getUniqueEventsFromDelim
%getUniqueEventsFromDelim reads a .delim file and finds all unique FDs for
%use in the MARS Review Tool timeline/events structures
%
%   Prompts for a .delim file and returns the following variables:
%
%       t   = time vector for all FDs
%       c1  = All FD Strings
%       c2  = All FD Readable Strings
%       uc1 = Unique FD Strings
%       uc2 = Unique FD Readable Strings
%
%   This tool has been updated to support Windows as well as *nix systems.
%   getFileLineCount.m and countlines.pl are required
%   
%   Counts, VCSFA 11-2017


% textParseString = '%*s %*s %*s %s %*[^\n]';
textParseString = '%s %*s %*s %s %*s %s %*[^\n]';

[fileName, processPath] = uigetfile('*.delim');


% Open the file selected above
% -------------------------------------------------------------------------

    fid = fopen(fullfile(processPath,fileName));    


% Get lines in data file to chunk large files
% -------------------------------------------------------------------------
    numLines = getFileLineCount(fullfile(processPath, fileName));
    N = 50000;
    flagReadAsChunks = false;
    
    % Instantiate allData for concatenation
    allData1 = cell(1);
    allData2 = allData1;
    
    if numLines > N
        
        flagReadAsChunks = true;
        
        % Open a progress bar
        progressbar('Processing Large File');

        for i = 1:N:numLines
            
            % Read a chunk of the file data
            chunkData = textscan(fid,textParseString,N,'Delimiter',',');
            
            % split into separate chunks
            t =  chunkData{:,1};
            c1 = chunkData{:,2};
            c2 = chunkData{:,3};
            
            % Keep chunkData small for concatenation
            % Make unique lists (keep in order!)
            [uc1,xis] = unique(c1);
            uc2 = c2(xis);
            
            % tack the chunk of data to the end of allData
            allData1 = cat(1,allData1, uc1);
            allData2 = cat(1,allData2, uc2);
            progressbar(i/numLines);
        end
        
        % Clean up first entry (empty cell)
        allData1(1) = [];
        allData2(1) = [];
        
        % Close the progress bar
        progressbar(1);

        
        
    else
    
    % Read data file into 
    % ---------------------------------------------------------------------
        allData = textscan(fid,textParseString,'Delimiter',',');
        
        % Make unique lists (keep in order!)
        % split into separate chunks
            t  = allData{:,1};
            c1 = allData{:,2};
            c2 = allData{:,3};
            
            [uc1,xis] = unique(c1);
            uc2 = c2(xis);
    
    end
    
    
    % close file!!!
    fclose(fid);

    
    
    
    
    
    