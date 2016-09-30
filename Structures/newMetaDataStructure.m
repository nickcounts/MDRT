function [ dataMetaData ] = newMetaDataStructure( input_args )
%% newMetaDataStructure()
%%%% CHANGE BY PAIGE -- replaced MARSuid with fdList

%   returns a default dataMetaData structure for MARS Review Tool.
%
%   The structure defaults to an empty set with isUTC = true.
%
%   an example dataMetaData structure is below:
%
%     dataMetaData = 
% 
%                  timeSpan: [7.3648e+05 7.3648e+05]
%                     isUTC: 1
%               isOperation: 1
%             operationName: 'A230 Stage Test'
%               isVehicleOp: 1
%           isMARSprocedure: 0
%         MARSprocedureName: ''
%                hasMARSuid: ''
%                   MARSuid: '' <--- DELETED
%                    fdList: ''
%
% Counts 6-10-16, Virginia Commercial Spaceflight Authority


dataMetaData.timeSpan           = [];
dataMetaData.isUTC              = true;
dataMetaData.isOperation        = false;
dataMetaData.operationName      = '';
dataMetaData.isVehicleOp        = false;
dataMetaData.isMARSprocedure    = false;
dataMetaData.MARSprocedureName  = '';
dataMetaData.hasMARSuid         = false;
dataMetaData.fdList             = '';



end

