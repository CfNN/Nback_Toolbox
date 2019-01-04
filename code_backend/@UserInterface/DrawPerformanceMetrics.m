function DrawPerformanceMetrics(obj, runningVals)
% Draws performance metrics at the bottom of the the screen, without 
% flipping the screen yet (flipping must be done AFTER calling this 
% function). 
%
% TO DISABLE PERFORMANCE METRICS: Edit ExperimentSettings.m, set 
% settings.DisplayPerfMetrics = false;
% 
% Usage: obj.DrawPerformanceMetrics(runningVals);

if obj.settings.DisplayPerfMetrics == true
    
    perfMetrics = [
        'Previous response: ' num2str(runningVals.PreviousResponse) '      Previous reaction time: ' num2str(runningVals.PreviousRT) ' ms\n\nAverage response accuracy: ' num2str(runningVals.AvgResponseAccuracy) '%'
        ];
    
    Screen('TextSize', obj.window, 18);
    Screen('TextFont', obj.window, 'Courier New');
    Screen('TextSTyle', obj.window, 0); % 0 is regular (not bold, italicized, etc)
    % Change the value in "obj.screenYpixels - 50" to modify the vertical
    % position of the performance metrics.
    DrawFormattedText(obj.window, perfMetrics, 'center', obj.screenYpixels - 50, obj.c_white);
end

end