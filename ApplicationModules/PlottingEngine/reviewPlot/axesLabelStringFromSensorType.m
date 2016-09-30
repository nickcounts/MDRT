function [ axesLabelString ] = axesLabelStringFromSensorType( typeArray )
%axesLabelStringFromSensorType ( typeArray )
%   [ axesLabelString ] = axesLabelStringFromSensorType( typeArray )
%
%
%

%Play nice with the users
typeArray = upper(typeArray);

ptFlag = false;
tcFlag = false;
fmFlag = false;
lsFlag = false;
vsFlag = false;
vpFlag = false;

unknownFlag = false;

firstLabel = true;

labels = [];
axesLabelString = '';

for i = 1:length(typeArray)
    switch typeArray{i}
        case 'PT'
            ptFlag = true;
        case 'TC'
            tcFlag = true;
        case 'FM'
            fmFlag = true;
        case 'LS'
            lsFlag = true;
        case {'DCVNC' 'DCVNO'}
            vsFlag = true;
        case {'PCVNC' 'PCVNO'}
            vpFlag = true;
        otherwise
            unknownFlag = true;
    end
end

    if (ptFlag);	labels = [labels {'Pressure'}];        end
    if (tcFlag);	labels = [labels {'Temperature'}];     end
    if (fmFlag);	labels = [labels {'Flow Rate'}];       end
    if (lsFlag);	labels = [labels {'Level'}];           end
    if (vsFlag);	labels = [labels {'Valve State'}];     end
    if (vpFlag);	labels = [labels {'Valve Position'}];     end
    
for i = 1:length(labels)
    if ((i - 1) && (i ~= length(labels)) && (length(labels) ~= 2))
        
        axesLabelString = [axesLabelString, ', '];
    
    elseif ((i - 1) && (i == length(labels)))
        
        axesLabelString = [axesLabelString, ' and '];
   
    end
 
    axesLabelString = [axesLabelString, labels{i}];

end
    
end

