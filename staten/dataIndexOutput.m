dataIndex = 

1x5 struct array with fields:

    timeSpan
    isUTC
    isOperation
    operationName
    isVehicleOp
    isMARSprocedure
    MARSprocedureName
    hasMARSuid
    fdList

>> dataIndex(1)

ans = 

             timeSpan: [7.3561e+05 7.3561e+05]
                isUTC: 1
          isOperation: 1
        operationName: 'ORB-1'
          isVehicleOp: 1
      isMARSprocedure: 0
    MARSprocedureName: ''
           hasMARSuid: 0
               fdList: {202x2 cell}

>> dataIndex(1).fdList(1,:)

ans = 

    'RP1 PCVNC-1014 State'    '1014.mat’


