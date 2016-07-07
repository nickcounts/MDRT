%% UI Toolbar Experiments

% Load the Redo icon
icon = fullfile(matlabroot,'/toolbox/matlab/icons/greenarrowicon.gif');
[cdata,map] = imread(icon);
 
% Convert white pixels into a transparent background
map(find(map(:,1)+map(:,2)+map(:,3)==3)) = NaN;
 
% Convert into 3D RGB-space
cdataRedo = ind2rgb(cdata,map);
cdataUndo = cdataRedo(:,[16:-1:1],:);



% Add the icon (and its mirror image = undo) to the latest toolbar
hUndo = uipushtool('cdata',cdataUndo, 'tooltip','undo', 'ClickedCallback','uiundo(gcbf,''execUndo'')');
hRedo = uipushtool('cdata',cdataRedo, 'tooltip','redo', 'ClickedCallback','uiundo(gcbf,''execRedo'')');

%% Second Example - doesn't work

% %SETUP FIGURE AND FIND TOOLBAR
% hFig= figure;
% hToolbar = findall(gcf,'tag','FigureToolBar');
% jToolbar = get(get(hToolbar,'JavaContainer'),'ComponentPeer');
%  
% %ADD BUTTON
% jButton = javax.swing.JButton('Toolbar Button'); 
% jToolbar.add(jButton, 'East');
% jToolbar.revalidate;
% jToolbar.repaint;
%  
% %GET STATUS BAR 
% sb = statusbar(hFig, 'Status Bar');
% jb = javax.swing.JButton('Status Button');
% sb.add(jb,'East');
% sb.revalidate;
% sb.repaint;

%% Third Example
% 
%           h = figure('ToolBar','none')
%           ht = uitoolbar(h)
%           a = [.05:.05:0.95];
%           b(:,:,1) = repmat(a,19,1)';
%           b(:,:,2) = repmat(a,19,1);
%           b(:,:,3) = repmat(flip(a,2),19,1);
%           hpt = uipushtool(ht,'CData',b,'TooltipString','Hello')