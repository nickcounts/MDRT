function s = second(d,f) 
%SECOND Seconds of date or time. 
%   S = SECOND(D) returns the seconds given a serial date number or a 
%   date string, D. 
%        
%	S = SECOND(S,F) returns the second of one or more date strings S using 
%   format string F. S can be a character array where each
%	row corresponds to one date string, or one dimensional cell array of 
%	strings.  
%
%	All of the date strings in S must have the same format F, which must be
%	composed of date format symbols according to Table 2 in DATESTR help.
%	Formats with 'Q' are not accepted.  
%
%   For example, s = second(728647.558427893) or  
%   s = second('19-Dec-1994, 13:24:08.17') returns s = 8.17. 
%   
%   See also DATEVEC, MINUTE, HOUR. 
  
%   Copyright 1995-2008 The MathWorks, Inc.
 
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
   error(message('finance:second:invalidInputClass'))
end

% Generate date vectors from dates. 
c = datevec(d(:));

% Extract seconds. Multiply by 1000 then round the result to make sure we avoid
% roundoff errors for milliseconds.
s = c(:, 6);
s = round(1000.*s)./1000;

% Reshape into the correct dims
s = reshape(s, sizeD);


% [EOF]
