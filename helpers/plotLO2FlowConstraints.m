function [ output_args ] = plotLO2FlowConstraints( input_args )
%plotLO2FlowConstraints loads and plots the constraint boundaries for
%vehicle oxidizer loading based on the LO2 Flow Control retrieval FDs.
%
%This is currently hard coded for ORB2
%

% TODO: Update to be use the configuration data and look automatically for
% the correct flow data.

% TODO: Pass a variable indicating the target figure/plot


hold on

load('/Users/nick/Documents/MATLAB/Data Review/ORB-2/data/LO2 Flow Control Max.mat');
stairs(fd.ts.Time, fd.ts.Data*1.05,'r--')


load('/Users/nick/Documents/MATLAB/Data Review/ORB-2/data/LO2 Flow Control Min.mat');
stairs(fd.ts.Time, fd.ts.Data*0.95,'r--')





end

