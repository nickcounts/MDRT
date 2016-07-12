load disney.mat
weekly = toweekly(dis);
dates = (weekly.dates);
price = fts2mat(weekly.CLOSE);
% Set the|lag| input argument for the window size for the moving average.

window_size = 12;
% Calculate the simple moving average.

simple = tsmovavg(price,'s',window_size,1);
% Calculate the exponential weighted moving average moving average.

exp = tsmovavg(price,'e',window_size,1);
% Calculate the triangular moving average moving average.

tri = tsmovavg(price,'t',window_size,1);


% Calculate the weighted moving average moving average.

semi_gaussian = [0.026 0.045 0.071 0.1 0.12 0.138];
semi_gaussian = [semi_gaussian fliplr(semi_gaussian)];
weighted = tsmovavg(price,'w',semi_gaussian,1);




% Calculate the modified moving average moving average.

modif = tsmovavg(price,'m',window_size,1);
% Plot the results for the five moving average calculations for Disney stock.

plot(dates,price,...
    dates,simple,...
    dates,exp,...
    dates,tri,...
    dates,weighted,...
    dates,modif)
datetick
legend('Stock Price','Simple','Exponential','Triangular','Weighted',...
    'Modified','Location','NorthWest')
title('Disney Weekly Price & Moving Averages')