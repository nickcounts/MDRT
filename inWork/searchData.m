function [ indices ] = searchData(Data, searchParams )
% searchData
%
% resultsIndexes = searchData(searchParamStruct)
% 
%     pass a structure of search parameters
% 
%     searchParamStruct.useThreshold
%         value: < 0 for below, 0 for false, > 0 for above
%                     
%     searchParamStruct.thresholdValue
%         value: max or min allowable value
%         
%     searchParamStruct.useRateOfChange
%         value: boolean
%     
%     searchParamStruct.rateOfChange
%         value: rate of change between samples
% 

    

%% Search filters

    indices = [];

    if searchParams.useRateOfChange
        if searchParams.rateOfChange > 0
            % negative rate of change
            indices = find(diff(Data) > searchParams.rateOfChange);
        else
            % negative rate of change
            indices = find(diff(Data) < searchParams.rateOfChange);
        end
    end

    if searchParams.useThreshold
       if searchParams.useThreshold > 0
           % for values above a threshold
           indices = indices(Data(indices) > searchParams.threshold);

       else
           % for values below a threshold
           indices = indices(Data(indices) < searchParams.threshold);
       end

    end

