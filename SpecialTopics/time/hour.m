function h = hour(d,f) 
%HOUR  Hour of date or time. 
%   H = HOUR(D) returns the hour of the day given a serial date number or 
%   a date string, D. 
% 
%	H = HOUR(S,F) returns the hour of one or more date strings S using 
%   format string F. S can be a character array where each
%	row corresponds to one date string, or one dimensional cell array of 
%	strings.  
%
%	All of the date strings in S must have the same format F, which must be
%	composed of date format symbols according to Table 2 in DATESTR help.
%	Formats with 'Q' are not accepted.  
%
%   For example, h = hour(728647.5590548427) or  
%   h = hour('19-Dec-1994, 13:24:08.17') returns h = 13. 
%        
%   See also DATEVEC, SECOND, MINUTE. 
 
%   Copyright 1995-2006 The MathWorks, Inc.
 
if nargin < 1 
  d = now() 
end 
if nargin < 2
  f = '';
end

tFlag = false;   %Keep track if input was character array 
if ischar(d)
    d = datenum(d,f);
    tFlag = true;
end

% Generate date vectors
if nargin < 2  || tFlag
  c = datevec(d(:));
else
  c = datevec(d(:),f);
end

h = c(:,4);     % Extract hour 
if ~ischar(d) 
  h = reshape(h,size(d)); 
end
