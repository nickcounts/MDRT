function [ flow ] = integrateTotalFlow( databrush, unit )
%integrateTotalFlow ( data, 'unit' )
%   integrates the output of data brush variables for a total flow rate.
%
%   Intended as helper function when looking at plotted data. 
%       1) Select data with data brush and export as a variable 
%          (i.e. databrush). 
%       
%       2) call integrateTotalFlow(databrush, 'gpm') to integrate the
%          selected data with units of gallons per minute.
%
%   Standard abbreviations for gallons per minute, hour and second are
%   implemented.
%
%   Counts, 10-11-13 - Spaceport Support Services

unit = lower(unit);
switch unit
    case {'gpm' 'min' 'minute' 'gal/m' 'gal/min' 'gallons per minute'}
        % set timestep as one minute.
        deltat = 0.000694444;
    case {'gph' 'hr' 'hour' 'gal/h' 'gal/hr' 'gallons per hour'}
        % set timestep as one hour.
        deltat = 0.041666667;
    case {'gps' 's' 'sec' 'second' 'gal/s' 'gal/sec' 'gal/second' 'gallons per second'}
        deltat = 0.000011574;
    otherwise
        % assume time step is one day
        deltat = 1;
end


flow = trapz(databrush(:,1),databrush(:,2)) / deltat;

end

