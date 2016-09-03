 

searchResultArray = statensFunction



%% Build Pop-up/down menu contents

FDListStringNames = []
FDfilnameAndPathArray = []

% This does not handle empty search results (probably)

%loop through all searchResult structures in array for i = 1:(numel(searchResult)

    % Make FD strings for menu
  for i=1:numel(searchResult)
      
    
        titleString(i) = makeStringFromMetaData(searchResult(i));

        FDListStringNames = strjoin({tempFDListStringNames , titleString(i)});
          
    % Make file/path list for later

%         pathString = is the path string for this search resiult/data set
          fdFileNameWithPath = char(fullfile(searchResult(i).pathToData,filesep, tempFDListStringNames {i,2})); % curly braces or parenthesis? IDK

          tempFilenameAndPathString = strjoin({tempFilenameAndPathString, fdFileNameWithPath(i)});
%         tempFilenameAndPathString = makeAllthepaths
        
        
    % append temporary lists to final lists
    FDListStringNames = strcat(FDListStringNames, tempFDListStringNames)
    FDfilnameAndPathArray = []


  end

% 

handles.FDList_popupmenu.String = strcat(titleString,searchResult.matchingFDList(:,1));


