function [ FDListStringNames,FDFileNameWithPath, FDPathToDataFolder] = makeNameAndPathFromSearchResult( searchResult, handles )

% searchResultArray = statensFunction

%% Build Pop-up/down menu contents


% Need to find length of each FDList and add together to preallocate length
% of final FDList array
% arraylength = length of final FDListStringNames array and
% FDFileNameWithPath array

arraylength = 0;

FDListStringNames = [];
FDFileNameWithPath = [];
FDPathToDataFolder = [];

for i=1:length(searchResult)
    fdlength = length(searchResult(i).matchingFDList);
    arraylength = arraylength + fdlength;
end


    %loop through all searchResult structures in array for i = 1:(numel(searchResult)
    % Make FD strings for menu
  for i=1:length(searchResult)
      
    % Make unique title string for this single searchResult 
       opString = makeStringFromMetaData(searchResult(i));
      
        %Create array of 'opString + each individual FD file name'
       listlen = length(searchResult(i).matchingFDList);
       
       tempFDList = cell(listlen,1);
       tempfdFileNameWithPath =  cell(listlen,1);
       tempFDPathToDataFolder =  cell(listlen,1);
      
       for k = 1:listlen
           
           
           tempFDList{k} = strtrim(strjoin( { opString, searchResult(i).matchingFDList{k,1} } ));  
           tempfdFileNameWithPath{k} = char(fullfile(searchResult(i).pathToData,filesep,searchResult(i).matchingFDList{k,2}));
           tempFDPathToDataFolder{k} = char(searchResult(i).pathToData);
       end
%            tempfdFileNameWithPath = tempfdFileNameWithPath';
       % tempFDList now contains all assembled title strings
      
        %Add the above array to master name list

        FDListStringNames = cat(1,FDListStringNames , tempFDList);
        FDListStringNames = FDListStringNames(~cellfun('isempty',FDListStringNames));
        
        FDFileNameWithPath = cat(1,FDFileNameWithPath, tempfdFileNameWithPath);
        FDFileNameWithPath(cellfun('isempty',FDFileNameWithPath)) = [];
        
        FDPathToDataFolder = cat(1,FDPathToDataFolder, tempFDPathToDataFolder);
        FDPathToDataFolder(cellfun('isempty',FDPathToDataFolder)) = [];
        
        
  end
 
  
end
  
%         
%     % Make file/path list for later
% 
% %         pathString = is the path string for this search resiult/data set
% 
%           tempfdFileNameWithPath{i} = char(fullfile(handles.searchResult(i).pathToData,filesep,searchResult(i).matchingFDList(i,2))); % curly braces or parenthesis? IDK
%           
%           FilenNameWithPath = strcat({FilenNameWithPath, tempfdFileNameWithPath{i}});
%           
% %         tempFilenameAndPathString = makeAllthepaths
%         
%         
%     % append temporary lists to final lists
% %     FDListStringNames = strcat(FDListStringNames, tempFDListStringNames)
% %     FDfilnameAndPathArray = []



 

% handles.FDList_popupmenu.String = strcat(FDListStringNames,searchResult.matchingFDList(:,1));
% handles.FDList_popupmenu.String = strcat(FDListStringNames);


