function [FDList] = statenSearchFunction( time )
%Dummy function to input a time array of 1 or 2 datenums and output an
%array of structures containing FDs
timeRange = time(2) - time(1);


if timeRange > 7
display('Oooooh weeee! You searched for MORE than a week! Good 4 u')
FDList = { 'Paige' 'Orange';...
           'Staten' 'Dog';...
           'Ryan' 'Kite'};
else
    display('Oooooh weeee! You searched for LESS than a week! Good 4 u')
    FDList = { 'Pruce' 'Orange';...
               'Longo' 'Dog';...
               'McGuire' 'Kite'};
end
      

% data = {'Apple';'Bob';'Cat'};
% celldata = cellstr(data)

end

