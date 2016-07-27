function [commodityFDList] = searchfdListByCommodity( foundDataToSearchFDList, fdTypeInput )
%% searchfdListByCommodity()

% Purpose: Provides a means of searching through a given fd list for a given search expression.

% Function input (foundDataToSearchFDList, fdTypeInput) takes a given fd
% list and commodity search expression.

% Function output commodityFDList creates a new list of every available fd
% narrowed by commodity search expression.

% Example output:
%             commodityFDList = 
% 
%                 'RP1 PCVNC-1014 State'         '1014.mat'                 
%                 'RP1 PCVNC-1015 State'         '1015.mat'                 
%                 'RP1 PCVNC-1015 Commande…'    '1015cmd.mat'              
%                 'RP1 FM-1016 Coriolis Me…'    '1016.mat'      

% Supporting functions:
%    searchTimeStamp - narrows search results by time parameters

% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


commodityFDList = []; % empty cell array of structures - will hold fd matches

% index over list of input fd values
for i = 1:length(foundDataToSearchFDList)

    % switch/case statement to accomodate searches by different commodities
    switch fdTypeInput

        case 'RP1' % commodityFDList = fd list with matches for 'RP1'
            
            % ignores any character between RP1 (i.e. RP-1, RP/1, RP*1) and is case insensitive
            replacementRP1 = regexprep( foundDataToSearchFDList{i,1}, 'RP(\W+)1', 'RP1', 'ignorecase' );

            % if input fd list contains 'RP1' or 'FLS' string matches (case insensitive)
            if ~isempty(regexpi( replacementRP1 , 'RP1' ) ) || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'FLS') )

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );

            end % end RP1 if loop

            
        case 'LO2' % commodityFDList = fd list with matches for 'LO2'
            
            % if input fd list contains 'LO2' or 'LOLS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LO2') ) || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LOLS') ) 

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end % end LO2 if loop
            
            
        case 'LN2' % commodityFDList = fd list with matches for 'LN2'
            
            % if input fd list contains 'LN2' or 'LNSS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LN2') ) || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'LNSS') )

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end % end LN2 if loop
            
            
        case 'GN2' % commodityFDList = fd list with matches for 'GN2'
            
            % if input fd list contains 'GN2' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'GN2') ) 

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
            
            end % end GN2 if loop
            
            
        case 'GHE' % commodityFDList = fd list with matches for 'GHE'
            
            % if input fd list contains 'GHe' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'GHe') )

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
                
            end % end GHe if loop
            
            
        case 'ECS' % commodityFDList = fd list with matches for 'ECS'
            
            % if input fd list contains 'ECS' or 'AIR' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'ECS') ) || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'AIR') )

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
                
            end % end ECS if loop
            
            
        case 'WDS' % commodityFDList = fd list with matches for 'WDS'
            
            % if input fd list contains 'WDS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'WDS') )

                % create a temporary fd list for each found fd indexing
                tempcommodityFDList = foundDataToSearchFDList(i,:);
                
                 % append temporary fd list to output fd list
                commodityFDList = vertcat(commodityFDList, tempcommodityFDList );
           
            end % end WDS if loop
            
    end % end switch/case statement

end % end for loop iterating over input fd list

end % end searchfdListByCommodity function

% =========================================================================
% garbage


% %% FD List Commodity Search
% 
% ORB1 = 735608.1;
% ORB31 = 735900.4;
% ORB32 = 735900.6;
% WDR = 736472;
% hotfire = 736481;
%  
% 

% % some dummy input to test this function
% foundDataToSearch = newSearchTimeStamp([ORB32 hotfire]);
% 
% foundDataToSearchFDList = foundDataToSearch.fdList;
% 
% % subfunction to search through fd list by commodity input

% fix case sensitive
% fix RP1 character search



% dataRepositoryDirectory = 'C:\Users\Staten\Desktop\Data Repository'; % set file path
% 
% load( fullfile(dataRepositoryDirectory, 'dataToSearch.mat') ); % load variables from dataToSearch

 % if the fd list contains RP1 or is 1000 level (there are two
            % rando WDS 1000 level results..can prob fix that with hard coding but yea)
            % ^this means there are probably more than a few exceptions to
            % these searches...?
            
            % if fd list contains sting 'RP1' in first or second column
%             if ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'RP1') ) || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'RP1') ) ...
%                 || ~isempty(regexpi( foundDataToSearchFDList{i,1}, 'FLS') ) || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'FLS') )...
%                % || ~isempty( regexpi( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 
%            
          
%|| ~isempty(regexpi( regexprep( foundDataToSearchFDList{i,2}, 'RP(\w+)1', 'RP1', 'ignorecase' ) , 'RP1') ) ...
 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'FLS') )...
 
 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LO2') ) ...
                 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LOLS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 
                
% || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LN2') ) ...
                 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'LNSS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 
                
                
 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'GN2') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) )                

 % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'GHe') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) )        
                
% || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'ECS') ) ...
              % || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'AIR') ) 
           % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^1\w*' ) ) 
           
% || ~isempty(regexpi( foundDataToSearchFDList{i,2}, 'WDS') )
                % || ~isempty( regexp( foundDataToSearchFDList{i,2}, '^0\w*' ) ) 