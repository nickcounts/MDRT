%% Treeview
%  Version : v1.1
%  Author  : E. Ogier
%  Release : 20th july 2016
%  
%  OBJECT METHODS :
%
%  - TV = TreeView(PROPERTY1,VALUE1,PROPERTY2,VALUE2,...) : Create a treeview whose properties PROPERTY# are equal to values VALUE#
%  - TV.set(PROPERTY1,VALUE1,PROPERTY2,VALUE2,...)        : Set properties PROPERTY# with values VALUE#
%  - TV.get(PROPERTY)                                     : Get property PROPERTY#
%  - TV.create()                                          : Create the graphical objects of treeview
%  - TV.expand()                                          : Expand all the folded nodes of treeview
%  - TV.expand(LEVEL)                                     : Expand the folded nodes whose level is inferior or equal to LEVEL
%  - TV.resize()                                          : Resize treeview with the previously defined position (property POSITION)
%  - TV.resize(POSITION)                                  : Resize treeview with POSITION argument
%  
%  OBJECT PROPERTIES <default>
%
%  - FIGURE     : treeview parent figure, defined by user            : figure handle                    <see Object.create(), %Default figure>
%  - POSITION   : treeview position in figure [pixel]                : [abscissa ordinate width height] <see Object.create(), %Default position>
%  - DIRECTORY  : treeview source directory                          : string                           <pwd>
%  - EXTENSIONS : list of the extensions of treeview displayed files : string cell                      <{'.*'}>
%  - ROOTNAME   : graphical root name                                : string                           <'Root'>
%  - SELECTFCN  : callback executed after selection                  : anonymous function               <>
%                 - callback input    : selected nodes (string cell)
%                 - multiple selection: buttons [CTRL] and [SHIFT]
%
%  EXAMPLE:
%
%  function Test_TreeView()
%  
%  % Figure
%  Figure = ...
%      figure('Name',        'Treeview',...
%             'Color',       'w',...
%             'NumberTitle', 'off',...
%             'Toolbar',     'auto',...
%             'Menubar',     'figure');      
%                
%  % Tree view position       
%  Position = get(Figure,'Position');
%  Position(1) = Position(3)-200-4+3;
%  Position(2) = 3;
%  Position(3) = 200;
%  Position(4) = Position(4)-3;
%  
%  % Tree view object
%  TV = TreeView('Figure',     Figure,...
%                'Position',   Position,...
%                'RootName',   'Test root',...
%                'Directory',  'Test',...
%                'Extensions', {'.*'},...
%                'SelectFcn',  @SelectFcn);
%            
%  % Graphical create of treeview          
%  TV.create();
%  
%  % Expansion of successive nodes
%  TV.expand();
%  
%  % Figure resize function
%  set(Figure,'ResizeFcn',@ResizeFcn);
%  
%      % Figure resize function
%      function ResizeFcn(~,~)
%          
%          Position = get(Figure,'Position');        
%          Position(1) = Position(3)-200-4+3;
%          Position(2) = 3;
%          Position(3) = 200;
%          Position(4) = Position(4)-3;
%          
%          TV.resize(Position);
%      
%      end
%  
%      % Treeview select function
%      function SelectFcn(Selection)
%          
%          disp('Selected node(s):')
%          disp(Selection');
%          
%      end
%  
%  end

classdef TreeView < hgsetget
    
    % Properties (public access)
    properties (Access = 'public')
        Figure     = [];                            % Treeview parent figure
        Position   = [];                            % Treeview position in figure [pixel]
        Directory  = pwd;                           % Treeview source directory
        Extensions = {'.*'};                        % List of the extensions of treeview displayed files
        RootName   = 'Root';                        % Graphical root name
        SelectFcn  = [];                            % Callback executed after selection
    end
    
    % Properties (private access)
    properties (Access = 'private')
        Frame      = [];                            % Treeview frame             
        Nodes      = [];                            % Treeview nodes handles structure
        Parameters = ...                            % Treeview parameters:
            struct('x0',       [],...               % - origin abscissa
                   'y0',       [],...               % - origin ordinate
                   'xm',       15,...               % - abscissa margin
                   'ym',       30,...               % - ordinate margin
                   'dx',       21,...               % - abscissa step
                   'dy',       20,...               % - ordinate step
                   'sw',       15,...               % - sliders width
                   'FontSize', 8,...                % - characters font size
                   'ppc',      6,...                % - number of pixels per character
                   'Suffix',   '...',...            % - text truncation suffix
                   'Color1',   178/255*[1 1 1],...  % - background color
                   'Color2',   128/255*[1 1 1],...  % - foreground color
                   'Color3',   240/255*[1 1 1],...  % - highlight color
                   'Color4',   [51 153 255]/255);   % - text highlight color                              
        Sliders    = [];                            % Treeview sliders and mask handles       
        Selection  = ...                            % Selection structure:
            struct('Control',      0,...            % - [Control] press indicator
                   'Shift',        0,...            % - [Shift] press indicator
                   'PreviousLine', []);             % - previous line (for [Shift] press)
    end
    
    % Methods
    methods (Access = 'public')
        
        % Constructor
        function Object = TreeView(varargin)
            
            for v = 1:2:length(varargin)
                
                Property = varargin{v};
                Value = varargin{v+1};
                set(Object,Property,Value);
                
            end
            
        end
        
        % Function 'set'
        function Object = set(Object,varargin)
            
            % Arguments
            Properties = varargin(1:2:end);
            Values = varargin(2:2:end);
            
            for n = 1:length(Properties)
                
                % Current property control
                [is, Property] = isproperty(Object,Properties{n});
                
                if is
                    
                    % Assignment of the current value
                    Object.(Property) = Values{n};
                    
                    % Treeview origin
                    switch lower(Property)
                        case 'position'                            
                            Object.Parameters.x0 = Object.Position(1)+Object.Parameters.xm;
                            Object.Parameters.y0 = Object.Position(2)+Object.Position(4)-Object.Parameters.ym;
                    end
                    
                else
                    error('Property "%s" not supported !',Properties{n});
                end
                
            end
            
        end
        
        % Function 'get'
        function Value = get(varargin)
            
            Object = varargin{1};
            Property = varargin{2};
            [is, Property] = isproperty(Object,Property);
            
            if is
                Value = Object.(Property);
            else
                error('Property "%s" not supported !',Property);
            end
            
        end
        
        % Function 'create'
        function Object = create(Object)
            
            % Figure
            if isempty(Object.Figure)
                
                % Defaut figure
                Object.Figure = ...
                    figure('Name',        'Treeview',...
                           'Color',       'w',...
                           'NumberTitle', 'off',...
                           'Toolbar',     'none',...
                           'Menubar',     'none'); 
            else
                
                % User figure
                set(0,'CurrentFigure',Object.Figure);
                
            end
            
            % Default position
            if isempty(Object.Position)
                P = get(Object.Figure,'Position');
                P(1) = P(3)-200-4+3;
                P(2) = 3;
                P(3) = 200;
                P(4) = P(4)-3;
                Object.Position = P;
            end
            
            % Treeview frame
            Object.Frame = ...
                axes('Units',    'Pixels',...
                     'Position', Object.Position,...
                     'Color',    'w',...
                     'Xtick',    [],...
                     'Ytick',    [],...
                     'XColor',   Object.Parameters.Color1,...
                     'YColor',   Object.Parameters.Color1,...
                     'Box',      'on');
            box('on');
            
            % Parameters update
            Object.Parameters.SuffixLength = numel(Object.Parameters.Suffix);
                        
            % Parameters
            x0 = Object.Parameters.x0;            
            y0 = Object.Parameters.y0;
            dx = Object.Parameters.dx;
                        
            % Initialization
            Line  = 0;
            Level = 0;
            
            % Image 1
            Image1 = Treeview_resources('ImagePlusStart');                       
            [h1,l1,~] = size(Image1);
            
            % Image 2
            Image2 = Treeview_resources('IconFolder');            
            [h2,l2,~] = size(Image2);
            
            % Node type
            Object.Nodes(1).Type = 1;
            
            % Node line
            Object.Nodes(1).Line = Line;
            
            % Node level
            Object.Nodes(1).Level = Level;
            
            % Node parent
            Object.Nodes(1).Parent = 0;
            
            % Node last indicator
            Object.Nodes(1).Last = 1;
            
            % Node directory
            Object.Nodes(1).Directory = Object.Directory;
            
            % Node axes #1
            Object.Nodes(1).Axes(1) = ...
                axes('Unit',     'pixels',...
                     'Position', [x0+Level*dx y0 l1 h1]);                             
            I = imshow(Image1);            
            set(I,'ButtonDownFcn',{@Click,1});
            
            % Node axes #2
            Object.Nodes(1).Axes(2) = ...
                axes('Unit',     'pixels',...
                     'Position', [x0+Level*dx+l1 y0 l2 h2]);
            imshow(Image2);
            
            % Node axes #3
            Object.Nodes(1).Axes(3) = ...
                axes('Unit',     'pixels',...
                     'Position', [x0+Level*dx+l1+l2 y0+3 100 h2],...
                     'Visible',  'Off');
           
            % Node name      
            Object.Nodes(1).Name = Object.RootName;
            
            % Node text
            Object.Nodes(1).Text = ...
                text('String',              Object.RootName,...
                     'Interpreter',         'None',...
                     'FontName',            'ArialNarrow',...
                     'FontSize',            Object.Parameters.FontSize,...
                     'FontWeight',          'Light',...
                     'FontSmooth',          'Off',...
                     'HorizontalAlignment', 'Left',...
                     'VerticalAlignment',   'Bottom',...
                     'Units',               'Pixels',...
                     'Position',            [10 -1 0]);
            uistack(Object.Nodes(1).Text,'top');
            
            % Node state
            Object.Nodes(1).State = 'folded';
            
            % Horizontal slider
            Object.Sliders(1) = ...
               uicontrol('Style',    'slider',...
                         'Position', [Object.Position(1) Object.Position(2) Object.Position(3)-Object.Parameters.sw Object.Parameters.sw],...
                         'Callback', {@Update_position,1},...
                         'Visible',  'off');
            
            % Vertical slider
            Object.Sliders(2) = ...
               uicontrol('Style',    'slider',...
                         'Position', [Object.Position(1)+Object.Position(3)-Object.Parameters.sw Object.Position(2)+Object.Parameters.sw Object.Parameters.sw Object.Position(4)-Object.Parameters.sw],...
                         'Callback', {@Update_position,2},...
                         'Visible',  'off');
                     
            % Sliders mask
            Object.Sliders(3) = ...
                uipanel('Units','pixels',...
                        'Position',        [Object.Position(1)+Object.Position(3)-Object.Parameters.sw Object.Position(2) Object.Parameters.sw Object.Parameters.sw],...
                        'BorderType',      'line',...
                        'HighLightColor',  Object.Parameters.Color2,...
                        'ForeGroundColor', Object.Parameters.Color3,...
                        'ShadowColor',     Object.Parameters.Color3,...
                        'BackGroundColor', Object.Parameters.Color3,...
                        'Visible',         'off');
               
            % Keypad callback        
            set(Object.Figure,...
                'KeyPressFcn',   {@Select,1},...
                'KeyReleaseFcn', {@Select,0});                    
                    
            % Click callback
            function Click(~,~,n)
                
                Object.update(n);
                
            end
            
            % Slider callback
            function Update_position(~,~,s)
                
                % Parameters
                x0 = Object.Parameters.x0;
                y0 = Object.Parameters.y0;                
                dx = -(get(Object.Sliders(1),'Value')-get(Object.Sliders(1),'UserData'));                
                dy = -(get(Object.Sliders(2),'Value')-get(Object.Sliders(2),'UserData'));
                
                % Position update
                for Node = 1:numel(Object.Nodes)
                    
                    for a = 1:numel(Object.Nodes(Node).Axes) 
                        
                        switch class(Object.Nodes(Node).Axes(a))
                            
                            case 'matlab.graphics.axis.Axes'
                                
                                P = get(Object.Nodes(Node).Axes(a),'Position');
                                switch s
                                    case 1, P(1) = P(1)+dx;
                                    case 2, P(2) = P(2)+dy;
                                end
                                set(Object.Nodes(Node).Axes(a),'Position',P);
                                
                            case 'matlab.graphics.GraphicsPlaceholder'
                                
                        end 
                        
                    end
                    
                end
                
                % Sliders visibility update
                Object.update_visibility();
            
            end
            
            % Keypad callback
            function Select(~,Data,State)
                
                switch Data.Key
                    case 'control', Object.Selection.Control = State;
                    case 'shift',   Object.Selection.Shift   = State;
                end
                
            end
            
        end
        
        % Function 'expand'
        function Object = expand(Object,N)
                 
            % Maximum expansion depth
            if nargin == 1
                N = inf;
            end
            
            % Initialization
            n = 1;
            I = 0;
            
            % Expansion of the nodes upper than the considered level
            while ~isempty(I) && n <= N
                
                % Level increment
                n = n+1;
                
                % Folded nodes
                I = find(ismember({Object.Nodes(:).State},'folded') & eq([Object.Nodes.Type],1));
                
                % Update
                for i = 1:numel(I)
                    Object = update(Object,I(i));
                    drawnow();
                end
                
            end
                        
        end
        
        % Function 'resize'
        function Object = resize(Object,PositionNew)
            
            if nargin
                Object.Position = PositionNew;
            end
            
            % Frame update         
            set(Object.Frame,'Position',Object.Position);
            
            % Parameters update
            Object.Parameters.x0 = Object.Position(1)+Object.Parameters.xm;
            Object.Parameters.y0 = Object.Position(2)+Object.Position(4)-Object.Parameters.ym;
                        
            % Parameters
            x0 = Object.Parameters.x0;            
            y0 = Object.Parameters.y0;            
            dx = Object.Parameters.dx;            
            dy = Object.Parameters.dy;
            
            % Nodes update
            for Node = 1:numel(Object.Nodes)
                
                % Node axes #1 update
                Position1 = get(Object.Nodes(Node).Axes(1),'Position');
                Position1(1) = x0+Object.Nodes(Node).Level*dx;
                Position1(2) = y0-Object.Nodes(Node).Line*dy;
                set(Object.Nodes(Node).Axes(1),'Position',Position1);
                
                % Node axes #2 update
                Position2 = get(Object.Nodes(Node).Axes(1),'Position');
                Position2(1) = x0+Object.Nodes(Node).Level*dx+Position1(3)-1;
                Position2(2) = y0-Object.Nodes(Node).Line*dy;                
                Position2(3) = Position2(3)-2;
                Position2(4) = Position2(4)-2;                
                set(Object.Nodes(Node).Axes(2),'Position',Position2);                
                
                % Node axes #3 update
                Position3 = get(Object.Nodes(Node).Axes(1),'Position');
                Position3(1) = x0+Object.Nodes(Node).Level*dx+Position1(3)+Position2(3);
                Position3(2) = y0-Object.Nodes(Node).Line*dy+3;
                set(Object.Nodes(Node).Axes(3),'Position',Position3);
                
                % Node axes #n update
                for a = 4:numel(Object.Nodes(Node).Axes)
                    switch class(Object.Nodes(Node).Axes(a))
                        case 'matlab.graphics.axis.Axes'
                            PositionNode = get(Object.Nodes(Node).Axes(a),'Position');
                            PositionNode(1) = x0+(Object.Nodes(Node).Level-a+3)*dx;
                            PositionNode(2) = y0-Object.Nodes(Node).Line*dy;
                            set(Object.Nodes(Node).Axes(a),'Position',PositionNode);
                        case 'matlab.graphics.GraphicsPlaceholder'
                    end
                end
                
            end
                         
            % Horizontal slider
            set(Object.Sliders(1),'Position', [Object.Position(1) Object.Position(2) Object.Position(3)-Object.Parameters.sw Object.Parameters.sw]);
                      
            % Vertical slider
            set(Object.Sliders(2),'Position', [Object.Position(1)+Object.Position(3)-Object.Parameters.sw Object.Position(2)+Object.Parameters.sw Object.Parameters.sw Object.Position(4)-Object.Parameters.sw]);
   
            % Sliders visibility update
            Object.update_visibility();
            
        end
     
    end
    
    % Methods
    methods (Access = 'private')
         
        % Function 'isproperty'
        function [is, Property] = isproperty(Object,Property)
            
            Properties = fieldnames(Object);
            [is, b] = ismember(lower(Property),lower(Properties));
            if b
                Property = Properties{b};
            else
                Property = '';
            end
            
        end        
        
        % Function 'update'
        function Object = update(Object,n)
                        
            % Node type control (empty folder or file)
            if ismember(Object.Nodes(n).Type,[0 2])
                return
            end

            % Commutation 'folded'/'expanded'
            switch Object.Nodes(n).State
                
                % Folding
                case 'folded'                    
                    
                    % Callback update
                    Object.Nodes(n).State = 'expanded';
                    switch Object.Nodes(n).Last
                        case 1,    
                            switch Object.Nodes(n).Parent
                                case 0,    Picture = Treeview_resources('ImageMinusStart');
                                otherwise, Picture = Treeview_resources('ImageMinusEnd');
                            end
                        otherwise,         Picture = Treeview_resources('ImageMinus');
                    end
                    imshow(Picture,'Parent',Object.Nodes(n).Axes(1));
                    
                    % Current node expansion
                    Object.update_expand(n);         
                    
                % Expansion
                case 'expanded'
                    
                    % Callback update
                    Object.Nodes(n).State = 'folded';
                    switch Object.Nodes(n).Last
                        case 1,   
                            switch Object.Nodes(n).Parent
                                case 0,    Picture = Treeview_resources('ImagePlusStart');
                                otherwise, Picture = Treeview_resources('ImagePlusEnd');
                            end
                        otherwise,         Picture = Treeview_resources('ImagePlus');
                    end                    
                    imshow(Picture,'Parent',Object.Nodes(n).Axes(1));
                    
                    % Current node folding
                    Object.update_fold(n);
                    
            end
                        
            % Treeview nodes ranking
            Object = ranking(Object);
            
            % Update visibility
            Object.update_visibility(); 
            
        end
        
        % Function 'update fold'
        function Object = update_fold(Object,n)
                        
            % Subnodes list
            i = 0;
            I = find(eq([Object.Nodes.Parent],n));
            while i < numel(I)                
                i = i+1;
                I = [I find(eq([Object.Nodes.Parent],I(i)))]; %#ok<AGROW>
            end
            I = sort(I);
                        
            % Parameter            
            dy = Object.Parameters.dy;
            
            % Lines graphical shift
            Line = Object.Nodes(n).Line;
            NodesBelow = find(gt([Object.Nodes.Line],Line));
            Shift = numel(I);
            for i = 1:numel(NodesBelow)
               Object.Nodes(NodesBelow(i)).Line = Object.Nodes(NodesBelow(i)).Line - Shift;               
               for a = 1:numel(Object.Nodes(NodesBelow(i)).Axes)
                   switch class(Object.Nodes(NodesBelow(i)).Axes(a))
                       case 'matlab.graphics.axis.Axes'
                           set(Object.Nodes(NodesBelow(i)).Axes(a),'Position',get(Object.Nodes(NodesBelow(i)).Axes(a),'Position')+[0 +dy*Shift 0 0]);
                       case 'matlab.graphics.GraphicsPlaceholder'
                   end                   
               end                   
            end
            
            % Vertical slider update
            Min = 0;
            Max = get(Object.Sliders(2),'Max'); 
            Max = Max-dy*Shift;            
            Value = get(Object.Sliders(2),'Value')-dy*Shift;
            Value = min(Value,Max);            
            Step = Object.Parameters.dy*[1 10]/(Max-Min);
         	Step = max(Step,0);
            Step = min(Step,1);            
            set(Object.Sliders(2),... 
                'Min',        Min,...
                'Max',        Max,... 
                'SliderStep', Step,...
                'Value',      Value,...
                'UserData',   Value);
            
            % Destruction of subnodes graphical objects
            delete([Object.Nodes(I).Axes]);    
            
            % Destruction of subnodes handles
            Object.Nodes(I) = [];
            
            % Nodes shift distance
            Pn = get(Object.Nodes([Object.Nodes.Line] == max([Object.Nodes.Line])).Axes(1),'Position');
            Shift = Pn(2)-Object.Position(2);
            
            % Nodes positions update
            if Shift > -Object.Parameters.ym
                
                % Shift
                Shift = floor(Shift/Object.Parameters.dy)*Object.Parameters.dy;
                                
                % Position update
                for Node = 1:numel(Object.Nodes)
                    
                    for a = 1:numel(Object.Nodes(Node).Axes) 
                        
                        switch class(Object.Nodes(Node).Axes(a))
                            
                            case 'matlab.graphics.axis.Axes'
                                
                                P = get(Object.Nodes(Node).Axes(a),'Position');                                
                                P(2) = P(2)-Shift;                                
                                set(Object.Nodes(Node).Axes(a),'Position',P);
                                
                            case 'matlab.graphics.GraphicsPlaceholder'
                                
                        end 
                        
                    end
                    
                end
                
            end
            
        end 
        
        % Function 'update expand'
        function Object = update_expand(Object,n)
            
            % List of entities in the select node
            List = dir(Object.Nodes(n).Directory);                
            Id = find([List.isdir] & ~ismember({List.name},{'.','..'}));
            If = find(~[List.isdir]);
            if ~strcmp(Object.Extensions{1},'.*')                
                E = [];
                for e = 1:numel(If)
                    [~,~,Extension] = fileparts(List(If(e)).name);
                    if ismember(Extension,Object.Extensions)
                        E(end+1) = e; %#ok<AGROW>
                    end
                end
                If = If(E);
            end
            I = [Id,If];
            
            % Parameters
            P = get(Object.Nodes(1).Axes(1),'Position');
            x0 = P(1);
            y0 = P(2)+P(4)-Object.Parameters.dy;
            dx = Object.Parameters.dx;
            dy = Object.Parameters.dy;            
            
            % Parent node line
            Line = Object.Nodes(n).Line;
            
            % Parent node level
            Level = Object.Nodes(n).Level+1;
            
            % Shift
            NodesBelow = find(gt([Object.Nodes.Line],Line));
            Shift = numel(I);
            for i = 1:numel(NodesBelow)
                Object.Nodes(NodesBelow(i)).Line = Object.Nodes(NodesBelow(i)).Line + Shift;
                for a = 1:numel(Object.Nodes(NodesBelow(i)).Axes)
                    switch class(Object.Nodes(NodesBelow(i)).Axes(a))
                        case 'matlab.graphics.axis.Axes'
                            set(Object.Nodes(NodesBelow(i)).Axes(a),'Position',get(Object.Nodes(NodesBelow(i)).Axes(a),'Position')+[0 -dy*numel(I) 0 0]);
                        case 'matlab.graphics.GraphicsPlaceholder'
                    end
                end
            end
            
            % Subnodes update
            for i = 1:Shift
                                
                % Entity
                Entity = I(i);
                
                % Current node
                Node = numel(Object.Nodes)+1;
                
                % Node parent
                Object.Nodes(Node).Parent = n;
                
                % Current line
                Line = Line+1;
                
                % Node line
                Object.Nodes(Node).Line = Line;
                
                % Node level
                Object.Nodes(Node).Level = Level;                
                
                % Node name                
                Object.Nodes(Node).Name = List(Entity).name;
                
                % Node directory
                Object.Nodes(Node).Directory = fullfile(Object.Nodes(n).Directory,List(Entity).name);
                                
                % Vertical lines, deducted from parents position
                Parent = n;
                delta  = 0;                
                while Parent ~= 0
                    delta = delta+1;                    
                    if ~Object.Nodes(Parent).Last
                        Image1 = Treeview_resources('ImageLine');
                        [h1,l1,~] = size(Image1);
                        Object.Nodes(Node).Axes(3+delta) = ...
                            axes('Unit',     'pixels',...
                                 'Position', [x0+(Level-delta)*dx y0-Line*dy l1 h1]);
                        imshow(Image1);
                    end                    
                    Parent = Object.Nodes(Parent).Parent;                    
                end
                
                % Last node indicator
                Object.Nodes(Node).Last = 0;
                
                % Axes #1
                if ismember(Entity,Id)
                    
                    % Node type
                    Object.Nodes(Node).Type = 1;  
                    
                    % List of entities in current subfolder
                    List2 = dir(Object.Nodes(Node).Directory);
                    Id2 = find([List2.isdir] & ~ismember({List2.name},{'.','..'}));
                    If2 = find(~[List2.isdir]);
                    if ~strcmp(Object.Extensions{1},'.*')
                        E = [];
                        for e = 1:numel(If2)
                            [~,~,Extension] = fileparts(List2(If2(e)).name);
                            if ismember(Extension,Object.Extensions)
                                E(end+1) = e; %#ok<AGROW>
                            end
                        end
                        If2 = If2(E);
                    end                    
                    
                    % Empty indicator
                    Empty = isempty([Id2 If2]);                        
                    
                    % Image #1
                    if Entity == Id(end) && isempty(If)
                        if Empty 
                            Image1 = Treeview_resources('ImageEnd');                            
                            Object.Nodes(Node).Type = 0;
                        else
                            Object.Nodes(Node).Last = 1;
                            Image1 = Treeview_resources('ImagePlusEnd');
                        end
                    else
                        if Empty
                            Image1 = Treeview_resources('ImageNode');                                                        
                            Object.Nodes(Node).Type = 0;
                        else
                            Image1 = Treeview_resources('ImagePlus');
                        end
                    end                               
                    [h1,l1,~] = size(Image1);
                    
                    % Image #2
                    Image2 = Treeview_resources('IconFolder');                           
                    [h2,l2,~] = size(Image2);
                    
                    % Node axes #1
                    Object.Nodes(Node).Axes(1) = ...
                        axes('Unit',     'pixels',...
                             'Position', [x0+Level*dx y0-Line*dy l1 h1]);                    
                    Icon = imshow(Image1);
                    switch Object.Nodes(Node).Type 
                        case 1, set(Icon,'ButtonDownFcn',{@ClickNode,Node});
                    end
                    
                    % Node state
                    Object.Nodes(Node).State = 'folded';
                    
                elseif ismember(Entity,If)

                    % Node type
                    Object.Nodes(Node).Type = 2;
                    
                    % Image #1
                    if Entity < If(end)
                        Image1 = Treeview_resources('ImageNode');    
                    else
                        Image1 = Treeview_resources('ImageNodeEnd');  
                    end                              
                    [h1,l1,~] = size(Image1);
                    
                    % Image #1
                    Image2 = Treeview_resources('IconFile');                          
                    [h2,l2,~] = size(Image2);
                    
                    % Node axes #1
                    Object.Nodes(Node).Axes(1) = ...
                        axes('Unit',     'pixels',...
                             'Position', [x0+Level*dx y0-Line*dy l1 h1]);     
                    Icon = imshow(Image1);
                    set(Icon,'ButtonDownFcn','');
                    
                    % Node state
                    Object.Nodes(Node).State = '';
                
                end                
                
                % Node axes #2
                Object.Nodes(Node).Axes(2) = ...
                    axes('Unit',     'pixels',...
                         'Position', [x0+Level*dx+l1 y0-Line*dy l2 h2]);
                imshow(Image2);
                
                % Node axes #3
                Object.Nodes(Node).Axes(3) = ...
                    axes('Unit',     'pixels',...
                         'Position', [x0+Level*dx+l1+l2 y0-Line*dy+3 100 h2],...
                         'Visible',  'Off');
                
                % Node name
                Object.Nodes(Node).Text = ...
                    text('String',            List(Entity).name,...
                         'Interpreter',       'None',...
                         'FontName',          'ArialNarrow',...
                         'FontSize',          Object.Parameters.FontSize,...
                         'FontWeight',        'Light',...
                         'FontSmooth',        'Off',...
                         'VerticalAlignment', 'Bottom',...
                         'Units',             'Pixels',...
                         'Position',          [10 -1 0],...
                         'Color',             'k',...
                         'Margin',            1,...
                         'LineWidth',         0.1,...
                         'LineStyle',         ':',...
                         'EdgeColor',         'none',...
                         'BackGroundColor',   'none',...
                         'ButtonDownFcn',     {@ClickText,Node});                  
                uistack(Object.Nodes(Node).Text,'top');
                
            end
            
            % Click node callback
            function ClickNode(~,~,n)
                
                Object.update(n);
                
            end
            
            % Click text callback
            function ClickText(Text,event,Node)
                
                Object.select(Text,event,Node);
                
            end                
    
        end
        
        % Function 'ranking'
     	function Object = ranking(Object)
            
            % Ranking
            Object.Nodes = arrayfun(@(l)Object.Nodes(eq([Object.Nodes.Line],l-1)),1:numel(Object.Nodes));
            
            % Current parents indices preallocation
            Parents = zeros(1,max([Object.Nodes.Level]));            
            
            % Callbacks update with nodes indexes
            for Node = 1:numel(Object.Nodes)
              
                % Callback
                Icon = get(Object.Nodes(Node).Axes(1),'Children');
                switch Object.Nodes(Node).Type
                    case 1,     set(Icon,'ButtonDownFcn',{@ClickNode,Node});
                    case {0,2}, set(Icon,'ButtonDownFcn',[]);
                end             
                if Node > 1
                    set(Object.Nodes(Node).Text,'ButtonDownFcn',{@ClickText,Node});
                end
                
                % Parent i.e. immediate node whose level is lower
                switch Node
                    case 1,    Parent = 0;
                    otherwise, Parent = Parents(Object.Nodes(Node).Level);
                end
                Object.Nodes(Node).Parent = Parent;
                Parents(Object.Nodes(Node).Level+1) = Node; 
                
            end
            
            % Click node callback
            function ClickNode(~,~,n)
                
                Object.update(n);
                
            end
            
            % Click text callback
            function ClickText(Text,event,Node)
                
                Object.select(Text,event,Node);
                
            end  
            
      	end
            
        % Function 'select'
        function Object = select(Object,Text,event,Node)
            
            % Unselection
            if ~Object.Selection.Control && ~Object.Selection.Shift
                for Node2 = 1:numel(Object.Nodes)
                    if Node2 ~= Node
                        set(get(Object.Nodes(Node2).Axes(3),'Children'),...
                            'Color',          'k',...
                            'EdgeColor',      'none',...
                            'BackGroundColor','none');
                    end
                end
            end
            
            % Action through left click
            switch event.Button
                
                case 1
                    
                    % Selection
                    if strcmpi(get(Text,'BackGroundColor'),'none')
                        
                        switch Object.Selection.Shift
                            
                            case 0
                                
                                % First selected line memorization
                                Object.Selection.PreviousLine = Object.Nodes(Node).Line;
                                
                            case 1
                                
                                % Multiple selected through shit key
                                Lines(1) = Object.Nodes(Node).Line;
                                Lines(2) = Object.Selection.PreviousLine;
                                Lines = sort(Lines);
                                SelectedNodes = find(ge([Object.Nodes.Line],Lines(1)) & le([Object.Nodes.Line],Lines(2)));
                                for Index = 1:numel(SelectedNodes)
                                    Text(Index) = get(Object.Nodes(SelectedNodes(Index)).Axes(3),'Children');
                                end
                                
                        end
                        
                        % Selection(s)
                        set(Text,...
                            'Color',           'w',...
                            'EdgeColor',       'k',...
                            'BackGroundColor', Object.Parameters.Color4);
                        
                        % Nodes selection
                        if ~isempty(Object.SelectFcn)
                            NodesSelection = {};
                            for Node2 = 1:numel(Object.Nodes)
                                Text = get(Object.Nodes(Node2).Axes(3),'Children');
                                if ~strcmpi(get(Text,'BackGroundColor'),'none')
                                    NodesSelection{end+1} = Object.Nodes(Node2).Directory; %#ok<AGROW>
                                end
                            end
                            feval(Object.SelectFcn,NodesSelection);
                        end
                        
                    else
                        
                        % Unselection
                        set(Text,...
                            'Color',          'k',...
                            'EdgeColor',      'none',...
                            'BackGroundColor','none');
                        
                    end
                    
            end
            
        end
                
        % Function 'update visibility'
        function Object = update_visibility(Object)
            
            % Minimum abscissa
            P = get(Object.Nodes(1).Axes(1),'Position');
            xmin = P(1)-Object.Parameters.xm;
            
            % Maximum abscissa
            xmax = 0;
            for Node = 1:numel(Object.Nodes)
                P2 = get(Object.Nodes(Node).Axes(3),'Position');
                W = numel(Object.Nodes(Node).Name)*Object.Parameters.ppc;
                xmax = max(xmax,P2(1)+W);
            end
            xmax = xmax+Object.Parameters.xm;
            
            % Abscissa interval
            Dx = xmax-xmin;
            
            % Minimum ordinate
            Pn = get(Object.Nodes([Object.Nodes.Line] == max([Object.Nodes.Line])).Axes(1),'Position');
            ymin = Pn(2);
            
            % Maximum ordinate
            ymax = P(2)+P(4);            
            
            % Ordinate interval
            Dy = ymax-ymin+Object.Parameters.ym;            
            
            % Horizontal slider visibility update
            Visibility1 = ...
                lt(xmin,Object.Parameters.x0-Object.Parameters.xm) || ...
                gt(xmax,Object.Position(1)+Object.Position(3));
            
            % Vertical slider visibility update
            Visibility2 = ...
                lt(ymin,Object.Position(2)) || ...
                gt(ymax,Object.Position(2)+Object.Position(4));
            
            % Horizontal slider visibility update
            if Visibility1         
           
                % Slider parameters
                Min  = 0;
                Max  = Dx-Object.Position(3)+Object.Parameters.xm;
                Max  = floor(Max/Object.Parameters.dx)*Object.Parameters.dx;
                if Max == 0
                   Max = Object.Parameters.dx;
                end
                Max = Max+Visibility2*Object.Parameters.sw;                        
                Max  = floor(Max/Object.Parameters.dx)*Object.Parameters.dx;                
                Step = Object.Parameters.dx*[1 10]/(Max-Min);     
                
                % Current value with regard to first node abscissa
                Value = Object.Position(1)-xmin;                       
                Value = (Value/Object.Parameters.dx)*Object.Parameters.dx;                
                Value = max(Value,Min);
                Value = min(Value,Max);
                
                % Slider position
                P = [Object.Position(1)...
                     Object.Position(2)...
                     Object.Position(3)-Visibility2*Object.Parameters.sw...
                     Object.Parameters.sw];                
                
                % Update
                set(Object.Sliders(1),... 
                    'Min',        Min,...
                    'Max',        Max,... 
                    'SliderStep', Step,...
                    'Value',      Value,...
                    'UserData',   Value,...
                    'Position',   P,...
                    'Visible',    'On');               
                set(Object.Sliders(3),'visible','on');
                uistack(Object.Sliders([1 3]),'top');
            
            else
                
                % Slider masking
                set(Object.Sliders(1),'visible','off');
                
            end
                        
            % Vertical slider visibility update
            if Visibility2
           
                % Slider parameters
                Min  = 0;
                Max  = Dy-Object.Position(4)+Visibility1*Object.Parameters.sw;
                Max  = floor(Max/Object.Parameters.dy)*Object.Parameters.dy; 
                if Max == 0
                   Max = Object.Parameters.dy;
                end
                Step = Object.Parameters.dy*[1 10]/(Max-Min);
                Step = max(Step,0);
                Step = min(Step,1);
                
                % Current value with regard to first node ordinate
                Value = Max-ymax+Object.Position(2)+Object.Position(4);                
                Value = floor(Value/Object.Parameters.dy)*Object.Parameters.dy;
                Value = max(Value,Min);
                Value = min(Value,Max);
                
                % Slider position
                P = [Object.Position(1)+Object.Position(3)-Object.Parameters.sw...
                     Object.Position(2)+Visibility1*Object.Parameters.sw...
                     Object.Parameters.sw...
                     Object.Position(4)-Visibility1*Object.Parameters.sw];                         
                 
                % Update
                set(Object.Sliders(2),... 
                    'Min',        Min,...
                    'Max',        Max,... 
                    'SliderStep', Step,...
                    'Value',      Value,...
                    'UserData',   Value,...
                    'Position',   P,...
                    'Visible',    'On');
                set(Object.Sliders(3),'visible','on');
                uistack(Object.Sliders([2 3]),'top');
                
            else
                
                % Slider masking
                set(Object.Sliders(2),'visible','off');
                
            end
            
            % Mask visibility update
            if Visibility1 && Visibility2
                set(Object.Sliders(3),...
                     'Position',        [Object.Position(1)+Object.Position(3)-Object.Parameters.sw Object.Position(2) Object.Parameters.sw Object.Parameters.sw],...
                     'visible','on');
            else                
                set(Object.Sliders(3),'visible','off');
            end
            
            % Nodes visibility
            for Node = 1:numel(Object.Nodes) 
                
                for a = 1:numel(Object.Nodes(Node).Axes)    
                                        
                    switch class(Object.Nodes(Node).Axes(a))
                        
                        case  'matlab.graphics.axis.Axes'
                            
                            % Current axes children
                            Children = get(Object.Nodes(Node).Axes(a),'Children');
                            
                            switch class(Children)
                                
                             	% Node pictures visibility
                                case 'matlab.graphics.primitive.Image'
                                    
                                    P = get(Object.Nodes(Node).Axes(a),'Position');
                                    if  P(1) < Object.Position(1) || P(1)+P(3) > Object.Position(1)+Object.Position(3) || ...                                       
                                        P(2) < Object.Position(2) || P(2)+P(4) > Object.Position(2)+Object.Position(4)
                                        set(Children,'Visible','off');
                                    else
                                        set(Children,'Visible','on');              
                                    end
                                    
                             	% Node name visibility
                                case 'matlab.graphics.primitive.Text'
                                    
                                    % Node name
                                    P = get(Object.Nodes(Node).Axes(a),'Position');
                                    Text = Object.Nodes(Node).Name;
                                    Width = numel(Text)*Object.Parameters.ppc;
                                    WidthLimit = max(Object.Position(1)+Object.Position(3)-P(1)-Object.Parameters.xm,0);
                                    
                                    % Node name reduction
                                    if Width > WidthLimit
                                        if numel(Text) >= Object.Parameters.SuffixLength 
                                            Length = round((WidthLimit)/Object.Parameters.ppc)-Object.Parameters.SuffixLength;
                                            if strfind(Text,'.')
                                                Length = Length+1;
                                            end
                                            Text = [Text(1:max(Length,0)),Object.Parameters.Suffix];
                                        else
                                            Text = Object.Parameters.Suffix;                                            
                                        end
                                    end
                                    
                                    % Node text update
                                    set(Children,'String',Text);
                                    Width = numel(Text);
                                    
                                    % Visibility update
                                    if P(1) < Object.Position(1)   || P(1) > Object.Position(1)+Object.Position(3)-Width || ...
                                       P(2) < Object.Position(2)+5 || P(2) > Object.Position(2)+Object.Position(4)-15
                                        set(Children,'Visible','off');   
                                    else
                                        set(Children,'Visible','on');              
                                    end
                                    
                            end
                            
                        case 'matlab.graphics.GraphicsPlaceholder'
                       
                    end
                    
                end 
                
            end
                        
            % Nodes update
            switch get(Object.Sliders(2),'Visible')
                
                case 'off'
                    
                    % Maximum ordinate
                    P = get(Object.Nodes(1).Axes(1),'Position');
                    ymax = P(2);
                    
                    % Shift
                    Shift = Object.Parameters.y0-ymax-0*Object.Parameters.ym;
                    
                    % Position update
                    if Shift > 0
                        
                        for Node = 1:numel(Object.Nodes)
                            
                            for a = 1:numel(Object.Nodes(Node).Axes)
                                
                                switch class(Object.Nodes(Node).Axes(a))
                                    
                                    case 'matlab.graphics.axis.Axes'
                                        
                                        P = get(Object.Nodes(Node).Axes(a),'Position');
                                        P(2) = P(2)+Shift;
                                        set(Object.Nodes(Node).Axes(a),'Position',P);
                                        
                                    case 'matlab.graphics.GraphicsPlaceholder'
                                        
                                end
                                
                            end
                            
                        end
                        
                    end
                    
            end
            
        end
        
    end
    
end
