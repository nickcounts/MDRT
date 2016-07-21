 function titleString = makeStringFromMetaData(searchResult)

   titleString = '';

    opString        = '';
    opTypeString    = '';
    dateString      = '';
    
%     
%     %For i=1:lengthof(searchResult) <-- does this try to do length of the
%     %actual serachResult structure or return length of the array of
%     %strcutures? aka how many structures in the array
%     
%     % change all searchResults to searchResult(i) 
%     arraylength = length(searchResult);
%     
%     for i=1:arraylength
%         
%        if searchResult(i).metaData.isOperation
%         if isempty(searchResult(i).metaData.operationName)
%             is op, but no name - make a default name
%             if     searchResult(i).metaData.isVehicleOp
%                 opString = 'Vehicle Support';
%                 
%             elseif searchResult(i).metaData.isMARSprocedure
%                 opString = 'MARS Procedure';
%                 
%             elseif searchResult(i).metaData.isOperation
%                 opString = 'Operation';
%                 
%             end
%               titleString = strjoin({titleString,' ', opString});
%              
%         else
%             % is op and has title
%             opString = searchResult(i).metaData.operationName;
%             titleString = strjoin({titleString,' ', opString});
%          
%             display(titleString)
%         end
%         
%     else
%         if ~isempty(searchResult(i).metaData.timeSpan)
%         startStr = datestr(searchResult(i).metaData.timeSpan(1), 'mmm dd, yyyy');
%         stopStr  = datestr(searchResult(i).metaData.timeSpan(2), 'mmm dd, yyyy');
%         % loop to see if they occur in same year
%             if strcmp(startStr,stopStr)
%             newStartStr = datestr(searchResult(i).metaData.timeSpan(1), 'mmm dd');
%             newStopStr  = datestr(searchResult(i).metaData.timeSpan(2), 'mmm dd');
%             
%             dateString = strjoin({newStartStr,'to', newStopStr});
%             else
%             dateString = strjoin({startStr,'to', stopStr}); 
%             end
%         titleString = strjoin({titleString, dateString})
%         display(titleString)
%         end
%        end
%     end
%     
%   keyboard 
%% ---------------------------------------------------------------------%%    
% ---- (working function for 1 single serachResult struct BELOW)  -----   
    
%     
    if searchResult.metaData.isOperation
        if isempty(searchResult.metaData.operationName)
            is op, but no name - make a default name
            if     searchResult.metaData.isVehicleOp
                opString = 'Vehicle Support';
                
            elseif searchResult.metaData.isMARSprocedure
                opString = 'MARS Procedure';
                
            elseif searchResult.metaData.isOperation
                opString = 'Operation';
                
            end
            titleString = strjoin({titleString,' ', opString});
        else
            % is op and has title
            opString = searchResult.metaData.operationName;
            titleString = strjoin({titleString,' ', opString});
        end
    else
         if ~isempty(searchResult.metaData.timeSpan)
        startStr = datestr(searchResult.metaData.timeSpan(1), 'mmm dd, yyyy');
        stopStr  = datestr(searchResult.metaData.timeSpan(2), 'mmm dd, yyyy');
        % loop to see if they occur in same year
        if strcmp(startStr,stopStr)
            newStartStr = datestr(searchResult.metaData.timeSpan(1), 'mmm dd');
            newStopStr  = datestr(searchResult.metaData.timeSpan(2), 'mmm dd');
            
            dateString = strjoin({newStartStr,'to', newStopStr});
        else
            dateString = strjoin({startStr,'to', stopStr}); 
        end
        titleString = strjoin({titleString, dateString})
        end
    end
    
    
    
    
%     
%     
% --- I do not think i need this section for my purposes --------    
%     if searchResult.metaData.isVehicleOp
%         opTypeString = 'Vehicle Suport';
%     elseif searchResult.metaData.isMARSprocedure
%         opTypeString = 'MARS Procedure';
%     else
%         opTypeString = 'Normal Standby Data';
%     end
%         
%     
%     % TODO: make smarter dateString depending on time interval, using the
%     % same month and year whenever possible
%     if ~isempty(searchResult.metaData.timeSpan)
%         startStr = datestr(searchResult.metaData.timeSpan(1), 'mmm dd, yyyy');
%         stopStr  = datestr(searchResult.metaData.timeSpan(2), 'mmm dd, yyyy');
%         % loop to see if they occur in same year
%         if strcmp(startStr,stopStr)
%             newStartStr = datestr(searchResult.metaData.timeSpan(1), 'mmm dd');
%             newStopStr  = datestr(searchResult.metaData.timeSpan(2), 'mmm dd');
%             
%             dateString = strjoin({newStartStr,'to', newStopStr});
%         else
%             dateString = s% %         end
% %     end
%    
% 	titleString = strjoin({titleString, opString, opTypeString, '-', dateString});
% trjoin({startStr,'to', stopStr}); 
% -----------------------------------------------------------------------    
    

