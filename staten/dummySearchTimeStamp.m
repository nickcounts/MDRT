% datenum1 = datenum('05-01-2016')
% datenum2 = datenum('06-30-2016')
% hotfire = datenum('05-31-2016');

ORB1 = 735608.1;
ORB31 = 735900.4;
ORB32 = 735900.6;
WDR = 736472;
hotfire = 736481;
 
thing = searchTimeStamp([hotfire]);
foundDataToSearch = newSearchTimeStamp([ORB1 hotfire]);
foundFDList = foundDataToSearch.fdList;

% metadataoutput = searchMetaDataFlag( 'isMARSprocedure', false );

% foundFDList = {'wds'; 'RP/1'; 'rp-1'; 'rp/1'; 'Rp*1'};
thing2 = searchfdListByCommodity( foundFDList, 'RP1' )

% mainthing = searchFunctionMain([ORB1 hotfire], 'isMARSprocedure', false)


% ======================================================================
% test metadata flag search:

searchQuery = struct;
searchQuery.isOperation = true;
searchQuery.isVehicleOp = true;
searchQuery.isMARSprocedure = false;
searchQuery.hasMARSuid = false;

% functions that will help you
fieldnames(searchQuery);
isempty(fieldnames(struct));

% return the list of field names as a cell array of strings
metaDataFlagFieldsToFilterBy = fieldnames(searchQuery);

diditwork = searchMetaDataFlag(searchQuery);
