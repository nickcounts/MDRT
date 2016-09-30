function [commodityFDList] = searchfdListByCommodity( foundDataToSearchFDList, fdTypeInput )
%% searchfdListByCommodity()
%
% Purpose: Provides a means of searching through a given fd list for a given search expression.
%
% Function input (foundDataToSearchFDList, fdTypeInput) takes a given fd
% list and commodity search expression.
%
% Function output commodityFDList creates a new list of every available fd
% narrowed by commodity search expression.
%
% Example output:
%             commodityFDList = 
% 
%                 'RP1 PCVNC-1014 State'         '1014.mat'                 
%                 'RP1 PCVNC-1015 State'         '1015.mat'                 
%                 'RP1 PCVNC-1015 Commande…'    '1015cmd.mat'              
%                 'RP1 FM-1016 Coriolis Me…'    '1016.mat'      
%
% Supporting functions:
%    searchTimeStamp - narrows search results by time parameters
%
% Longo 8-11-16, Virginia Commercial Space Flight Authority (VCSFA)


commodityFDListNames = []; % empty cell array of structures - will hold fd name matches
commodityFDListPaths = []; % empty cell array of structures - will hold fd path matches
commodityFDListNamePathsToDataSet = []; % empty cell array of structures - will hold fd path to data set matches

% index over list of input fd values
for i = 1:length(foundDataToSearchFDList.names)

    % switch/case statement to accomodate searches by different commodities
    switch fdTypeInput

        case 'RP1' % commodityFDList = fd list with matches for 'RP1'
            
            % ignores any character between RP1 (i.e. RP-1, RP/1, RP*1) and is case insensitive
            replacementRP1 = regexprep( foundDataToSearchFDList.names{i,1}, 'RP(\W+)1', 'RP1', 'ignorecase' );

            % if input fd list contains 'RP1' or 'FLS' string matches (case insensitive)
            if ~isempty(regexpi( replacementRP1 , 'RP1' ) ) || ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'FLS') )

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );

            end % end RP1 if loop

            
        case 'LO2' % commodityFDList = fd list with matches for 'LO2'
            
            % if input fd list contains 'LO2' or 'LOLS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'LO2') ) || ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'LOLS') ) 

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
            
            end % end LO2 if loop
            
            
        case 'LN2' % commodityFDList = fd list with matches for 'LN2'
            
            % if input fd list contains 'LN2' or 'LNSS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'LN2') ) || ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'LNSS') )

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
            
            end % end LN2 if loop
            
            
        case 'GN2' % commodityFDList = fd list with matches for 'GN2'
            
            % if input fd list contains 'GN2' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'GN2') ) 

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
            
            end % end GN2 if loop
            
            
        case 'GHE' % commodityFDList = fd list with matches for 'GHE'
            
            % if input fd list contains 'GHe' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'GHe') )

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
                
            end % end GHe if loop
            
            
        case 'ECS' % commodityFDList = fd list with matches for 'ECS'
            
            % if input fd list contains 'ECS' or 'AIR' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'ECS') ) || ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'AIR') )

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
                
            end % end ECS if loop
            
            
        case 'WDS' % commodityFDList = fd list with matches for 'WDS'
            
            % if input fd list contains 'WDS' string matches (case insensitive)
            if ~isempty(regexpi( foundDataToSearchFDList.names{i,1}, 'WDS') )

                % create a temporary value for each found fd name indexing
                tempCommodityFDListNames = foundDataToSearchFDList.names(i,:); 
                
                % create a temporary value for each found fd path indexing
                tempCommodityFDListPaths = foundDataToSearchFDList.paths(i,:);
                
                % create a temporary value for each found fd path to data set indexing
                tempCommodityFDListNamePathsToDataSet = foundDataToSearchFDList.pathsToDataSet(i,:);
                
                % append temporary fd list of names cell array
                commodityFDListNames = vertcat(commodityFDListNames, tempCommodityFDListNames );
                
                % append temporary fd list of paths cell array
                commodityFDListPaths = vertcat(commodityFDListPaths, tempCommodityFDListPaths );

                % append temporary fd list of paths to data set cell array
                commodityFDListNamePathsToDataSet = vertcat(commodityFDListNamePathsToDataSet, tempCommodityFDListNamePathsToDataSet );
           
            end % end WDS if loop
            
    end % end switch/case statement

end % end for loop iterating over input fd list

% create a structure commodityFDList containing each cell array as a separate field:

    % field containing cell array of string names
    commodityFDList.names = commodityFDListNames;

    % field containing cell array of string paths
    commodityFDList.paths = commodityFDListPaths;

    % field containing cell array of string paths to data sets
    commodityFDList.pathsToDataSet = commodityFDListNamePathsToDataSet;

end % end searchfdListByCommodity function           