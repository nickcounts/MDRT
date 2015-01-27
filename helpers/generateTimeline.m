% generateTimeline
% 
% from cell array of the form
% FD, String, UTCTime


for i = 1:length(a)
    milestone(i).FD = a{i,1}
    milestone(i).String = a{i,2}
    milestone(i).Time = a{i,3} + floor(timeline.t0.time)
end