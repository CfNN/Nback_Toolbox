function [onsetTimestamp, offsetTimestamp] = ShowTextWait(obj, text, textSize, runningVals)
% SHOWTEXT Displays a text message until a key is pressed.
%   Eg. ShowText('Hello World', 48, runningVals) displays "Hello World" in
%   size 48 font until a key is pressed, with performance metrics also
%   shown.

obj.DrawText(text, textSize);

obj.DrawPerformanceMetrics(settings, runningVals);

[~, onsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

KbStrokeWait; % Wait for key press

[~, offsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

end