function marker (fig)

% deltat is a helper routine designed to operate data-tip pairs in a plot
% finds two data tips and displays the elapsed time between them
%
%   USE:
%   
%   On a plot, add two data-cursors.
%
%   run deltat(figureNumber)
%




dcm_obj = datacursormode(fig);
q = getCursorInfo(dcm_obj);


datestr(abs(q(2).Position(1)-q(1).Position(1)),'HH:MM:SS.FFF')




end