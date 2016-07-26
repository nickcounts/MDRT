% %% FD List Commodity Search
% 
% ORB1 = 735608.1;
% ORB31 = 735900.4;
% ORB32 = 735900.6;
% WDR = 736472;
% hotfire = 736481;
%  
% 
% % this function takes the output from the searchTimeStamp function as input
% % some dummy input to test this function
% foundDataToSearch = newSearchTimeStamp([ORB32 hotfire]);
% 
% foundDataToSearchFDList = foundDataToSearch.fdList;
% 
% % subfunction to search through fd list by commodity input

% fix case sensitive
% fix RP1 character search

function [commodityFDList] = searchfdListByCommodity( foundDataToSearchFDList, fdTypeInput )

% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch

commodityFDList = [];

for i = 1:length(foundDataToSearchFDList)

    switch fdTypeInput

        case 'RP1'
            

            % ignores any character between RP1 (i.e. RP-1, RP/1, RP*1) and
            % is case insensitive
            replacementRP1 = regexprep( foundDataToSearchFDList{i,1}, 'RP(\W+)1', 'RP1', 'ignorecase' )

            % if the fd list contains RP1 or is 1000 level (there are two
            % rando WDS 1000 level results..can prob fix that with hard coding but yea)
            % ^this means there are probably more than a few exceptions to
            % these searches...?
            
            % if fd list contains sting 'RP1' in first or second column
%             if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'RP1') ) || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'RP1') ) ...
%                 || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'FLS') ) || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'FLS') )...
%                % || ~isempty( regexpi( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 
%            
          
           if ~isempty(regexpi( replacementRP1 , 'RP1' ) ) ... %|| ~isempty(regexpi( regexprep( foundDataToSearchFDList{i,2}, 'RP(\w+)1', 'RP1', 'ignorecase' ) , 'RP1') ) ...
                || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'FLS') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'FLS') )...

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );

        % commodityFDList = anything that matches RP1 in search through fd list
            end

        case 'LO2'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LO2') ) ... % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LO2') ) ...
                || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LOLS') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LOLS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end
            
            
        case 'LN2'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LN2') ) ... % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LN2') ) ...
                || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LNSS') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LNSS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end
            
        case 'GN2'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'GN2') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'GN2') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end
            
            
        case 'GHe'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'GHe') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'GHe') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
                
            end
            
            
        case 'ECS'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'ECS') ) ... % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'ECS') ) ...
               || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'AIR') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'AIR') ) 
           % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
                
            end
            
            
        case 'WDS'
            
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'WDS') ) % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'WDS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^0\w*' ) ) 

                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
           
            end
            
    end




end
