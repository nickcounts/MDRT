% parseCmdData
%
%   parseCmdData reads the non-delim retrieval files from MARS UGFCS
%   retrievals. It converts the hexidecimal command payloads into the
%   device address, and the two seperate commands. These are bundled into a
%   Matlab timeseries and added to the MARS Data Review tool fd structure
%   and saved.
%
%   Usage notes:
%
%   The current version requires the data file contain information from one
%   valve only. If multiple valve data are included, this will combine them
%   with no easy way of separating them in the future.
%
%   If you have performed a retrieval on multiple proportional control
%   valves, use egrep (if you are on a *nix based system) to separate the
%   valve data into discrete files for processing.
%
%   Example:
%
%   egrep -A 3 -- 'WDS BV-0010 Valve Positioner  Cmd     ' AllValves | egrep -C 1 -- "Cmd Data:" > WDS-BV-0010.txt
%
%
%   Counts, Spaceport Support Services, 2014






%% Sample egrep commands
% -------------------------------------------------------------------------


% 2014/194/15:57:00.093289    RP1 PCVNC-1014 Globe Valve  Cmd                                                  SC FGSE M-P0A-RP1-PCV-1014 RP1                                                       
%                                                                                                         Cmd Data:
%                                                                                                         A4 05 00 00 3D 4E 00 00 
% 'RP1 PCVNC-1014 Globe Valve  Cmd    '
% 'RP1 PCVNC-1015 Globe Valve  Cmd    '
% 'RP1 PCVNC-1049 Globe Valve  Cmd    '
% 
% 
% egrep -A 3 -- 'LO2 PCVNO-2013 Globe Valve  Cmd       ' AllValves | grep -C 1 -- "Cmd Data:" > 2013.txt
% egrep -A 3 -- 'LO2 PCVNO-2014 Globe Valve  Cmd       ' AllValves | grep -C 1 -- "Cmd Data:" > 2014.txt
% egrep -A 3 -- 'WDS BV-0009 Valve Positioner  Cmd     ' AllValves | grep -C 1 -- "Cmd Data:" > WDS-BV-0009.txt
% egrep -A 3 -- 'WDS BV-0010 Valve Positioner  Cmd     ' AllValves | grep -C 1 -- "Cmd Data:" > WDS-BV-0010.txt

% egrep -A 3 -- "WDS BV-0009 Valve Positioner  Cmd   " deluge | grep -C 1 -- "Cmd Data:" > BV9-cmd.data





% Load the configuration data for paths. In the future, add the ability to
% pass config data from another GUI
% -------------------------------------------------------------------------
config = getConfig;


% If no file is specified, open a GUI to choose a plot config file!
% -------------------------------------------------------------------------

    [filename, pathname] = uigetfile( ...
        {  '*.txt',   'Text file (*.txt)'; ...
           '*.xlsx',  'Excel file (*.xlsx)'; ...
           '*.xls',   'Excel file (*.xls)'; ...
           '*.*',     'All Files (*.*)'}, ...
           'Pick a file', fullfile(config.dataFolderPath, '..','*.txt'));

 
% savePath = 'ORB-2/process';
% savePath = '/Users/nick/Documents/MATLAB/Data Review/stevens/flowmeter/data';

savePath = config.dataFolderPath;


% Legacy File Paths and Commands from Early Development and Debugging
% -------------------------------------------------------------------------
% fileToProcess = 'ORB-2/process/WDS-BV-0009.txt';
% fileToProcess = '/Users/nick/Documents/MATLAB/Data Review/stevens/flowmeter/delim/BV9-cmd.data'
% 
% fInfo = dir(fileToProcess);


% Open the file selected above
% -------------------------------------------------------------------------
fid = fopen(fullfile(pathname, filename));

% Read data file into 
% -------------------------------------------------------------------------
    allData = textscan(fid,'%s','Delimiter','\n');
    % close file!!!
    fclose(fid);

% Put data into an nx1 cell array of strings for parsing
% -------------------------------------------------------------------------
fileData = allData{1};
    clear allData;


% Instantiate Variables for parsing
% -------------------------------------------------------------------------
    timeCell    = cell(length(fileData),1);
    addressCell = cell(length(fileData),1);
    cmd1Cell    = cell(length(fileData),1);
    cmd2Cell    = cell(length(fileData),1);
    
    isFirstDateStamp = false;
    
    
%% Vectorized Search and Parsing
% -------------------------------------------------------------------------
    
    % Find indices of cells containing "Cmd Data:"
        IndexC = strfind(fileData, 'Cmd Data:');
        Index   = find(not(cellfun('isempty', IndexC)));    
    
    % Find indices of hex data and timestamps
        IndexHex = Index + 1;
        IndexTime = Index - 1;
        
    % Store the first line as wholeString for later parsing
        wholeString = fileData{IndexTime(1)};
        
    % Extract Timestamps and store in cell array of strings for processing
        timeRaw = regexp(fileData(IndexTime),'^\d{4}/\d{3}/\d+:\d{2}:\d{2}.\d{6}','match');
        timeCell = cat(1,timeRaw{:});
        
        clear TCofStr timeRaw;
        
    % Extract 
        hexToks = regexp(regexprep(fileData(IndexHex),'[^\w'']',''), '\w{8}','match');
        C = cat(1,hexToks{:});
        
        addressCell = C(:,1);
        cmdHex = C(:,2);
        
        hex1 = regexp(cmdHex, '\w{4}','match');
        C = cat(1,hex1{:});
        
        pyld1 = C(:,1);
        pyld2= C(:,2);
        
        cmd1Cell = hex2dec(pyld1);
        cmd2Cell = hex2dec(pyld2);
        
        clear hexToks cmdHex hex1 pyld1 pyld2 C;
        
        
    
