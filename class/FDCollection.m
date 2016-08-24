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
        
        masterDataStreamNames         = {};
        dataFilesWithPath       = {};
        timelineFilesWithPath   = [];
        fdDataSetIndex          = [];
        
        selectedDataSet          = [];
        
    end
    
    
    properties (SetAccess = public)
        
        targetUI                = [];
        searchUI                = [];
        
        
    end
    
    
    properties (SetAccess = private)
        
        searchJUI               = [];
        sbListener              = [];
        dataIndex
        
        searchResultLogicalIndex = [];
        
    end
    
    
    properties (Dependent)
        
        searchResults
        dataSetNames
        
        selectedDataSetLogicalIndex
        
        isActiveSearch
        
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
            % FDCollection(dataIndexVector, selectedDataIndexVector)
            % FDCollection(dataIndexVector, selectedDataIndexVector, UITarget)
            %
            % If no UITarget is specified, the FDCollection will have no
            % target uicontrol object. This can be set after object
            % instantiation if desired
            %
            % If no selectedDataIndexVector is specified, all data sets in
            % dataIndexVector will be added to the FDCollection object.
            
            
            % Check input number and type
            
            if ~nargin
                warning('FDCollection constructor requires a dataIndexVector');
                return
            end
            
            dataIndexVector = varargin{1};
            thisFDCollection.dataIndex = dataIndexVector;
            
            % Default to selecting ALL data sets
            selectedDataIndexVector = 1:numel(dataIndexVector);

            targetUI = [];

            
            debugout(nargin)
            
            % Allow 3 different constructor argument lists, and handle
            % incorrect order of #2 and #3
            % -------------------------------------------------------------
            switch nargin
                case 1
                    % FDCollection(dataIndexVector)
                
                case 2
                    % FDCollection(dataIndexVector, UITarget)
                    % FDCollection(dataIndexVector, selectedDataIndexVector)

                    if ishghandle( varargin{2} )
                        targetUI = varargin{2};

                    else
                        % Using a subset of the dataIndex fds and no
                        % uitarget was passed
                        selectedDataIndexVector = varargin{2};
                    end
                    
                case 3
                    % Using a subset of the dataIndex fds and a targetUI
                    % control handle was passed
                    
                    
                    if ishghandle( varargin{3} ) && ~isempty(varargin{3})
                        % FDCollection(dataIndexVector, fdListVector, UITarget)
                        debugout('FDCollection(dataIndexVector, selectedDataIndexVector, UITarget)')

                        selectedDataIndexVector    = varargin{2};
                        targetUI        = varargin{3};

                    else
                        % FDCollection(dataIndexVector, UITarget, fdListVector)
                        debugout('FDCollection(dataIndexVector, UITarget, selectedDataIndexVector)')

                        selectedDataIndexVector    = varargin{3};
                        targetUI        = varargin{2};

                    end 
            end
            
            
            
            thisFDCollection.targetUI = targetUI;
            
            
            
            
            % UITarget, dataIndexVector, fdListVector
            
            dataStreamNames     = {};
            dataFilesWithPath   = {};
            timelineFilesWithPath = {};
            fdDataSetIndex      = [];
        
            
            
            % set object property with corrected selectedDataIndexVector
            thisFDCollection.selectedDataSet = selectedDataIndexVector;
                        
            % Build the object properties for a subset of data sets 
            % -------------------------------------------------------------
            for i = 1:numel(selectedDataIndexVector)
                
                tempTimelineFileWithPath = fullfile( dataIndexVector(selectedDataIndexVector(i)).pathToData, 'timeline.mat');
                
                
                if ~exist( tempTimelineFileWithPath, 'file')
                    % if no timeline file, set tempTimelineFileWithPath to
                    % empty stringso the final list doesn't have a link to
                    % a nonexistant file
                    tempTimelineFileWithPath = {''};
                end
                
                
                % Build internal variables by looping through input
                % arguments
                % ---------------------------------------------------------

                dataStreamNames   = vertcat( dataStreamNames, ...
                                             dataIndexVector(selectedDataIndexVector(i)).metaData.fdList(:,1) );

                dataFilesWithPath = vertcat( dataFilesWithPath, ...
                    fullfile( dataIndexVector(selectedDataIndexVector(i)).pathToData, ...
                              dataIndexVector(selectedDataIndexVector(i)).metaData.fdList(:,2) ) );

                timelineFilesWithPath = vertcat ( timelineFilesWithPath, tempTimelineFileWithPath);
                

                fdDataSetIndex = vertcat( fdDataSetIndex, i*ones(length(dataIndexVector(selectedDataIndexVector(i)).FDList(:,1)),1) );
                                       
            end
            
            thisFDCollection.searchResultLogicalIndex = true(size(dataStreamNames));
            thisFDCollection.masterDataStreamNames = dataStreamNames;
            thisFDCollection.dataFilesWithPath = dataFilesWithPath;
            thisFDCollection.timelineFilesWithPath = timelineFilesWithPath;
            thisFDCollection.fdDataSetIndex = fdDataSetIndex;
                
            
            
            
        end
        
        
        % Set Methods
        % -----------------------------------------------------------------
        function this = set.targetUI(this, uihandle)
            
            if ishghandle(uihandle)
                         
                this.targetUI = uihandle;
                
            end
            
        end
        
        
        function this = set.searchUI(this, uihandle)
            
            if ishghandle(uihandle) && strcmpi(uihandle.Style, 'edit')
                
                this.searchUI = uihandle;
                this.searchJUI = findjobj(this.searchUI);
                this.sbListener = addlistener(uihandle, 'KeyRelease', ...
                    @this.searchByGuiContents );
                
            end
            
        end
        
        
        function self = set.selectedDataSet(self, dataSetIndex)
            %selectedDataSet
            %
            % accepts ingeger values that correspond to each dataIndex
            % structure in the structure array
            %
            % setting to empty [] selects all sets
            %
            % Supports row vector index.
            
            
            dataSetCount = numel(self.dataIndex);
            validSetIndex = 1:dataSetCount;
            
            % Empty input sets to all available datasets!
            if isempty(dataSetIndex)
                self.selectedDataSet = 1:dataSetCount;
                return
            end
            
            % Halt creation if passed a malformed dataIndexVector and 
            % selectedDataIndexVector pair
            % -------------------------------------------------------------
            if sum(ismember(dataSetIndex, validSetIndex)) == numel(dataSetIndex);
                % each dataSetIndex is valid
            else
                % dataSetIndex had invalid entries
                warning('dataSetIndex contains references to nonexistant metaDataVector elements')
                % remove invalid data set indeces
                dataSetIndex(~ismember(dataSetIndex, validSetIndex)) = [];
            end

            self.selectedDataSet = dataSetIndex;
            
            self.populateListbox

        end

        
        % Dependent Property Get Methods
        % -----------------------------------------------------------------
        function dataSetNames = get.dataSetNames(self)
            
            dataSetNames = {};
            
            if numel(self.dataIndex)

                for i = 1:numel(self.dataIndex)

                    newSetName = self.makeStringFromMetaData(self.dataIndex(i).metaData);
                    dataSetNames = vertcat(dataSetNames,  newSetName);

                end
                
            end
            
        end

        
        function index = get.selectedDataSetLogicalIndex(self)
            
            % Preallocate logical array with false
            index = false(length(self.masterDataStreamNames), numel(self.selectedDataSet));
            
            for i = 1:numel(self.selectedDataSet)
                
                index(:,i) = self.fdDataSetIndex == self.selectedDataSet(i);
                
            end
            
            index = logical(sum(index, 2));
            
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
            
            toDisplay = logical( prod( [this.selectedDataSetLogicalIndex, this.searchResultLogicalIndex],2));
            
            if isempty(this.targetUI.Value)
                this.targetUI.Value = 1;
            end
            
            
            if isempty(this.masterDataStreamNames(toDisplay)) 
                
            elseif numel(this.masterDataStreamNames(toDisplay)) < numberOfOldStrings
                
            elseif numel(this.masterDataStreamNames(toDisplay)) >= numberOfOldStrings
                % In this case, the old Value is still good 
            end
            
            this.targetUI.String = this.masterDataStreamNames(toDisplay);

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
        
        
        % Search Functions
        % -----------------------------------------------------------------
        function searchByString(self, searchString)
            %searchByString updates the targetUI listbox based on a search
            %of the masterDataStreamNames using the searchString argument.
            %
            % searchByString( searchString )
            % searchByString( searchCellStr)
            
            
            % Remove string from cell
            while iscell(searchString)
                searchString = searchString{1};
            end
            
            % Split into tokens
            searchToks = strsplit(searchString);
            
            % remove stray whitespace
            searchToks = strtrim(searchToks);
            searchToks(strcmp('',searchToks)) = [];

            % start with empty match index variable
            ind = [];
            
            
            
            
            
            
            % create an index of matches for each token
            % -------------------------------------------------------------
            for i = 1:numel(searchToks)
                keyboard
                ind = [ind, cellfun(@(x)( ~isempty(x) ), ...
                       regexpi(self.masterDataStreamNames, searchToks{i}))];
            end
            
            % combine matches (and searching, not or)
            ind = logical(prod(ind,2));
           
           
            % Perform search by 
            if numel(searchString)
       
               % A non-empty search string means search!
               if length(self.masterDataStreamNames(ind)) >= self.targetUI.Value
                   % selected an item in the new list
                   % lsr.Value = length(masterList(ind));
                   % lsr.String = masterList(ind);
               elseif ~length(self.masterDataStreamNames(ind))
                   % New results are empty!
                   self.targetUI.Value = 1;
               else
                   % Selection is outside new (nonzero)result list
                   self.targetUI.Value = length(self.masterDataStreamNames(ind));
               end

                   self.targetUI.String = self.masterDataStreamNames(ind);
            else
               % No search string means return everything
               self.targetUI.String = self.masterDataStreamNames(self.selectedDataSetLogicalIndex);
            end
            
            % Set object's search result logical index
            self.searchResultLogicalIndex = ind;
            
        end
        
        
        function searchByGuiContents(self, varargin)
            
            % Do nothing if no search box set
            if isempty(self.searchUI)
                % clear search related properties
                self.isActiveSearch = false;
                self.searchResultLogicalIndex = [];
                return
            end
            
            searchString =  char(self.searchJUI.getText);
            
            self.searchByString(searchString);

        end
        
    end
    
    
    methods (Static)
        
        function titleString = makeStringFromMetaData(metaData)

            titleString = '';

            opString        = '';
            opTypeString    = '';
            dateString      = '';

            if metaData.isOperation
                if isempty(metaData.operationName)
                    % is op, but no name - make a default name
                    if     metaData.isVehicleOp
                        opString = 'Vehicle Support';

                    elseif metaData.isMARSprocedure
                        opString = 'MARS Procedure';

                    elseif metaData.isOperation
                        opString = 'Operation';

                    end
                else
                    % is op and has title
                    opString = metaData.operationName;
                end
            end

            if metaData.isVehicleOp
                opTypeString = 'Vehicle Suport';
            elseif metaData.isMARSprocedure
                opTypeString = 'MARS Procedure';
            else
                opTypeString = 'Normal Standby Data';
            end


            % TODO: make smarter dateString depending on time interval, using the
            % same month and year whenever possible
            if ~isempty(metaData.timeSpan)
                startStr = datestr(metaData.timeSpan(1), 'mmm dd, yyyy');
                stopStr  = datestr(metaData.timeSpan(2), 'mmm dd, yyyy');
                dateString = strjoin({startStr,'to', stopStr});
            end

            titleString = strjoin({titleString, opString, opTypeString, '-', dateString});
   
        end
        
 

        
    end
    

    
   
end

