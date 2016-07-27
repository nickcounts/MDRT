function testLoopingThroughStruct

% make a search query to test

searchQuery = struct;
searchQuery.isOperation = true;
searchQuery.isVehicleOp = false;

% functions that will help you
fieldnames(searchQuery);
isempty(fieldnames(struct));

% return the list of field names as a cell array of strings
fieldsToFilterBy = fieldnames(searchQuery);


for i = 1:numel(fieldsToFilterBy)
    
    debugout( fieldsToFilterBy{i} )
    
    switch fieldsToFilterBy{i}
        case 'isOperation'
            debugout(fieldsToFilterBy(i))
            
        case 'isVehicleOp'
            debugout(fieldsToFilterBy(i))
            
            
    end
end




end