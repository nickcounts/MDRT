classdef FDCollection
    %FDCollection An object to manage FDs for displaying in GUIs,
    %selecting and sending data to plots
    %   This collection object maintains a master list of FDs with all
    %   relevent information for file name, strings, locations, metadata
    %   access, timeline access, etc.
    %
    %   Class methods provide a means for generating cell arrays to
    %   populate a uicontrol.
    %
    % Counts, 2016 VCSFA
    
    % fdc = FDCollection( dataIndex(1), { dataIndex(1).metaData.fdList(1:10,:) } )
    % fdc = FDCollection( dataIndex(1:2), {dataIndex(1).metaData.fdList(1:10,:);dataIndex(2).metaData.fdList(1:10,:)})
    
    properties
        dataStreamNames     = {};
        dataFilesWithPath   = {};
        timelineFilesWithPath = [];
        fdDataSetIndex      = [];
    end
    
    properties (SetAccess = public)
        
        
        targetUI            = [];
        
    end
    
    
    properties (Dependent)
        
        
    end
    
    methods
        
        % Constructor
        % -----------------------------------------------------------------
        function thisFDCollection = FDCollection( varargin )
            %FDCollection creates an FDCollection object
            % Accepts the following input arguments:
            %
            % FDCollection(dataIndexVector)
            % FDCollection(dataIndexVector, UITarget)
            % FDCollection(dataIndexVector, fdListVector)
            % FDCollection(dataIndexVector, fdListVector, UITarget)
            %
            % If no UITarget is specified, the FDCollection will have no
            % target uicontrol object. This can be set after object
            % instantiation if desired
            %
            % If no fdListVector is specified, all FDs in the metaData
            % fields of the dataIndexVector will be added to the
            % FDCollection object.
            
            % Check input number and type
                        
            targetUI = [];
            fdListVector = {};
            createUsingSubset = false;
            
            debugout(nargin)
            
            switch nargin
                case 1
                    % FDCollection(dataIndexVector)
                
                case 2
                    % FDCollection(dataIndexVector, UITarget)
                    % FDCollection(dataIndexVector, fdListVector)

                    if ishghandle( varargin{2} )
                        targetUI = varargin{2};
                    else
                        % Using a subset of the dataIndex fds and no
                        % uitarget was passed
                        createUsingSubset = true;
                        fdListVector = varargin{2};
                    end
                    
                case 3
                    % Using a subset of the dataIndex fds and a targetUI
                    % control handle was passed
                    
                    createUsingSubset = true;
                    
                    if ishghandle( varargin{3} ) && ~isempty(varargin{3})
                        % FDCollection(dataIndexVector, fdListVector, UITarget)
                        debugout('FDCollection(dataIndexVector, fdListVector, UITarget)')

                        fdListVector    = varargin{2};
                        targetUI        = varargin{3};

                    else
                        % FDCollection(dataIndexVector, UITarget, fdListVector)
                        debugout('FDCollection(dataIndexVector, UITarget, fdListVector)')

                        fdListVector    = varargin{3};
                        targetUI        = varargin{2};

                    end 
            end
            
            thisFDCollection.targetUI = targetUI;
            
            dataIndexVector = varargin{1};
            
            % UITarget, dataIndexVector, fdListVector
            
            dataStreamNames     = {};
            dataFilesWithPath   = {};
            timelineFilesWithPath = {};
            fdDataSetIndex      = [];
        
            % Halt creation if passed a malformed
            % dataIndexVector/fdListVector pair
            if numel(dataIndexVector) ~= numel(fdListVector) && createUsingSubset
                % Mismatch in data set/FD list lengths
                warning('metaDataVector and FDList are not the same length')
                return
            end
            
            
            
            % Build the object properties if a subset of fdList was desired
            % -------------------------------------------------------------
            for i = 1:numel(dataIndexVector)
                
                tempTimelineFileWithPath = fullfile( dataIndexVector(i).pathToData, 'timeline.mat');
                
                
                if ~exist( tempTimelineFileWithPath, 'file')
                    % if no timeline file, clear tempTimelineFileWithPath
                    % so the final list doesn't have a link to a
                    % nonexistant file
                    tempTimelineFileWithPath = {''};
                end
                
                
                % Check for a match and then add to the class variable. Allows for subsets
                if ~ createUsingSubset
                    
                   % Use all the FDs in the lists
                   fdListVector{i} = dataIndexVector(i).metaData.fdList(:,1);
                    
                end
                
                
                % Build internal variables by looping through input
                % arguments
                for j = 1:numel( fdListVector{i} )
                    
                    fdIndex = find(ismember( dataIndexVector(i).metaData.fdList(:,1), fdListVector{i}{j} ) );
                    
                    if ~isempty(fdIndex)
                        
                        dataStreamNames   = vertcat( dataStreamNames, ...
                                                     dataIndexVector(i).metaData.fdList(fdIndex,1) );
                                                 
                        dataFilesWithPath = vertcat( dataFilesWithPath, ...
                            fullfile( dataIndexVector(i).pathToData, ...
                                      dataIndexVector(i).metaData.fdList(fdIndex,2) ) );
                                  
                        timelineFilesWithPath = vertcat ( timelineFilesWithPath, tempTimelineFileWithPath);
                        
                        fdDataSetIndex = vertcat( fdDataSetIndex, i);
                                       
                    
                    end
                end
                
                thisFDCollection.dataStreamNames = dataStreamNames;
                thisFDCollection.dataFilesWithPath = dataFilesWithPath;
                thisFDCollection.timelineFilesWithPath = timelineFilesWithPath;
                thisFDCollection.fdDataSetIndex = fdDataSetIndex;
                
            end
            
            
        end
        
        
        % Set Methods
        
        function this = set.targetUI(this, uihandle)
            
            if ishghandle(uihandle)
                         
                this.targetUI = uihandle;
                
            end
            
        end
        
        % Class Methods
        % -----------------------------------------------------------------
        function populateListbox(this, varargin)
            %populateListbox sets the contents of targetUI
            %
            % Accepts the following input arguments:
            %
            % populateListbox()
            % populateListbox()
            % populateListbox()

            numberOfOldStrings = numel(this.targetUI.String);
            
            
            
            if isempty(this.targetUI.Value)
                this.targetUI.Value = 1;
            end
            
            
            if isempty(this.dataStreamNames) 
                
            elseif numel(this.dataStreamNames) < numberOfOldStrings
                
            elseif numel(this.dataStreamNames) >= numberOfOldStrings
                % In this case, the old Value is still good 
            end
            
            this.targetUI.String = this.dataStreamNames;

        end

        
        % Full Path Return Methods
        % -----------------------------------------------------------------
        function dataFileWithPath =     getDataFilePathFromUISelection(this)
            
            dataFileWithPath = [];
            
            % At some point, this function will check that the listbox
            % contents have not been changed by another process
            
            ind = this.targetUI.Value;
            
            if isempty(ind)
                % What the hell happened? There is an empty index?
                return
            end
            
            dataFileWithPath = this.dataFilesWithPath(ind);
                        
        end
        
        
        function timelineFileWithPath = getTimelineFileWithPathFromUISelection(this)
        
            timelineFileWithPath = [];
            
            ind = this.targetUI.Value;
            if isempty(ind)
                % What the hell happened? There is an empty index?
                return
            end
            
            [path, ~, ~] = fileparts( this.dataFilesWithPath{ind} );
            
            timelineFileWithPath = fullfile(path, 'timeline.mat');
            
            if ~exist( timelineFileWithPath, 'file')
                % Timeline file doesn't exist - soft fail by returning an
                % empty string
                timelineFileWithPath = [];
                return
            end
            
        end
        
        
        function metaDataFileWithPath = getMetaDataFileWithPathFromUISelection(this)
        
            metaDataFileWithPath = [];
            
            ind = this.targetUI.Value;
            if isempty(ind)
                % What the hell happened? There is an empty index?
                return
            end
            
            [path, ~, ~] = fileparts( this.dataFilesWithPath{ind} );
            
            metaDataFileWithPath = fullfile(path, 'metadata.mat');
            
            if ~exist( metaDataFileWithPath, 'file')
                % Timeline file doesn't exist - soft fail by returning an
                % empty string
                metaDataFileWithPath = [];
                return
            end
            
        end
        
        
        % Numeric/Index Return Methods
        % -----------------------------------------------------------------
        function dataSetIndex =         getDataSetIndexFromUISelection(this)
        
            dataSetIndex = [];
            
            ind = this.targetUI.Value;
            if isempty(ind)
                % What the hell happened? There is an empty index?
                return
            end
            
            dataSetIndex = this.fdDataSetIndex(ind);
            
        end
        
        
        % Structure / Variable Return Methods
        % -----------------------------------------------------------------
        function timelineStruct =       getTimelineStructFromUISelection(this)
           
            timelineStruct = [];
            
            timelineFileWithPath = this.getTimelineFileWithPathFromUISelection;
            
            if isempty(timelineFileWithPath)
                return
            end
            
            temp = load(timelineFileWithPath, 'timeline');
            timelineStruct = temp.timeline;
            
        end
        
        
        function metaDataStruct =       getMetaDataStructFromUISelection(this)
           
            metaDataStruct = [];
            
            metaDataFileWithPath = this.getMetaDataFileWithPathFromUISelection;
            
            if isempty(metaDataFileWithPath)
                return
            end
            
            temp = load(metaDataFileWithPath, 'metaData');
            metaDataStruct = temp.metaData;
            
        end
        
        function fdStruct = getFDStructureFromUISelection(this)
            
            fdStruct = [];
            
            fdDataFileWithPath = this.getDataFilePathFromUISelection{1};
            
            if isempty(fdDataFileWithPath)
                return
            end
            
            temp = load(fdDataFileWithPath, 'fd');
            fdStruct = temp.fd;
            
        end
        
        
        
    end
    
   
    
end

