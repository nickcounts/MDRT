classdef (CaseInsensitiveProperties) FileListBox < handle
%FileListBox Class for Drag & Drop functionality.
%   obj = FileListBox(javaobj) creates a FileListBox object for the specified
%   Java object, such as 'javax.swing.JTextArea' or 'javax.swing.JList'. Two
%   callback functions are available: obj.DropFileFcn and obj.DropStringFcn, 
%   that listen to drop actions of respectively system files or plain text.
%
%   The Drag & Drop control class relies on a Java class that need to be
%   visible on the Java classpath. To initialize, call the static method
%   FileListBox.initJava(). The Java class can be adjusted and recompiled if
%   desired.
%
%   FileListBox Properties:
%       Parent            - The associated Java object.
%
%   FileListBox Methods:
%       FileListBox        - Constructs the FileListBox object.
%       makeAndPlaceListBox  Places a listbox with drag-drop controls
%       getFileCellArray   - Return a cell array of strings containing the
%                            full filename and path to each file in the
%                            FileListBox object's managed fileList property
%       clearFileList      - Resets the FileListBox object's managed
%                            fileList property to the empty set and
%                            refreshes the GUI
%
%   FileListBox Static Methods:
%       demo              - Runs the demonstration script.
%       initJava          - Initializes the Java class.
%       isInitialized     - Checks if the Java class is visible.
%
%   USAGE GUIDE:
%       1) Instantiate a FileListBox object to manage the file list and the
%       GUI element.
%
%       2) Use the makeAndPlaceListBox method to add the GUI object to your
%       GUI, linked to the controller object.
%
%       3) Get the full file name and path array by using the
%       getFileCellArray method.
%
%       4) Reset the file list and GUI by using the clearFileList method.
%
%   Example:
%       fig = figure
%       flb = FileListBox;
%       flb.makeAndPlaceListBox(fig);
%
%   See also:
%       uicontrol, javaObjectEDT.    
%
%   Based on code originally written by: Maarten van der Seijs, 2015.
%   Version: 1.0, 13 October 2015.
%
%   Converted to a file list manager object by Nick Counts, 2016

        
    properties (Hidden)
        dropTarget;
        
        jTextArea
        hContainer
        
        listUpdatedTrigger = 0;
        
        %DROPFILEFCN Callback function executed upon dropping of system files.
        DropFileFcn = @addDroppedFilesToList;        
        %DROPSTRINGFCN Callback function executed upon dropping of plain text.
        DropStringFcn;  
        
    end
    
    % Properties calculated or determined by other properties
    properties (Dependent)
        %PARENT The associated Java object.
        Parent;
    end
    
    % Properties only accessible from within the class or a subclass
    properties (Access=protected, SetObservable=true)
        fileList = {};
    end
       
    methods (Static)
        function initJava()
        %INITJAVA Initializes the required Java class.
        
            %Add java folder to javaclasspath if necessary
            if ~FileListBox.isInitialized();
                classpath = fileparts(mfilename('fullpath'));                
                javaclasspath(classpath);                
            end 
        end
        
        function TF = isInitialized()            
        %ISINITIALIZED Returns true if the Java class is initialized.
        
            TF = (exist('MLDropTarget','class') == 8);
        end                           
    end
    
    
    methods
        %% Constructor 
        
        function obj = FileListBox(Parent,DropFileFcn,DropStringFcn)
        %FileListBox Drag & Drop control constructor.
        %   obj = FileListBox(javaobj) contstructs a FileListBox object for 
        %   the given parent control javaobj. The parent control should be a 
        %   subclass of java.awt.Component, such as most Java Swing widgets.
        %
        %   obj = FileListBox(javaobj,DropFileFcn,DropStringFcn) sets the
        %   callback functions for dropping of files and text.
            
            % Check for Java class
            assert(FileListBox.isInitialized(),'Javaclass MLDropTarget not found. Call FileListBox.initJava() for initialization.')
             
            % Construct DropTarget            
            obj.dropTarget = handle(javaObjectEDT('MLDropTarget'),'CallbackProperties');
            set(obj.dropTarget,'DropCallback',{@FileListBox.DndCallback,obj});
            set(obj.dropTarget,'DragEnterCallback',{@FileListBox.DndCallback,obj});
            
            % Set DropTarget to Parent
            if nargin >=1, Parent.setDropTarget(obj.dropTarget); end
            
            % Set callback functions
            if nargin >=2, obj.DropFileFcn = DropFileFcn; end 
            if nargin >=3, obj.DropStringFcn = DropStringFcn; end
        end
        
        
        
        %% Set Methods
        
        function set.Parent(obj, Parent)
            %set.Parent 
            % Parent must be a java.awt.Component with a .setDropTarget
            % method.
            %
            % This method links the FileListBox object's dropTarget
            % property to the Parent via the dropTarget object's
            % .setComponent method
            
            if isempty(Parent)
                obj.dropTarget.setComponent([]);
                return
            end
            if isa(Parent,'handle') && ismethod(Parent,'java')
                Parent = Parent.java;
            end
            assert(isa(Parent,'java.awt.Component'),'Parent is not a subclass of java.awt.Component.')
            assert(ismethod(Parent,'setDropTarget'),'DropTarget cannot be set on this object.')
            
            obj.dropTarget.setComponent(Parent);
        end
        
        
        
        %% Get Methods
        
        function Parent = get.Parent(obj)
            Parent = obj.dropTarget.getComponent();
        end
        
        function fileCellArray = getFileCellArray(obj)
            fileCellArray = obj.fileList;
        end
    end
    
    
    
