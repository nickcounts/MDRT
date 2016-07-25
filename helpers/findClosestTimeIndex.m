function [ index ] = findClosestTimeIndex( data, value )
%findClosestTimeIndex Summary of this function goes here
%   Searches array/matrix data for the closest (numerical) match to value
%   and returns the index of the closest match.



% f= [1990 1998 2001 2004 2001 33333]


[c index] = min(abs(data-value));

% closestValues = f(index) % Finds first one only!


end

