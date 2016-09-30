function [ output_args ] = importData( input_args )
%importData 
%   Launches the MDRT Import Data Tool

    myModel = Model_Data_Import_GUI;
    myController = Controller_Data_Import_GUI(myModel);


end

