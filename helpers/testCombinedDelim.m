
delimPath = '~/Documents/MATLAB/Data Review/ORB-2/delim';
processPath = '~/Documents/MATLAB/Data Review/ORB-2/process';

% fileName = '../../Data Review/ORB-2/process/RP1-ORB2.delim';
fileName = '~/Documents/MATLAB/Data Review/ITR-800/delim/ITR-800-ECS-GN2-Test.delim';

[fileName processPath] = uigetfile( {...
                            '*.delim', 'CCT Delim File'; ...
                            '*.*',     'All Files (*.*)'}, ...
                            'Pick a file', fullfile(processPath, '..','*.delim'));


% Open the file selected above
% -------------------------------------------------------------------------
fid = fopen(fullfile(processPath,fileName));


% Get lines in data file to chunk large files
% -------------------------------------------------------------------------
    numLines = getFileLineCount(fullfile(processPath, fileName));
    N = 50000;
    if numLines > N
        
        progressbar('Processing Large File')

        for i = 1:N:numLines

            allData = textscan(fid,'%*s %*s %*s %s %*[^\n]',N,'Delimiter',',');
            progressbar(i/numLines);
        end
        
        progressbar(1)

    else
    
    
    



% Read data file into 
% -------------------------------------------------------------------------
    allData = textscan(fid,'%*s %*s %*s %s %*[^\n]','Delimiter',',');
    
    end
    % close file!!!
    fclose(fid);

% Put data into an nx1 cell array of strings for parsing
% -------------------------------------------------------------------------
    fileData = allData{1};
    
    % Garbage collection
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
    
    
% Loop through unique FDs with mask
% -------------------------------------------------------------------------

progressbar('Pre-processing .delim files');
reverseStr = '';

    for i = 1:length(FDlistForGrep)
        
%         % Find indices of cells containing FD Identifier
%         FDindexC = strfind(fileData, uniqueFDs{i});
%         FDindex  = find(not(cellfun('isempty', FDindexC)));
%         
        
        
        m = regexp(FDlistForGrep{i}, '\w*','match');
        outName = strcat(m{1:3},'.delim');
        outputFile = fullfile(delimPath, outName);
        outputFile = regexprep(outputFile, '\s','\\ ');
        
        grepFilename = regexprep(fullfile(processPath, fileName), '\s','\\ ');
                
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
        
    
    