function [ output_args ] = splitDelimFiles( varargin )
%splitDelimFiles reads a .delim file and splits it into discrete .delim
%files for parsing by the MARS Review Tool
%
%   splitDelimFiles( configStruct )
%   splitDelimFiles( MDRTConfig )
%
%   splitDelimFiles( filename, configStruct )
%   splitDelimFiles( filename, configStruct )
%
%   This tool has been updated to support Windows as well as *nix systems.
%   getFileLineCount.m and countlines.pl are required
%   
%   Counts, Spaceport Support Services. 2014

%   Updated 2016, Counts, VCSFA - Better delim naming convention, should
%   eliminate overloaded filenames.

switch nargin
    case 1
        configVar = varargin{1};
        noFilenamePassed = true;
    case 2
        fileName = varargin{1};
        configVar = varargin{2};
        noFilenamePassed = false;
    otherwise
        error('Invalid arguments for function splitDelimFiles');
        
end
        
        

% Handle configuration variable argument
if isa(configVar, 'MDRTConfig')
    delimPath = configVar.workingDelimPath;
    
elseif strcmpi( checkStructureType(configVar), 'config')
    delimPath = configVar.delimFolderPath;
    
else
    error('Unknown configuration parameter')
    
end

% Define paths from config structure
%     delimPath = '~/Documents/MATLAB/Data Review/ORB-2/delim';
%     delimPath = config.delimFolderPath;
    % processPath = fullfile(delimPath, '..'); % Not sure why I ever did this
    processPath = fullfile(delimPath);
    
    if noFilenamePassed
        
        [fileName processPath] = uigetfile( {...
                                '*.delim', 'CCT Delim File'; ...
                                '*.*',     'All Files (*.*)'}, ...
                                'Pick a file', fullfile(processPath, '*.delim'));

        if isnumeric(fileName)
            % User cancelled .delim pre-parse
            disp('User cancelled .delim pre-parse');
            return
        end
        
        fileName = fullfile(processPath, fileName);

    else
        
        % Do error checking here for passed filename
        
        % de-cell the fileName
        while iscell(fileName)
            fileName = fileName{1};
        end
        
    end
                        
% Open the file selected above
% -------------------------------------------------------------------------
fid = fopen(fileName);


% Get lines in data file to chunk large files
% -------------------------------------------------------------------------
    
    numLines = getFileLineCount(fileName);
    N = 50000;
    flagReadAsChunks = false;
    
    % Instantiate allData for concatenation
    allData = cell(1);
    
    if numLines > N
        
        flagReadAsChunks = true;
        
        % Open a progress bar
        progressbar('Processing Large File');

        for i = 1:N:numLines
            
            % Read a chunk of the file data
            chunkData = textscan(fid,'%*s %*s %*s %s %*[^\n]',N,'Delimiter',',');
            
            % Keep chunkData small for concatenation
            chunkData = unique(chunkData{:});
            
            % tack the chunk of data to the end of allData
            allData = cat(1,allData, chunkData);
            progressbar(i/numLines);
        end
        
        % Clean up first entry (empty cell)
        allData(1) = [];
        
        % Close the progress bar
        progressbar(1);

    else
    
    % Read data file into 
    % -------------------------------------------------------------------------
        allData = textscan(fid,'%*s %*s %*s %s %*[^\n]','Delimiter',',');
    
    end
    
    
    % close file!!!
    fclose(fid);

    
    
    
% Put data into an nx1 cell array of strings for parsing
% -------------------------------------------------------------------------
    
    % Handle different variable forms from chunk vs direct file parsing
    switch flagReadAsChunks
        case true
            fileData = allData;
            
            
        case false
            fileData = allData{1};
    end    

    
%     % Garbage collection
%     clear allData fid;
    
% 2014/193/13:03:30.450043, , ,__RP1 FM-1016 Input Signal Si__,BA,,----------------,, 





% find all unique FD strings - store in cell array of strings
% -------------------------------------------------------------------------
    uniqueFDs = unique(fileData);

% find all FDs that are valve related - returns cell array of cells of
% strings
% -------------------------------------------------------------------------
%     valveFDs = regexp(uniqueFDs, '[DP]CVN[CO]-[0-9]{4}','match');

% Include System ID String
    valveFDs = regexp(uniqueFDs, '\w* [DP]CVN[CO]-[0-9]{4}','match');
    
% Make FD List for grep without any valve data
    FDlistForGrep = uniqueFDs(cellfun('isempty',valveFDs));

% make cell array of strings containing all unique valve identifiers
% -------------------------------------------------------------------------
    uniqueValves = unique(cat(1,valveFDs{:}));
    
    
% % % Generate cell array of cell array of strings (listing FDs for each valve)
% % % -------------------------------------------------------------------------
% %     valveFDBundle = cell(length(uniqueValves),1);
% % 
% %     for i = 1:length(uniqueValves)
% % 
% %         temp = regexp(fds, uniqueValves{i},'match');
% % 
% %         valveFDBundle{i,1} = cat(1, temp{:});
% % 
% %     end
    
    
% Combine Valve FDs with uniqueFDs for .delim grep
% -------------------------------------------------------------------------
    
    FDlistForGrep = cat(1,FDlistForGrep, uniqueValves);
    
% Remove FDs with leading underscores
    FDlistForGrep(~cellfun('isempty',regexp(FDlistForGrep,'^_'))) = [];
    
    
% Loop through unique FDs with mask
% -------------------------------------------------------------------------

progressbar('Pre-processing .delim files');
reverseStr = '';

    % TODO: rename variabls with semantic names for future clarity 
    
    useCustomNames = false;
    
    if exist('processDelimFiles.cfg','file')
        load('processDelimFiles.cfg', '-mat');
        useCustomNames = true;
    end 


    for i = 1:length(FDlistForGrep)
        
%         % Find indices of cells containing FD Identifier
%         FDindexC = strfind(fileData, uniqueFDs{i});
%         FDindex  = find(not(cellfun('isempty', FDindexC)));
%         

        
        
        % max(max(strcmp('ECS C1ECU Fan Speed Setpoint', customFDnames)));
        isCustomRule = find(strcmp(FDlistForGrep{i}, customFDnames));
        

        m = regexp(FDlistForGrep{i}, '\w*','match');
        if length(m) > 3
            if isCustomRule
                outName = strcat(customFDnames{isCustomRule, 6}, '.delim');
            else
                % USe all tokens to guarantee a unique filename
                outName = strcat(m{1:end},'.delim');
            end
        else
            disp('FD was less than 4 tokens long. Processed array:');
            m
            outName = strcat(m{:});
        end
        
        outputFile = fullfile(delimPath, outName);
        outputFile = regexprep(outputFile, '\s','\\ ');
        
        grepFilename = regexprep(fileName, '\s','\\ ');
                
        % Generate egrep command to split delim into parseable files
        egrepCommand = ['egrep "', FDlistForGrep{i}, '" ',grepFilename, ' > ', outputFile];
        system(egrepCommand);
        
                
        progressbar(i/length(FDlistForGrep));
        
        
        % Display the progress
        percentDone = 100 * i / length(FDlistForGrep);
        msg = sprintf('Percent done: %3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        
    end
    
    % Print a newline character to clean the console
    fprintf('\n');
        
    
    

end

