function [ point ] = linterp( x, x1, y1, x2, y2 )
%linterp(x, x1, y1, x2, y2)
%
%   Returns the y value from the (x,y) linearly interpolated between
%   (x1,y1) and (x2,y2).
%

point = y1+ (x - x1)*( (y2-y1)/(x2-x1) );

end

