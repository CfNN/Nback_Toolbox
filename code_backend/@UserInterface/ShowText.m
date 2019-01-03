function [onsetTimestamp, offsetTimestamp] = ShowText(obj, text, textSize, duration, runningVals)
% SHOWTEXT Displays a text message for the specified duration.
%   Eg. ShowText('Hello World', 48, 5, runningVals) displays "Hello World"
%   in size 48 font for 5 seconds, with performance metrics also shown.

obj.DrawText(text, textSize);

obj.DrawPerformanceMetrics(runningVals);

[~, onsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

WaitSecs(duration);

[~, offsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

end