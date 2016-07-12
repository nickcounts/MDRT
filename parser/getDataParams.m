function [ info ] = getDataParams( str )
%getDataParams 
%
%   getDataParams is a helper function for processDelimFiles.m
%   
%   str is a string containing the long descriptor from a .delim file. This
%   variable is parsed using regular expressions and a determination of the
%   type of FD is made.
%
%   Based on the determination, the variable info (Struct) is assembled and
%   returned which contains basic information about the FD to be stored as
%   part of the parsed data for ease of access.
%
%   Example info struct
%
%   Fields:
%
%             ID		 '1016' (str)
%           Type		 'FM'   (str)
%         System		 'RP1'  (str)
%     FullString		 'RP1 FM-1016 Coriolis Meter  Mon' (str)
%        isValve		 0  (bool)
%
%
% N. Counts - Spaceport Support Services. 2013
%

t = regexp(str, ' |-', 'split');

info = struct('ID',t(3), 'Type',t(2), 'System',t(1), 'FullString',str);

    if( containsi(t,'flow') && ...
        containsi(t,'control') && ...
        containsi(t,'value') )

        % Flow Control Value : Return appropriate struct info

        info.Type = 'Range';


        if( containsi(t,'max') || ...
            containsi(t,'upper') || ...
            containsi(t,'maximum') )
            % Max value

            idStr = 'Flow Control Max';

        elseif (containsi(t,'min') || ...
            containsi(t,'lower') || ...
            containsi(t,'minimum') )
            % Min value

            idStr = 'Flow Control Min';

        end

        info.ID = idStr;
    
        
    % Example setpoint short string: FLS Storage Tank Pressure Set Point
    elseif( ( containsi(t, 'set') && containsi(t,'point') ) || ...
            containsi(t, 'setpoint') )
            
        % Set Point Value Identified: Return appropriate struct info
            
                          
        info.Type = 'Set Point';    
        info.ID = info.FullString;        
        
    end

end
    
% Helper function: Does larger string contain the token?
function [ hasStr ] = containsi( str, tok )
    ca = ~cellfun('isempty',strfind(lower(str), lower(tok)));
    hasStr = logical(max(ca));
end
