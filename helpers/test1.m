o  = load('/Users/nick/Documents/MATLAB/ORB-D1/Data Files/2917.mat');
i = load('/Users/nick/Documents/MATLAB/ORB-D1/Data Files/2907.mat');

x = o.fd.ts.Data;
z = i.fd.ts.Data;


% % t = 0:0.01:10-0.01;
% % 
% % x = cos(2*pi*0.5*t) + randn(size(t))*0.1;
% % z = sin(2*pi*0.5*t) + randn(size(t))*0.1; 
% 
% % z([1:350 550:end]) = 0;
% 
% [c,lags] = xcorr(x,z,'none');

figure(99)

plot(o.fd.ts);
hold on;
plot(i.fd.ts, '-r');
legend('out','in')


% 
% % z = x; z([1:350 550:end]) = [];
% % [c,lags] = xcorr(x,z,'none');
% subplot(211), plot(o.fd.ts);
% hold on;
% plot(i.fd.ts, '-r');
% legend('out','in')
% subplot(212), plot(lags,c,'k'), xlabel('lags [steps]'), ylabel('corr')