%% Loop Through read data and parse
% -------------------------------------------------------------------------

% % This code operated in a for-next loop: fine for small retirevals but
% % painfully slow for anything large. Code retained for this release for
% % future debugging purposes and will be deleted in the next release.

% % % % % progressbar('Processing Command Data');
% % % % % for n = 1:length(fileData)
% % % % % 
% % % % %     % Check for datestamp
% % % % %     line = fileData{n};
% % % % % 
% % % % %     % Regular expression looks for the format YYYY/DDD/HH:MM:SS.ssssss
% % % % %     if regexp(line,'^\d{4}/\d{3}/\d+:\d{2}:\d{2}.\d{6}')
% % % % %         % Grab the datestamp and hold on to it
% % % % %         ds = line(1:24);
% % % % %         
% % % % %         % If first datestamp, store the line for name parsing
% % % % %         if ~ isFirstDateStamp
% % % % %             wholeString = line;
% % % % %             isFirstDateStamp = true;
% % % % %         end
% % % % %         
% % % % % 
% % % % %         % Stored datestamp. Now advance one line
% % % % %         n = n + 1;
% % % % %         line = fileData{n};
% % % % % 
% % % % % 
% % % % %         % Check for "Cmd Data:"
% % % % %         if strfind(line, 'Cmd Data:')
% % % % %             % Found Cmd Data
% % % % %             % -----------------------------------------
% % % % %             
% % % % %             % Advance one line
% % % % %             n = n + 1;
% % % % %             line = fileData{n};
% % % % % 
% % % % %             % Grab hex values
% % % % %             % -----------------------------------------
% % % % %             hs = strtrim(line);
% % % % %             hc = textscan(strtrim(line), '%2s');
% % % % %             hc = strtok(hc{1});
% % % % % 
% % % % % 
% % % % %             % Big or Small Endian ?
% % % % %             % -----------------------------------------
% % % % %             % tempAd = hex2dec(strcat(hc{4:-1:1}));
% % % % %             % tempC1 = hex2dec(strcat(hc{6:-1:5}));
% % % % %             % tempC2 = hex2dec(strcat(hc{8:-1:7}));
% % % % %             
% % % % %             tempAd = hex2dec(strcat(hc{1:4}));
% % % % %             tempC1 = hex2dec(strcat(hc{5:6}));
% % % % %             tempC2 = hex2dec(strcat(hc{7:8}));
% % % % % 
% % % % % 
% % % % %             % Add new data to arrays
% % % % %             % -------------------------------------------------------------
% % % % % 
% % % % % % Old routine, cat each variable - seemed pretty slow            
% % % % % %             timeCell    = cat(1,timeCell,       ds);
% % % % % %             addressCell = cat(1,addressCell,	tempAd);
% % % % % %             cmd1Cell    = cat(1,cmd1Cell,       tempC1);
% % % % % %             cmd2Cell    = cat(1,cmd2Cell,       tempC2);
% % % % %             
% % % % %             timeCell(n,1)       = {ds};
% % % % %             addressCell(n,1)    = {tempAd};
% % % % %             cmd1Cell(n,1)       = {tempC1};
% % % % %             cmd2Cell(n,1)       = {tempC2};
% % % % %             
% % % % % 
% % % % %         else
% % % % %             % no Cmd Data after datestamp means ignore datestamp and restart
% % % % %         end
% % % % % 
% % % % %     end
% % % % %     
% % % % % %     progressbar(n/length(fileData));
% % % % % 
% % % % % end



%% retrieval file is parsed. Construct fd structure for use in review tools
%
% pull out the id String from the raw data... known widths for the
% non-delim retrievals
% -------------------------------------------------------------------------

    idString = strtrim(wholeString(25:25+81));
    info = getDataParams(idString);


% fd = 
% 
%                 ID: '1014'
%               Type: 'PCVNC'
%             System: 'RP1'
%         FullString: 'RP1 PCVNC-1014 State'
%                 ts: [1x1 timeseries]
%            isValve: 1
%     isProportional: 1
%           position: [1x1 timeseries]              
% 
% 
% fd.ts
%   timeseries
% 
%   Common Properties:
%             Name: 'RP1 PCVNC-1014 State'
%             Time: [166x1 double]
%         TimeInfo: [1x1 tsdata.timemetadata]
%             Data: [166x1 double]
%         DataInfo: [1x1 tsdata.datametadata]
        
% Instantiate a new fd structure
% -------------------------------------------------------------------------

    fd = newFD;

        fd.FullString = info.FullString;
        fd.ID = info.ID;
        fd.System = info.System;
        fd.Type = 'Set Point';

        fd.isValve = false;
        fd.hasCmdData = true;


    timeVect = makeMatlabTimeVector(timeCell, false, false);
    valveCom1 = timeseries( cmd1Cell, ...
                            timeVect, ...
                            'Name', info.FullString);

    valveCom2 = timeseries( cmd2Cell, ...
                            timeVect, ...
                            'Name', info.FullString);        

    tsPercent = timeseries( valveCom1.Data ./ 300 , ...
                            timeVect, ...
                            'Name', info.FullString);                    
                    
        fd.ts = tsPercent;
        fd.valveCom1 = valveCom1;
        fd.valveCom2 = valveCom2;

        
% Generate filename and save fd
% -------------------------------------------------------------------------
    fileName = strcat(info.ID, '-Cmd');

    save(fullfile(savePath, [fileName '.mat']),'fd','-mat')