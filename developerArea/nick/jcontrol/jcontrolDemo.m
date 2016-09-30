function jcontrolDemo()
%jcontrolDemo demo file to illustrate some uses of jcontrol objects
%
% Cut-and-paste this file anywhere onto your MATLAB path - but it should be
% moved from the @jcontrol folder as it is not a class method file
%

% Get rid of any existing figures
delete(findobj('Name', 'jcontrolDemo'));

% Set up a new figure window
fh=figure('Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8], 'Name', 'jcontrolDemo', 'Color', [0.9 0.9 0.9]);

% Generate some test data and display it using standard MATLAB commands
x=0:0.1:100;
y=sin(x);
line(x,y, 'Tag', 'DemoData');
set(gca, 'Position', [0.3 0.7 0.6 0.2]);

% -------------- Now, let's use some jcontrols ----------------------

% Add a scrollpane to the left of the figure, put a JTable in the
% viewport and add the data plotted above to the table
scrollpane=jcontrol(fh, 'javax.swing.JScrollPane', 'Position', [0 0 0.2 1]);
htable=javax.swing.JTable(numel(x), 2);
scrollpane.setViewportView(htable);
htable.setGridColor(java.awt.Color(0,0,0));
htable.setVisible(true);
% Remember we have zero-based indexing in Java
for k=0:numel(x)-1
    htable.setValueAt(num2str(x(k+1)),k,0);
    htable.setValueAt(num2str(y(k+1)),k,1);
end
htable.getColumnModel().getColumn(0).setHeaderValue('X');
htable.getColumnModel().getColumn(1).setHeaderValue('Y');

% Choose the function to plot using a JComboBox
combo=javax.swing.JComboBox();
combo.addItem('sin(x)');
combo.addItem('cos(x)');
combo.addItem('<html>e<sup>sin(x)</sup></html>');
lbl=javax.swing.JLabel('y=');
lbl.setBackground(java.awt.Color(1,1,1));
jcontrol(fh, lbl, 'Position', [0.3 0.9 0.05 0.05]);
jcombo=jcontrol(fh, combo, 'Position', [0.32 0.9 0.15 0.05]);
jcombo.setBackground(java.awt.Color(1,1,1));
% Set up callbacks for function selection
set(jcombo, 'ActionPerformedCallback', {@SetFunction, htable});

% Show a JTree in a JScrollpane
root=javax.swing.tree.DefaultMutableTreeNode('Root');
treeModel=javax.swing.tree.DefaultTreeModel(root);
for k=1:20
    root.insert(javax.swing.tree.DefaultMutableTreeNode(sprintf('Item %d',k)), k-1);
end
tree=javax.swing.JTree(treeModel);
scrollpane=javax.swing.JScrollPane();
scrollpane.setViewportView(tree);
scrollpane.setVerticalScrollBarPolicy(javax.swing.ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
scrollpane.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
scrollpane.setBorder(javax.swing.BorderFactory.createTitledBorder('Border'));
jcontrol(fh, scrollpane,'Position', [0.25 0.35 0.15 0.25]);

% Add a color chooser. Use a MATLAB timer instead of a standard callback to
% update the color of the line plotted above
cc=jcontrol(fh, javax.swing.JColorChooser(),'Position', [0.425 0.32 0.55 0.35]);
tt=timer('ExecutionMode', 'fixedRate', 'Period', 0.1,'TimerFcn', {@timerFunction, cc} );
set(fh,'CloseRequestFcn', {@my_closefcn, tt})

% Add a button with some some graphics
icon=javax.swing.ImageIcon(java.net.URL('http://www.kcl.ac.uk/content/1/c6/02/75/88/coats-of-arms.jpg'));
gbutton=jcontrol(fh, javax.swing.JButton(icon), 'Position', [0.3 0.05 0.5 0.25]);
set(gbutton, 'Units', 'pixels');
pos=get(gbutton, 'Position');
pos(3)=icon.getIconWidth()*1.2;
pos(4)=icon.getIconHeight()*1.2;
set(gbutton, 'Position', pos);
set(gbutton, 'Units', 'normalized');
set(gbutton, 'MouseClickedCallback', 'web(''http://sigtool.sourceforge.net/'', ''-browser'')');
gbutton.setToolTipText('Click here to visit the author''s web page');

% Start the timer
start(tt);

return
end

function my_closefcn(hObject, EventData, tt)
% Housework
stop(tt);
delete(tt);
delete(hObject);
return
end

function SetFunction(hObject, EventData, tobj)
% Update the line and table data
lh=findobj('Tag', 'DemoData');
x=get(lh, 'XData');
switch char(hObject.getSelectedItem())
    case 'sin(x)'
        y=sin(x);
    case 'cos(x)'
        y=cos(x);
    case '<html>e<sup>sin(x)</sup></html>'
        y=exp(sin(x));
end
set(lh, 'YData', y);
for k=0:numel(x)-1
    tobj.setValueAt(num2str(y(k+1)),k,1);
end
return
end

function timerFunction(hObject, EventData, cc)
% Update the color of the line if the color selection has changed
lh=findobj('Tag', 'DemoData');
c=cc.getColor();
c=[c.getRed(), c.getGreen(), c. getBlue()]/255;
if c(1)==1 && c(2)==1 && c(3)==1
    set(lh, 'color', 'b');
else
set(lh, 'Color', c );
end
return
end