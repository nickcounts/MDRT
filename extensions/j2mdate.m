function [ DateNumber ] = j2mdate( JulianDateString )
%J2MDATE Julian Date String Form to MATLAB Serial Date Number Form
%
%   DateNumber = j2mdate(JulianDateString)
%
%   Summary: This function converts serial date numbers from the Excel serial
%            date number format to the MATLAB serial date number format.
%
%   Inputs: JulianDateString - Nx1 or 1xN vector of date strings in
%           CCT's Retrieval Julian format
%
%   Outputs: Nx1 or 1xN vector of serial date numbers in MATLAB serial date
%            number form
%
%   Example: StartDate = '2013/344/16:07:57.847748'
%            
%
%            EndDate = x2mdate(StartDate);
% 
%            returns:
%
%            EndDate = 729706

if iscell(JulianDateString)
%   Process as a cell array of strings

end
    



[tokens] = regexp(JulianDateString, ' |-|/|:', 'split');

year    = str2double(tokens(:,1));
day     = str2double(tokens(:,2));
hour    = str2double(tokens(:,3));
minute  = str2double(tokens(:,4));
second  = str2double(tokens(:,5));

DateNumber = datenum(year,zeros(size(tokens,1),1),day,hour,minute,second);

% keyboard

end

