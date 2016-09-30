iconFile = '~/Documents/MATLAB/MARS Review Tool/MDRT/resources/images/complete_icon_146x146.png';

fig = figure;

ax1 = axes('Parent', fig, 'Units', 'pixels', 'Position', [100, 100, 146 146])

% imshow(iconFile, 'Parent', ax1)
%% ?

rec = rectangle('Position', [0 0 1 1], 'Curvature', [1 1]);
rec.EdgeColor = 'green';
rec.FaceColor = 'green';



tl = annotation('textbox', [0 0 1 1], 'String', '?' );
tl.Color = 'white';
tl.Parent = ax1;
tl.FontSize = 100;
tl.FontWeight = 'bold';
tl.VerticalAlignment = 'middle';
tl.HorizontalAlignment = 'center';

%%

hfig = figure;
hfig.Position = [129   685   965   420];


today = floor(now);
thisYear = str2double(datestr(today, 'YYYY'));

nextYear = sprintf('%d', thisYear + 1);
lastYear = sprintf('%d', thisYear - 1);
thisYear = sprintf('%d', thisYear);

startDate = datenum(strjoin({'Jan 1,', thisYear}));
stopDate  = datenum(strjoin({'Jan 1,', nextYear}));
% datenum(strjoin({nextDate, nextYear}))

%% 

% for i = 1:abs(stopDate - startDate + 1)
%    % instantiate  
%     
%     
% end


numBoxes = abs(stopDate - startDate + 1);

dayBox = cell(7,ceil(numBoxes/7));
dow = mod(fix(startDate)-2,7)+1;

week = 1;

gapSize = 1;

padding = 30;
guiWidth  = hfig.Position(3);
guiHeight = hfig.Position(4);
calWidth  = guiWidth  - (2*padding) + (52*gapSize);


weekCols = size(dayBox, 2);

squareSize = ceil( calWidth / (weekCols+1) );


calHeight = guiHeight - (7*squareSize) + (6*gapSize);
startYPos = calHeight + ((guiHeight - calHeight) / 2 );



squareSize = 10;
gapSize = 2;

for i = startDate:stopDate
    
    % The day of the week (number)
    dow = mod(fix(i)-2,7)+1;
    
    dayBox(dow, week) = {i};
%     uicontrol(hfig, ...
%                 'Position',     [padding + ((week-1)*squareSize) , ...
%                                  startYPos - ((dow-1)*squareSize), ...
%                                  squareSize, ...
%                                  squareSize], ...
%                  'String',      datestr(i, 'DD') ...
%                                  );
                             
    uicontrol(hfig, 'Style', 'text', ...
                'Position',     [padding + ((week-1)*(squareSize+gapSize)) , ...
                                 startYPos - ((dow-1)*(squareSize+gapSize)), ...
                                 squareSize, ...
                                 squareSize], ...
                 ...'String',      datestr(i, 'DD'), ...
                 'BackgroundColor', [209/255, 230/255, 129/255] ...
                             );
                                 
%     pause(0.25)
                             
    if dow == 7
        week = week+1;
    end
    
end






