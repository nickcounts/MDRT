function [ q ] = parseProportionalCmdData( varargin )
%parseProportionalCmdData reads any non-delimited retrieval file with valve
%data and parses it to the MARS Data Review tool data format for analysis.
%
%   NOTE: At this time, there is no automated handling of Normally Open
%   Valves.
%
%   parseProportionalCmdData            Opens a UI file picker and then
%                                       parses the selected file as a
%                                       proportional valve
%
%   parseProportionalCmdData(file)      when passed a valid file with path
%                                       (char), this function will open 
%                                       the passed file.
%
% Counts, Spaceport Support Services - 2014




% A sample of three data lines that are parsed by this function:
% --------------------------------------------------------------------------------------------------------------------------------------------------
% 2014/194/15:57:00.093289    RP1 PCVNC-1014 Globe Valve  Cmd                                                  SC FGSE M-P0A-RP1-PCV-1014 RP1                                                       
%                                                                                                         Cmd Data:
%                                                                                                         A4 05 00 00 3D 4E 00 00 

% TODO: Implement checking for NO or NC and invert the NO commands!!!!!
disp('WARNING - This function does not correctly handle normally open valves');

% fid = fopen('ORB-2/process/1014.txt');


% Load the configuration data for paths. In the future, add the ability to
% pass config data from another GUI
% -------------------------------------------------------------------------
config = getConfig;


% If no file is specified, open a GUI to choose a plot config file!
% -------------------------------------------------------------------------

if (isempty(varargin))

    [filename, pathname] = uigetfile( ...
    {  '*.txt',   'Text file (*.txt)'; ...
       '*.xlsx',  'Excel file (*.xlsx)'; ...
       '*.xls',   'Excel file (*.xls)'; ...
       '*.*',     'All Files (*.*)'}, ...
       'Pick a file', fullfile(config.dataFolderPath, '..','*.txt'));
   
    pathnameFilename = strcat(pathname, filename);
   
else
    
    pathnameFilename = varargin{1};
    
end



% Open the file:
% -------------------------------------------------------------------------
% fid = fopen('ORB-2/process/1014.txt');

fid = fopen(fullfile(pathname, filename));





line = cell(1);

numLinesIn = 15;

for n = 1:numLinesIn
    line(n,1) = {[fgetl(fid)]};
end


cmdLocations = strfind(line,'Cmd Data:');
cmdLocations = ~cellfun(@isempty,cmdLocations);


hexLocations = logical(cmdLocations);
for n = 1:length(hexLocations)
    if cmdLocations(n)
        hexLocations(n) = 0;
        hexLocations(n + 1) = true;
    else
%         timeLocations(n-1) = 1;
%         timeLocations(n) = 0;
    end
end


timeLocations = logical(cmdLocations);
for n = 1:length(timeLocations)
    if cmdLocations(n)
        timeLocations(n) = 0;
        timeLocations(n - 1) = true;
    else
%         timeLocations(n-1) = 1;
%         timeLocations(n) = 0;
    end
end


% emptyIndex = cellfun(@isempty,mycellarray);       %# Find indices of empty cells
% mycellarray(emptyIndex) = {0};                    %# Fill empty cells with 0
% mylogicalarray = logical(cell2mat(mycellarray));  %# Convert the cell array

% hx = textscan(line{3}, '%s %s %s %s %s %s %s %s');


% Convert hex command value to decimal percentage
% hex2dec(strcat(hx{6:-1:5}))/30000*100



% Reads in only timestamps
% tm = textscan (line{:,1}, '%s *[^\n]', 'Delimiter', ' ')
tm = cellfun(@(c) c(1:24), line(timeLocations), 'UniformOutput', 0)

for i = 1:length(hexLocations)
    if hexLocations(i)
        
        hexCell{i,:} = textscan(line{i}, '%s %s %s %s %s %s %s %s');
    end
end

clear hx;
hx = hexCell(~cellfun('isempty',hexCell))


hexCell

% Read in the hex payloads
q = cellfun(@(c) textscan(c, '%s %s %s %s %s %s %s %s'), ...
                          line(hexLocations),...
                          'UniformOutput', 0)



% line{1}(1:24)
% line(timeLocations)
