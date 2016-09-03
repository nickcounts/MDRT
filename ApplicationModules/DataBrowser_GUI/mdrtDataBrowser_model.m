classdef mdrtDataBrowser_model < handle
    %mdrtDataBrowser_model model class for the mdrt gui application.
    %Conforming to MVC architecture.

    
    properties (SetObservable)
        
        dataSetCollectionList = '';
        % userDataSet
        selectedDataSet = [];
        dataStreamsInSelectedDataSet = {};
    end
    
    properties
        
        dataSetCollection
        config
    end
    
    methods
        function obj = mdrtDataBrowser_model()
            obj.config = MDRTConfig;
            obj.reset();
        end
                
        function reset(obj)
            
            % Get configuraiton data and load the data index            
            di = load( fullfile(obj.config.dataArchivePath, 'dataIndex.mat') );
            
            dataSetList = cell(numel(di.dataIndex), 1);
            
            for i = 1:numel(dataSetList)    
               dataSetList{i,1} = makeDataSetTitleStringFromActiveConfig(di.dataIndex(i).metaData); 
            end
            
            obj.dataSetCollectionList = dataSetList;
            
            obj.dataSetCollection = di.dataIndex;
            % obj.userDataSet = [];
            obj.selectedDataSet = 1;
            obj.dataStreamsInSelectedDataSet = obj.dataSetCollection(obj.selectedDataSet).metaData.fdList(:,1);
            
        end
        
        function setSelectedDataSet(obj, selectedIndex)
            
            obj.selectedDataSet = selectedIndex;
            obj.dataStreamsInSelectedDataSet = obj.dataSetCollection(selectedIndex).metaData.fdList(:,1);
            
        end
        
        function filterBySearchString(obj, searchString)
            disp(searchString);
        end
        
        
    end
    
end

