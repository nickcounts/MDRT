reverseStr = '';

for i = 1:100

pause(0.1);
    
percentDone = 100 * i / 100;
msg = sprintf('Percent done: %3.1f', percentDone);
fprintf([reverseStr, msg]);
reverseStr = repmat(sprintf('\b'), 1, length(msg));

end