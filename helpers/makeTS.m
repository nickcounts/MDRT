function [ fd ] = makeTS( data, time, shortname, longname )
%makeTS generate an fd structure from passed values.
%   Useful for making structures for PECS data from pasted excel data
%   fd.Stystem is defaulted to 'PECS'
%   fd.Type is defaulted to 'Temperature'
%
%   Produces console output showing the generated fd structure

fd.FullString = longname;
fd.Type = 'Temperature';
fd.ID = shortname;
fd.System = 'PECS';

fd.isValve = false;

ts = timeseries(data,time,'Name',longname)

fd.ts = ts;

end



