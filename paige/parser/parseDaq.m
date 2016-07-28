% Parse MARS DAQ .csv file (DATAQ 710)

% fileToOpen = uiopen;
% fid = fopen(fileToOpen);
% fid = fopen('/Users/nick/Documents/MATLAB/MARS Review Tool/v0.4/parser/5cycles.csv');

%   delimPath = '~/Documents/MATLAB/Data Review/ORB-2/delim';
%     delimPath = config.delimFolderPath;
%     processPath = fullfile(delimPath, '..');
%     processPath = '~/Desktop';


    [fileName processPath] = uigetfile( {...
                            '*.csv', 'Comma Separated'; ...
                            '*.*',     'All Files (*.*)'}, ...
                            'Pick a file', '*.csv');

if isnumeric(fileName)
    % User cancelled .delim pre-parse
    disp('User cancelled .delim pre-parse');
    return
end
                        
% Open the file selected above
% -------------------------------------------------------------------------
fid = fopen(fullfile(processPath,fileName));


% R = textscan(fid, '%s',3,'Delimiter','\n')
% Q = textscan(fid, '%s %*s %*s %s %s %s %*s %s %s', 'Delimiter', ',');
% Q = textscan(fid, '%s %s %s', 'Delimiter', '\n');

% Quickly Dump headers
% Q = textscan(fid, '%s*[^\n]', 3, 'Delimiter', '\n');
% Q = textscan(fid, '%s', 3);
Q = textscan(fid, '%s', 3, 'Delimiter', '\n');

% Grab numbers!
% R = textscan(fid, '%n %n %n *s', 'Delimiter', ',');
R = textscan(fid, '%n,%n,%n');

fclose(fid);

% create variables
t = R{1};
a1 = R{2};
a2 = R{3};

% clear Q R;



