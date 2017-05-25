function m = minute(d,f)
%MINUTE Minute of date or time.
%   M = MINUTE(D) returns the minute given a serial date number or a
%   date string, D.
%
%	M = MINUTE(S,F) returns the minute of one or more date strings S using 
%   format string F. S can be a character array where each
%	row corresponds to one date string, or one dimensional cell array of 
%	strings.  
%
%	All of the date strings in S must have the same format F, which must be
%	composed of date format symbols according to Table 2 in DATESTR help.
%	Formats with 'Q' are not accepted.  
%
%   For example, m = minute(728647.559054842) or
%   m = minute('19-Dec-1994, 13:25:08.17') returns m = 25.
%
%   See also DATEVEC, SECOND, HOUR.

%  Copyright 1995-2009 The MathWorks, Inc.

if nargin < 1
   d = now();
end
if nargin < 2
  f = '';
end

if ischar(d) 
   d = datenum(d,f);
   sizeD = size(d); 
   
elseif iscell(d)
   sizeD = size(d);   
   d = datenum(d(:),f);
   
elseif isnumeric(d)
   sizeD = size(d); 
   
else
   error(message('finance:minute:invalidInputClass'))
end

% Generate date vectors from dates
c = datevecmx(d(:), 1);

% Extract minute
m = c(:, 5);

% Reshape into the correct dims
m = reshape(m, sizeD);


% [EOF]
