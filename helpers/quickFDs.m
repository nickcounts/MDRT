%% Script to create Data Review compatible FDs from Orbital Sciences Corporation PECS
%
%  Data were pasted into named variables as 2 column (Max,Min)
%  Time values were converted to excel then pasted to matlab and converted
%  using x2mdate()
%
%  shortname,longname were chosen to provide identifiable plot names... not
%  the best way to go, but expedient.
%
%  
%



fd = makeTS(mean(CFM,2),time,'Airflow','PECS Airflow Output')
save('~/Documents/MATLAB/Data Review/ORB-2/data/PECS-CFM.mat','fd')

fd = makeTS(mean(DUCT,2),time,'DUCT','PECS Outlet Temperature')
save('~/Documents/MATLAB/Data Review/ORB-2/data/PECS-DUCT.mat','fd')

fd = makeTS(mean(EAT,2),time,'EAT','PECS Entering Air Temperature')
save('~/Documents/MATLAB/Data Review/ORB-2/data/PECS-EAT.mat','fd')

fd = makeTS(mean(LAT,2),time,'LAT','PECS Coil Temperature')
save('~/Documents/MATLAB/Data Review/ORB-2/data/PECS-LAT.mat','fd')

fd = makeTS(mean(RH,2),time,'RH','PECS Humidity Output')
save('~/Documents/MATLAB/Data Review/ORB-2/data/PECS-RH.mat','fd')