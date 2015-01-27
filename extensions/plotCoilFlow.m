function plotCoilFlow(zdata1)
%CREATEFIGURE(ZDATA1)
%  ZDATA1:  contour z

%  Auto-generated by MATLAB on 05-Jun-2012 11:44:22

% Create figure
figure1 = figure('Colormap',...
    [0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0 1;0 0.142857149243355 0.857142865657806;0 0.28571429848671 0.714285731315613;0 0.428571432828903 0.571428596973419;0 0.571428596973419 0.428571432828903;0 0.714285731315613 0.28571429848671;0 0.857142865657806 0.142857149243355;0 1 0;0.105882354080677 0.895098030567169 0;0.211764708161354 0.790196061134338 0;0.317647069692612 0.685294091701508 0;0.423529416322708 0.580392181873322 0;0.529411792755127 0.475490212440491 0;0.635294139385223 0.37058824300766 0;0.74117648601532 0.265686273574829 0;0.847058832645416 0.160784319043159 0;0.855108380317688 0.152321979403496 0;0.86315792798996 0.143859654664993 0;0.871207416057587 0.13539731502533 0;0.879256963729858 0.126934990286827 0;0.88730651140213 0.118472658097744 0;0.895356059074402 0.110010325908661 0;0.903405606746674 0.101547993719578 0;0.911455094814301 0.0930856615304947 0;0.919504642486572 0.0846233293414116 0;0.927554190158844 0.0761609897017479 0;0.935603737831116 0.0676986575126648 0;0.943653225898743 0.059236329048872 0;0.951702773571014 0.0507739968597889 0;0.959752321243286 0.0423116646707058 0;0.967801868915558 0.0338493287563324 0;0.97585141658783 0.0253869984298944 0;0.983900904655457 0.0169246643781662 0;0.991950452327728 0.0084623321890831 0;1 0 0]);

% Create axes
axes1 = axes('Parent',figure1,'Layer','top');
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 5]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[1 18]);
box(axes1,'on');
hold(axes1,'all');

% Create contour
contour(zdata1,'LineColor',[0 0 0],'Fill','on','DisplayName','coil1100',...
    'Parent',axes1);

% Create colorbar
colorbar('peer',axes1);

