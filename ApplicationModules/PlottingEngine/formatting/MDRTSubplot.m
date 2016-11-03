function [ hax ] = MDRTSubplot( plotsHigh, plotsWide, gap, marginWidth, marginHeight )
%MDRTSubplot creates subplot axes for MDRT plotting tools
%   

%	Default page setup for landscape US Letter
        graphsInFigure = 1;
        graphsPlotGap = 0.05;
        GraphsPlotMargin = 0.06;
        
% Original tight_supblot code

% Handle input arguments
    if nargin < 3; gap = .02; end
    if nargin < 4 || isempty(marginWidth); marginWidth = .05; end
    if nargin < 5; marginHeight = .05; end

% Handle vectorized gap and margin inputs
    
    if numel(gap)==1; 
        gap = [gap gap];
    end

    if numel(marginHeight)==1; 
        marginHeight = [marginHeight marginHeight];
    end

    if numel(marginWidth)==1; 
        marginWidth = [marginWidth marginWidth];
    end

axh = (1-sum(marginWidth)  - (plotsHigh-1) * gap(1)) / plotsHigh; 
axw = (1-sum(marginHeight) - (plotsWide-1) * gap(2)) / plotsWide;

py = 1 - marginWidth(2) - axh; 

% hax = zeros(plotsHigh*plotsWide,1);
hax = {};
ii = 0;
for ih = 1:plotsHigh
    px = marginHeight(1);
    
    for ix = 1:plotsWide
        ii = ii+1;
        hax = vertcat( axes('Units','normalized', ...
            'Position',[px py axw axh], ...
            'XTickLabel','', ...
            'YTickLabel','', ...
            'HitTest', 'off') );

        
        px = px+axw+gap(2);
    end
    py = py-axh-gap(1);
end
        
        
        
end

