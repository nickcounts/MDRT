function [ projectStructure ] = newProjectStructure( input_args )
%newProjectStructure returns a projectStructure structure populated with 
%blanks.
% 
%   projectString     fullfile path
%   projectRootDir    fullfile path
%   projectDataDir    fullfile path
%   projectDelimDir   fullfile path
%   projectPlotDir    fullfile path
%   projectTimeSpan   [start stop]
%


projectStructure = struct(  'projectString',    '', ...
                            'projectRootDir',   '', ...
                            'projectDataDir',   '', ...
                            'projectDelimDir',  '', ...
                            'projectPlotDir',   '', ...
                            'projectTimeSpan',  '');

end
