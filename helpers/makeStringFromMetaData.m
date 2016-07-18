function titleString = makeStringFromMetaData(searchResult)

   titleString = '';

    opString        = '';
    opTypeString    = '';
    dateString      = '';
    
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
    
    if searchResult.metaData.isVehicleOp
        opTypeString = 'Vehicle Suport';
    elseif searchResult.metaData.isMARSprocedure
        opTypeString = 'MARS Procedure';
    else
        opTypeString = 'Normal Standby Data';
    end
        
    
    % TODO: make smarter dateString depending on time interval, using the
    % same month and year whenever possible
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
    end
   
% 	titleString = strjoin({titleString, opString, opTypeString, '-', dateString});
    
    
end
