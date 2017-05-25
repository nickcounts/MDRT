%% Treeview
%  Version : v1.1
%  Author  : E. Ogier
%  Release : 20th july 2016
%
%  Object  : test of TreeView object

function Test_TreeView()

% Figure
Figure = ...
    figure('Name',        'Treeview',...
           'Color',       'w',...
           'NumberTitle', 'off',...
           'Toolbar',     'auto',...
           'Menubar',     'figure');           
            
% Tree view position       
Position = get(Figure,'Position');
Position(1) = Position(3)-200-4+3;
Position(2) = 3;
Position(3) = 200;
Position(4) = Position(4)-3;

% Tree view object
TV = TreeView('Figure',     Figure,...
              'Position',   Position,...
              'RootName',   'Test root',...
              'Directory',  'Test',...
              'Extensions', {'.*'},...
              'SelectFcn',  @SelectFcn);
          
% Graphical create of treeview          
TV.create();

% Expansion of successive nodes
TV.expand();

% Figure resize function
set(Figure,'ResizeFcn',@ResizeFcn);

    % Figure resize function
    function ResizeFcn(~,~)
        
        Position = get(Figure,'Position');        
        Position(1) = Position(3)-200-4+3;
        Position(2) = 3;
        Position(3) = 200;
        Position(4) = Position(4)-3;
        
        TV.resize(Position);
    
    end

    % Treeview select function
    function SelectFcn(Selection)
        
        disp('Selected node(s):')
        disp(Selection');
        
    end

end
