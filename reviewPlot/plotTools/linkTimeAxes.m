function linkTimeAxes( varargin )


%This works if called from the figure's menu
figureHandle = varargin{1}.Parent.Parent;

% fig = 1;

hgo = findobj( figureHandle, 'Type', 'Axes');

% remove 'suptitle'
axesElements = hgo(arrayfun(@(e) ~isequal(e.Tag,'suptitle'), hgo));


linkaxes(axesElements,'x');