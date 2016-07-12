function samplesPerSecond = getSampleRate( dataBrush )
% getSampleRate
%
% samplesPerSecond = getSampleRate( dataBrush )
%
% Returns samples/second from data in time,value columns.
%
%     dataBrush = [ time, value;
%                   time, value;
%                   time, value;
%                   time, value]
%
%   Also accepts MARS fd structures and Matlab timeseries objects
%
% Counts, 2016 VCSFA

%% Handle different variable types as inputs

    switch class(dataBrush)
        case 'struct'
            % Check to see if the structure is an fd
            if isfield(fd, 'ts')
                dataBrush = [dataBrush.ts.Time dataBrush.ts.Data];
            end
            
        case 'timeseries'
            dataBrush = [dataBrush.Time dataBrush.Data];
            
        case 'double'
            if size(dataBrush,2) == 2
                % has 2 columns
            else
                if size(dataBrush, 1) == 2 && size(dataBrush, 2) > 2
                    % reshape data!
                    dataBrush = dataBrush';
                else
                    disp('malformed data input')
                end
            end
            
        otherwise
            disp('Unknown data type passed')
    end



%% Calculate the sample rate    

    secondsInDay = (24 * 60 * 60);

    oneSecond = 1/secondsInDay;
    
    delta = abs(dataBrush(1,1) - dataBrush(end,1));
    
    secondsInSample = delta / oneSecond;

    samplesPerSecond = length( dataBrush(:,1)) / secondsInSample;