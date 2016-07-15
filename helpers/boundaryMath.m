function [ output_args ] = boundaryMath( bounds, fd )
%boundaryMath is a helper function to verify that controlled parameters are
%within defined boundaries. 
%   Supplying bounds as a row vector [low high] and the fd vector,
%   boundaryMath will calculate the mean value, check for boundary
%   crossings, calculate the standard deviation and report how many std
%   devs between the mean value and the boundaries.
%

sd = std(fd);
av = mean(fd);

disp(sprintf('\n'));

disp(sprintf('Mean value:\tStnd dev\tSigma to lower:\tSigma to upper'))
disp(sprintf('%f\t%f\t%f\t%f',av,sd,(av-min(bounds))/sd,(max(bounds)-av)/sd))

if (max(fd) > max(bounds))
    disp(sprintf('Upper boundary violated: Max value %f\n%f over upper boundary %f', ...
                    max(fd), max(fd)-max(bounds), max(bounds) ));
elseif (min(fd) < min(bounds))
    disp(sprintf('Lower boundary violated: Min value %f\n%f below lower boundary %f', ...
                    min(fd), min(bounds)-min(fd), min(bounds) ));
end

disp(sprintf('\n'));

end