%% Property Management Methods

    methods
        
        function obj = addDroppedFilesToList(obj, event, varargin)
            
           
           
           for i = 1:numel(event)
               switch event.DropType
                   case 'file'
                       
                       tryFile = event(i).Data{1};
                       
                       if exist(tryFile) && ~isdir(tryFile)
                           % Just a regular old file
                           obj.fileList = vertcat(obj.fileList, event(i).Data);
                       else
                           % TODO: Handle importing folder contents
                           % someday?
                       end
                       
                   case 'string'
                       
                   otherwise
                       
               end
           end
           
           obj.fileList = unique(obj.fileList);
           
        end
        
        function obj = addFilesToList(obj, filename)
            %addFilesToList
            %   Currently supports only one filename at a time
            %   filename argument is a char/string
            
            %TODO: implement cell arrays
            
            if exist(filename) && ~isdir(filename)
               % Just a regular old file
               obj.fileList = vertcat(obj.fileList, filename);
            else
               % TODO: Handle importing folder contents
               % someday?
            end
            
            obj.fileList = unique(obj.fileList);
            
            
        end
        
        function obj = set.fileList(obj, newList)
            
            obj.fileList = newList;
            obj.listUpdatedTrigger = obj.listUpdatedTrigger + 1;
            obj.refreshGUI;
            
        end
        
        function fileName = getFileName(obj, index)
            
            [~, name, ext] = fileparts( obj.fileList{index} );
            
            fileName = strcat(name, ext);
            
        end
        
        function refreshGUI(obj)
            
            if ~isempty(obj.Parent)
            
                obj.jTextArea.setText('');

                for i = 1:numel(obj.fileList)
                   obj.jTextArea.append( sprintf('%s\n', getFileName(obj, i) ) );
                end
                
            end

        end
        
        function obj = clearFileList(obj)
            obj.fileList = {};
        end
        
        
        
         function obj = makeAndPlaceListBox(obj, hParent, varargin)
            % makeAndPlaceListbox( uiParentHandle, 'property', value)
            %
            %   instantiates a javax.swing.JTextArea, creates a Matlab
            %   handle and sets the FileListBox's dependent Parent
            %   property.
            %
            %   The first argument is an HG handle to the Matlab gui object
            %   desired to contain the FileListBox GUI Element.
            %
            %   Accepts 'units' and 'position' key/value arguments.
            %   
            
            % Default parameters
            position    = [0.1, 0.1, 0.8, 0.8];
            units       = 'normalized';
            
            % Assign any parameters that have been passed
            for i = 1:2:numel(varargin)
                switch lower(varargin{i})
                    
                    case 'position'
                        pos = varargin{i+1};
                        if ~ (isnumeric(pos) && logical(prod(size(pos) == [1 4])))
                            error('Invalid Position parameter passed');
                        end
                        position = pos;
                        
                    case 'units'
                        unt = varargin{i+1};
                        if ~ isa(unt, 'char')
                            error('Invalid Units parameter passed');
                        end
                        
                        switch lower(unt)
                            case {'pixels', 'normalized', 'inches', 'centimeters', 'points', 'characters'}
                                units = unt;
                            otherwise
                                error('Invalid Units parameter passed');
                        end
                        
                    otherwise     
                end
            end
            
            
            
            % Initialize Java class
            FileListBox.initJava();
            
            % Create Java Swing JTextArea
            obj.jTextArea = javaObjectEDT('javax.swing.JTextArea', ...
                sprintf('Drag and drop files here'));
            
            % Create Java Swing JScrollPane
            jScrollPane = javaObjectEDT('javax.swing.JScrollPane', obj.jTextArea);
            jScrollPane.setVerticalScrollBarPolicy(jScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
            
            % Add Scrollpane to existing GUI container/component
            [~,obj.hContainer] = javacomponent(jScrollPane,[],hParent);
            set(obj.hContainer,'Units',units,'Position',position);
            
            % Create FileListBox for the JTextArea object
            obj.Parent = obj.jTextArea;
%             obj.JTextArea = jTextArea;
%             obj.hContainer = hContainer;
            
            % Set Drop callback functions
%             obj.DropFileFcn = @demoDropFcn;
%             obj.DropStringFcn = @demoDropFcn;
            
        end
        
        
        
    end
    
    
    
%% Static Methods    
    
    methods (Static, Hidden = true)
        %% Callback functions
        function DndCallback(jSource,jEvent,obj)
            
            if jEvent.isa('java.awt.dnd.DropTargetDropEvent')
                % Drop event     
                try
                    switch jSource.getDropType()
                        case 0
                            % No success.
                        case 1
                            % String dropped.
                            string = char(jSource.getTransferData());
                            if ~isempty(obj.DropStringFcn)
                                evt = struct();
                                evt.DropType = 'string';
                                evt.Data = string;                                
                                feval(obj.DropStringFcn,obj,evt);
                            end
                        case 2
                            % File dropped.
                            files = cell(jSource.getTransferData());                            
                            if ~isempty(obj.DropFileFcn)
                                evt = struct();
                                evt.DropType = 'file';
                                evt.Data = files;
                                feval(obj.DropFileFcn,obj,evt);
                            end
                    end
                    
                    % Set dropComplete
                    jEvent.dropComplete(true);  
                catch ME
                    % Set dropComplete
                    jEvent.dropComplete(true);  
                    rethrow(ME)
                end                              
                
            elseif jEvent.isa('java.awt.dnd.DropTargetDragEvent')
                 % Drag event                               
                 action = java.awt.dnd.DnDConstants.ACTION_COPY;
                 jEvent.acceptDrag(action);
            end            
        end
    end
    
    
    
    
    methods (Static)
        function defaultDropFcn(src,evt)
        %DEFAULTDROPFCN Default drop callback.
        %   DEFAULTDROPFCN(src,evt) accepts the following arguments:
        %       src   - The FileListBox object.
        %       evt   - A structure with fields 'DropType' and 'Data'.
        
            fprintf('Drop event from %s component:\n',char(src.Parent.class()));
            switch evt.DropType
                case 'file'
                    fprintf('Dropped files:\n');
                    for n = 1:numel(evt.Data)
                        fprintf('%d %s\n',n,evt.Data{n});
                    end
                case 'string'
                    fprintf('Dropped text:\n%s\n',evt.Data);
            end
        end          
        
        
       
        
        function [dndobj,hFig] = demo()
        %DEMO Demonstration of the FileListBox class functionality.
        %   FileListBox.demo() runs the demonstration. Make sure that the
        %   Java class is visible in the Java classpath.
            
            % Initialize Java class
            FileListBox.initJava();
        
            % Create figure
            hFig = figure();
            
            % Create Java Swing JTextArea
            jTextArea = javaObjectEDT('javax.swing.JTextArea', ...
                sprintf('Drop some files or text content here.\n\n'));
            
            % Create Java Swing JScrollPane
            jScrollPane = javaObjectEDT('javax.swing.JScrollPane', jTextArea);
            jScrollPane.setVerticalScrollBarPolicy(jScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
                        
            % Add Scrollpane to figure
            [~,hContainer] = javacomponent(jScrollPane,[],hFig);
            set(hContainer,'Units','normalized','Position',[0 0 1 1]);
            
            % Create FileListBox for the JTextArea object
            dndobj = FileListBox(jTextArea);
            
            % Set Drop callback functions
            dndobj.DropFileFcn = @demoDropFcn;
            dndobj.DropStringFcn = @demoDropFcn;
            
            % Callback function
            function demoDropFcn(~,evt)
                switch evt.DropType
                    case 'file'
                        keyboard
                        jTextArea.append(sprintf('Dropped files:\n'));
                        for n = 1:numel(evt.Data)
                            jTextArea.append( sprintf('%d %s\n',n,evt.Data{n} ) );
%                             jTextArea.setText('asdfasdf');
                        end
                    case 'string'
                        jTextArea.append(sprintf('Dropped text:\n%s\n',evt.Data));
                end
                jTextArea.append(sprintf('\n'));
            end
        end
    end    
end