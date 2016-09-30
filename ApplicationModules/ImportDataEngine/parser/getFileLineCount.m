function [ lineCount ] = getFileLineCount( fileNameAndPath )
%getFileLineCount returns the number of lines in a file
%   Returns the number of lines in a data file.
%   Will ultimately be platform independant but requires a perl script for
%   winows machines.
%
% Counts, Spaceport Support Services, 2014


% -------------------------------------------------------------------------
fid = fopen(fullfile(fileNameAndPath));


    unixFileNameAndPath = fileNameAndPath;
    unixFileNameAndPath = regexprep(unixFileNameAndPath, '\s','\\ ');


if (isunix) %# Linux, mac
    [~, result] = system( ['wc -l ', unixFileNameAndPath] );
    numlines = textscan(result, '%s %*s');
    lineCount = str2num(numlines{1}{1});
    
elseif (ispc) %# Windows
    lineCount = str2num( perl('countlines.pl', 'your_file') );

else
    error('...');

end




% where 'countlines.pl' is a perl script, containing
% 
% while (<>) {};
% print $.,"\n";









% Close the file
    fclose(fid);


end

