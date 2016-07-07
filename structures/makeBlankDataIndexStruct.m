function [ dataIndex ] = makeBlankDataIndexStruct( input_args )
%makeBlankDataIndexStruct generates a blank dataIndex structure
% 
% dataIndex = 
% 
%          metaData: [1x2 struct]
%     operationList: {2x1 cell}
%
%   Counts, 2016 VCSFA


    dataIndex = struct;

    blankMetaData = newMetaDataStructure;
    
    dataIndex.operationList = {};
    dataIndex.metaData(1) = blankMetaData;

end

