function [ structureTypeString ] = checkStructureType( testVariable )
%CHECKSTRUCTURETYPE returns a string with the name of the structure tested
%
%   Valid structure return strings
%
%   fd
%   graph
%   timeline
%   metadata
%   config
%   searchResult
%
%   Will return an empty string if no match. Extra fields will not falsify
%   the check. The prototype (makeStructure) fields must ALL be present.
%
%       EXAMPLE: 
% 
%       checkStructureType( newGraphStructure )
% 
%       returns:
% 
%       ans =
% 
%       graph
% 
%
%   This function uses the prototype definition functions to generate the
%   test conditions. It does not require updating unless a new structure
%   prototype is added. Existing prototype functions can be modified and
%   this test will continue to work.
%
%   Counts - 2016, VCSFA
%   Pruce  - 7-14-16, VCFSA


%% Instantiate variables for use in the function

structureTypeString = [];



fdPrototype             = newFD;
graphPrototype          = newGraphStructure;
timelinePrototype       = newTimelineStructure;
metadataPrototype       = newMetaDataStructure;
configPrototype         = newConfig;
searchResultPrototype   = newSearchResult;

% Create a cell array where each row is {'structure name', {'field list'}}

prototypes = {  'fd',           fieldnames(fdPrototype)';
                'graph',        fieldnames(graphPrototype)';
                'timeline',     fieldnames(timelinePrototype)';
                'metadata',     fieldnames(metadataPrototype)';
                'config',       fieldnames(configPrototype)';
                'searchResult', fieldnames(searchResultPrototype)'};
            
            
%% Check each structure type
%
% This test requires that all prototype structure fields are present to
% validate a structure. Additional fields may be present and are not
% checked

    
    % Only test if testVariable is a structure (this method is actually
    % robust to non-structure variables being passed. This is not required)
    
    if ~isstruct(testVariable)
        return
    end
        
            
    for n = 1:length(prototypes)
    
    
    % Using switch statement for readability - lots of duplicated code
    % here.
    
    % TODO: change this to automatically return the structure type using
    % the prototypes cell array?
    
        switch prototypes{n, 1}
            case 'fd'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'fd';
                    break 
                end

            case 'graph'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'graph';
                    break
                end

            case 'timeline'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'timeline';
                    break
                end

            case 'metadata'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'metadata';
                    break
                end
                
            case 'config'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'config';
                    break
                end
                
            case 'searchResult'
                if doesVariableHaveAllFields(testVariable, prototypes{n,2})
                    structureTypeString = 'searchResult';
                    break
                end

            otherwise
                % Why did I include this case? Probably nothing to do here
        end


    end


end



            

function allFieldsMatch = doesVariableHaveAllFields(testVar, fieldList)

    allFieldsMatch = true;
    
    for i = 1:numel(fieldList)
        
        % Use multiply to falsify the allFieldsMatch flag if any field is
        % missing

        allFieldsMatch = allFieldsMatch * isfield(testVar, fieldList{i});
        
    end

end

