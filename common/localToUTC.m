function dateVectorUtc = localToUTC( dateVectorLocal )
%
% localToUTC -- convert local time/date information to UTC.
%
% localToUTC = local_time_to_utc( dateVectorLocal ) returns the UTC time / date
%    values as a Matlab datenum. Inputting a vector returns a vector.
%
% Example:
%
%   datestr( localToUTC( today ) )
%
% NOTE: this function uses the host system's location information to
%    determine the local timezone. Future versions will allow calling this
%    function for a specified timezone.
%
% Version date:  2016-July-1.
%

% Modification History:
%
%    2008-November-12, PT:
%        switch to use of Java methods and eliminate check for unix vs PC (java methods
%        work on all platforms).
%    2008-November-10, PT:
%        added a bunch of disp statements which should help diagnose mysterious smoke test
%        failures in PMD and PA.
%    2016-July-1, Counts, VCSFA
%        Modified function to return a Matlab datenum instead of a
%        formatted string. Removed the string formatting sections.
%        Maintained the vectorization. Renamed function to localToUTC
%
%=========================================================================================

% arguments -- if the argument is a vector of datenums, convert to a vector of time/date
% vectors

  if ( size(dateVectorLocal,2) ~= 6 || max(dateVectorLocal(:,2)) > 12 )
      dateVectorLocal = datevec(dateVectorLocal) ;
  end
  
% % % % % % check that the format number is supported
% % % % % 
% % % % %   if ( nargin == 1)
% % % % %       format = 0 ;
% % % % %   end
% % % % %   supportedFormats = [0 13 15 21 30 31] ;
% % % % %   if ~ismember(format,supportedFormats)
% % % % %       error('common:localTimeToUtc:unsupportedFormat' , ...
% % % % %           'local_time_to_utc:  unsupported format requested' ) ;
% % % % %   end
  
% call the converter vector

  dateVectorUtc = local_date_vector_to_utc( dateVectorLocal ) ;
  
% % % % % % convert the date vectors to the desired format
% % % % % 
% % % % % %   dateStringUtc = datestr(dateVectorUtc,format) ;
% % % % % %   stringLength = size(dateStringUtc,2) ;
% % % % % %   nStrings = size(dateStringUtc,1) ;
% % % % %   
% % % % % % append the 'Z' 
% % % % % 
% % % % % %   dateStringUtc = append_z_to_date_string( dateStringUtc, format ) ;
  
return  
  
% and that's it!

%
%
%

%=========================================================================================

% subfunction which converts a Matlab date vector in local time to one in UTC

function dateVectorUtc = local_date_vector_to_utc( dateVectorLocal )
      
  nDates = size(dateVectorLocal,1) ;
  dateVectorUtc = zeros(nDates,1) ;
  
% import the Java classes needed for this process

  import java.text.SimpleDateFormat ;
  import java.util.Date ;
  import java.util.TimeZone ;
  
% instantiate a SimpleDateFormat object with a fixed time/date format and UTC time zone

  utcFormatObject = SimpleDateFormat('yyyy-MM-dd HH:mm:ss') ;
  utcFormatObject.setTimeZone(TimeZone.getTimeZone('UTC')) ;
      
% loop over date strings

  for iDate = 1:nDates

      dateVec = dateVectorLocal(iDate,:) ;
      
%     instantiate a Java Date class object with the local time.  Note that Java year is
%     year since 1900, and Java month is zero-based
      
      localDateObject = Date(dateVec(1)-1900, dateVec(2)-1, dateVec(3), ...
                             dateVec(4), dateVec(5), dateVec(6)) ;                        
                         
%     convert the date object to a string in the correct format and in UTC

      dateStringUtc = char(utcFormatObject.format(localDateObject)) ;
         
%     pick through the resulting string and extract the data we want, converting to
%     numbers as we go

      tempVectorUtc(iDate,1) = str2num(dateStringUtc(1:4)) ;
      tempVectorUtc(iDate,2) = str2num(dateStringUtc(6:7)) ;
      tempVectorUtc(iDate,3) = str2num(dateStringUtc(9:10)) ;
      tempVectorUtc(iDate,4) = str2num(dateStringUtc(12:13)) ;
      tempVectorUtc(iDate,5) = str2num(dateStringUtc(15:16)) ;
      tempVectorUtc(iDate,6) = str2num(dateStringUtc(18:19)) ;
      
      dateVectorUtc(iDate,1) = datenum(tempVectorUtc(iDate,:));
          
  end % loop over dates
      
return

%% Old Function that handled formatting text output. Not needed for numerical output 
% =========================================================================================

% % % % % % append a 'Z', signifying UTC, to a Matlab date string.
% % % % % 
% % % % % function datestrZ = append_z_to_date_string( datestr, format )
% % % % % 
% % % % %   nStrings = size(datestr,1) ;
% % % % %   stringLength = size(datestr,2) ;
% % % % %   if (format ~= 30)
% % % % %       addString = repmat(' Z',nStrings,1) ;
% % % % %       stringSizeIncrease = 2 ;
% % % % %   else
% % % % %       addString = repmat('Z',nStrings,1) ;
% % % % %       stringSizeIncrease = 1 ;
% % % % %   end
% % % % %   datestrZ = [datestr(:) ; addString(:)] ;
% % % % %   datestrZ = reshape(datestrZ,nStrings,stringLength+stringSizeIncrease) ;
% % % % % 
% % % % % return