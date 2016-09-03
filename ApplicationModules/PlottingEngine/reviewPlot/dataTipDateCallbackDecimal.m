function output_txt = dataTipDateCallbackDecimal(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

pos = get(event_obj,'Position');

% Y Value precision scaling/formatting
% xFormatString = '%1.2e';

% xFormatString = '%i';
% 
%     if (pos(2) < 99999)
%         xFormatString = '%i';
%         disp('YOU JUST RAN ME')
%     elseif (pos(2)) < 9999
%         xFormatString = '%5f';
%         keyboard
%         
%     
%     elseif (pos(2)) < 999
%         xFormatString = '%4f';
%     
%     elseif (pos(2)) < 500;
%         xFormatString = '%3.1f';
%     
%     elseif (pos(2)) < 10;
%         xFormatString = '%2.2f';
%     
%     end
    
    
    if abs(pos(2)) < 10
        xFormatString = '%2.2f';
        
    elseif abs(pos(2)) < 500;
        xFormatString = '%3.1f';
        
    elseif abs(pos(2)) < 1000;
        xFormatString = '%3.1f';
        
    else
        xFormatString = '%.f';

    end

output_txt = {['X: ', datestr(pos(1),'HH:MM:SS.FFF') ],...
    ['Y: ',num2str( pos(2), xFormatString )]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

