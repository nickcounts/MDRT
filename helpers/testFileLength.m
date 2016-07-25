delimPath = '~/Documents/MATLAB/Data Review/ORB-2/process/test';
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



% % %     %# Get file size.
% % %         fseek(fid, 0, 'eof');
% % %         fileSize = ftell(fid);
% % %         frewind(fid);
% % %     %# Read the whole file.
% % %         data = fread(fid, fileSize, 'uint8');
% % %     %# Count number of line-feeds and increase by one.
% % %         numLines = sum(data == 10) + 1;
    
% % 
% % 
% % 
% %         tic
% %         Nrows = numel(textscan(fid,'%1c%*[^\n]'))
% %         toc
% % 


    fileAndPath = fullfile(processPath, fileName);
    fileAndPath = regexprep(fileAndPath, '\s','\\ ');


if (isunix) %# Linux, mac
    [status, result] = system( ['wc -l ', fileAndPath] );
    numlines = textscan(result, '%d %*s');
    numlines = numlines{1}

elseif (ispc) %# Windows
    numlines = str2num( perl('countlines.pl', 'your_file') );

else
    error('...');

end




% where 'countlines.pl' is a perl script, containing
% 
% while (<>) {};
% print $.,"\n";









% Close the file
    fclose(fid);
