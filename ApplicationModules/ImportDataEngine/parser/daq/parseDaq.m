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


linesOfPreview = 5;

    Q = textscan(fid, '%s', linesOfPreview, 'Delimiter', '\n');

for i = 1:length(Q{1})
    disp(Q{1,1}{i});
end


frewind(fid);


linesToSkip = input('How many header lines to skip: ');
    Q = textscan(fid, '%s', linesToSkip, 'Delimiter', '\n');



% Grab numbers!
% R = textscan(fid, '%n %n %n *s', 'Delimiter', ',');
    R = textscan(fid, '%n,%n,%n,%n,%n,%n,%n,%n');

fclose(fid);

% create variables
    t = R{1};
    a1 = R{2};
    a2 = R{3};
    a3 = R{4};
    a4 = R{5};
    a5 = R{6};
    a6 = R{7};
    a7 = R{8};
% clear Q R;




disp('Data parsing is complete')
disp('Creating FDs for MARS Review Tool')
disp('Specify path to save data')
disp('')

dataFolderPath = uigetdir();

% Make sure the user selected something!
if dataFolderPath ~= 0
    % We got a path selection. Now append the trailing / for linux
    % Note, we are not implementing OS checking at this time (isunix, ispc)
    
    dataFolderPath = [dataFolderPath '/'];
else
    dataFolderPath = '.'
end


