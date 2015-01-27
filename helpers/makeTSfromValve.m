tsCloseCommand = timeseries;
tsCloseCommand.Name = '5245 Close Command Sent';
tsCloseCommand.Time = time(chanIndexes(:,4));
tsCloseCommand.Data = str2double(valueCell(chanIndexes(:,4)));

tsState = timeseries;
tsState.Name = '5245 State';
tsState.Time = time(chanIndexes(:,9));
tsState.Data = str2double(valueCell(chanIndexes(:,9)));

tsIsClosed = timeseries;
tsIsClosed.Name = '5245 Closed Switch Active';
tsIsClosed.Time = time(chanIndexes(:,5));
tsIsClosed.Data = str2double(valueCell(chanIndexes(:,5)));

tsIsOpen = timeseries;
tsIsOpen.Name = '5245 Open Switch Active';
tsIsOpen.Time = time(chanIndexes(:,8));
tsIsOpen.Data = str2double(valueCell(chanIndexes(:,8)));