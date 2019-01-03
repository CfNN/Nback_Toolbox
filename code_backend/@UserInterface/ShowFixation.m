function [onsetTimestamp, offsetTimestamp] = ShowFixation(obj, duration, runningVals)
% SHOWFIXATION shows a fixation cross for the specified duration.
%   Eg. ShowFixation(2.4, runningVals) displays a fixation cross for 2400 milliseconds. 

obj.DrawFixationCross();

obj.DrawPerformanceMetrics(runningVals);

[~, onsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

WaitSecs(duration);

[~, offsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

end