function [ metaDataFlags ] = newMetaDataFlags( input_args )
% returns a default metaDataFlag structure for MARS Review Tool.
%
% an example dataMetaData structure is below:
%   
%       metaDataFlags =  
%
%                   isOperation: true %true or false values
%                   isVehicleOp: false %true or false values
%                   isProcedure: false %true or false values
%                    hasMARSUID: true %true or false values
%
% Pruce 7-27-16, Virginia Commercial Spaceflight Authority

    metaDataFlags.isOperation = 0;
    metaDataFlags.isVehicleOp = 0;
    metaDataFlags.isMARSprocedure = 0;
     metaDataFlags.hasMARSuid = 0;


end

