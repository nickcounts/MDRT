function selectStartDate
%Use Calendar GUI to select a start date. Output a datenum for the selected
%start date.

startDate =  guiDatePicker('1-Jan-2016');

% Display selected date in edit text box
startDateString = datestr(startDate)

% edit1_Callback(hObject, eventdata, handles)


end

