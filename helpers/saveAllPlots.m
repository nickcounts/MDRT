for i = 1:length(graph)
%     saveas(figureHandle(i), ...
%         strcat('./output/', char(graph(i).name)) ...
%         , 'pdf')
    

if exist(fullfile(pwd, 'review.cfg'),'file')
   
    load('review.cfg','-mat');
    
end


%     path = '~/Documents/MATLAB/Data Review/ORB-1/plots/';

    path = config.outputFolderPath;

    saveas(figureHandle(i), strcat(path, char(graph(i).name)), 'pdf')

    
end