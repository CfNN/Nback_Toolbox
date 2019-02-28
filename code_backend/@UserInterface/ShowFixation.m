function [onsetTimestamp, offsetTimestamp, quitKeyPressed] = ShowFixation(obj, duration, settings, runningVals)
% SHOWFIXATION shows a fixation cross for the specified duration.
%   Eg. ShowFixation(2.4, runningVals) displays a fixation cross for 2400 milliseconds. 

obj.DrawFixationCross();

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