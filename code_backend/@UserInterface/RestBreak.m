function [onsetTimestamp, offsetTimestamp] = RestBreak(obj, text, textSize, duration, settings, runningVals)
% RESTBREAK Displays a text message on the screen during a break, which can
% either time out or be ended by a key press depending on specifications in
% ExperimentSettings.m. Also displays a timer that counts down until the
% break times out. Performance metrics are also shown.
%
%   Eg. RestBreak('Please rest', 48, 30, settings, runningVals) displays
%   "Please rest" in size 48 font until a key is pressed or 30 seconds
%   elapses.

Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 0); % 1 makes it bold;

prevTimer = duration;

tStart = GetSecs;

% Enable any key to end the rest break
activeKeys = [];
RestrictKeysForKbCheck(activeKeys);

initialOnset = true;
timedout = false;
    while ~timedout
        
        [ keyIsDown, keyTime, ~ ] = KbCheck(activeKeys); 
        if (keyIsDown && settings.CanSkipBreak)
            break;
        end
        
        timer = duration - round(keyTime - tStart);
        
        if timer ~= prevTimer
            Screen('TextSize', obj.window, textSize);
            DrawFormattedText(obj.window, [text '\n\nRest time remaining:' num2str(timer)], 'center', 'center', obj.c_white);
            obj.DrawPerformanceMetrics(runningVals);
            if initialOnset
                [~, onsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
                initialOnset = false;
            else
                Screen('Flip', obj.window); % Flip to the updated screen
            end
        end
        
        if timer == 0
            break
        end
        
        prevTimer = timer;
    end

[~, offsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

end