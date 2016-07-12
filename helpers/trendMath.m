function [ output_args ] = trendMath( dataBrushVariable )
%trendMath.m
%   Calculates basic linear trends from data-brush variables.
%   Time handling updated to display durations greater than 24 hours
%
%       USAGE GUIDE:
%
%           * Use the data-brush to select a portion of a plot you wish to
%           examine for trend data.
%
%           * Save the data to a workspace variable (i.e. trendData)
%
%           * Run trendMath:   trendMath(trendData)
%
%           * trendMath.m will output start, stop, duration, dy/dt and
%           linearity to the console
%           


t1 = dataBrushVariable(1,1);
t2 = dataBrushVariable(end,1);

y1 = dataBrushVariable(1,2);
y2 = dataBrushVariable(end,2);

dy = y2 - y1;
dt = abs(t2-t1);

rate = dy/dt;
minutePerDay = mod(datenum('00:01:00.0'),1);

rate = rate * minutePerDay;

startString = datestr(t1,'HH:MM:SS.FFF');
stopString =  datestr(t2,'HH:MM:SS.FFF');


%% Generate the duration string

% Instantiate durationString as a blank string literal to be appended
% according to the duration.

durationString = '';

if (dt > 1) 
        
    % This if-then loop generates the day(s) portion, if required.
    if dt >= 2
        % More than one day elapsed, fix string
        durationString = [durationString, sprintf('%i days, ',  floor(dt)), ' ', ' '];
    else
        durationString = [durationString, sprintf('%i day, ', floor(dt)), ' ', ' '];
    end
    
end

% Finally, append the hours:minutes:seconds.milliseconds in all cases
durationString = strcat(durationString, datestr(dt,'HH:MM:SS.FFF'));

%Linear meathods

p = polyfit(dataBrushVariable(:,1)-t1,dataBrushVariable(:,2),1);


yfit = polyval(p,dataBrushVariable(:,1)-t1);

yresid = dataBrushVariable(:,2) - yfit;

SSresid = sum(yresid.^2);

SStotal = (length(dataBrushVariable)-1) * var(dataBrushVariable(:,2));

rsq = 1 - SSresid/SStotal;





disp(sprintf('Start\t\tend\t\tduration'))
disp(sprintf('%s\t%s\t%s',startString, stopString, durationString))

disp(sprintf('Delta\t\tdy/min\t\tr^2'))
disp(sprintf('%5.2f\t\t%5.3f\t\t%1.4f',dy, rate, rsq))



end

