function [ monthNumber ] = month( dateNumber )
%MONTH returns the numerical month for a given datenum
%   Expects a Matlab datenum input and returns a numerical
%
%   January returns 1, December returns 12.
%
%   No input error checking at this time.
%
%   month(datenum('March 29, 1981'))
%
%   ans =
%
%   3
%
%   Counts 2016 VCSFA

    monthNumber = str2num(datestr(dateNumber,'mm'));
end

