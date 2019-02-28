function [onsetTimestamp, offsetTimestamp, quitKeyPressed] = ShowBlank(obj, duration, settings, runningVals)
% SHOWBLANK shows a blank screen for the specified duration.
%   eg. ShowBlank(2.4, runningVals) displays a blank screen for 2.4 seconds 

obj.DrawPerformanceMetrics(settings, runningVals);
[~, onsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

quitKeyPressed = obj.WaitAndCheckQuit(duration, settings);

% Quit if quit key pressed
if quitKeyPressed
    offsetTimestamp = NaN;
    return;
end

[~, offsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

end