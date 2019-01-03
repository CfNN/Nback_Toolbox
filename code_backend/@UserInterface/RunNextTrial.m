function [trials, runningVals, quitKeyPressed] = RunNextTrial(obj, trials, settings, runningVals)
% RUNNEXTTRIAL - Run the next trial in the session, based on the current
% trial number (runningVals.currentTrial) and the data in the 'trials'
% struct array. Returns updated copies of 'trials' and 'runningVals'. This
% function also takes care of all timestamping and data logging within each
% trial.
%
% Usage: [trials, runningVals] = RunNextTrial(trials, settings, runningVals);
% -------------------

% If the escape or q key is pressed, this will be set to true and passed as 
% such to the Main_Nback script, which will then end the experiment session. 
quitKeyPressed = false;

% Specify allowable key names, restrict input to these (if empty list "[]",
% all keys are allowed)
activeKeys = [];
RestrictKeysForKbCheck(activeKeys);

% Establish the full inter-trial interval (ITI) duration (may be fixed or
% variable, according to ExperimentSettings.m
if ~settings.VariableITIDur % If not variable ITI dur, just make it constant
    ITIDur = settings.ITIDur;
else
    ITIDur = settings.ITIDur + random(truncate(makedist('Exponential',settings.ITIDurMean),settings.ITIDurMin,settings.ITIDurMax));
end

obj.DrawText(trials(runningVals.currentTrial).Stimulus, settings.StimulusTextSize);
obj.DrawPerformanceMetrics(runningVals);
[~, tStimOn, ~, ~, ~]  = Screen('Flip',obj.window); % GetSecs called internally for timestamp
trials(runningVals.currentTrial).StimulusOnsetTimestamp = tStimOn;

timedout = false;
keyPressed = false;
stimEnded = false;
startedPolling = false;
while ~timedout
    
    % Check for keyboard presses while also getting a timestamp (timestamp
    % is recorded in keyTime regardless of whether a key was pressed)
    [ keyIsDown, keyTime, keyCode ] = KbCheck; % keyTime is from an internal call to GetSecs

    % Record response timestamp and response if key pressed (once polling
    % period begins)
    if (startedPolling && keyIsDown)
        if strcmpi(KbName(keyCode), 'q') || strcmpi(KbName(keyCode), 'escape')
            quitKeyPressed = true;
            return;
        end

        trials(runningVals.currentTrial).ResponseTimestamp = keyTime;
        trials(runningVals.currentTrial).Answer = true;
        keyPressed = true;
    end
    
    % Switch to inter-trial interval (ITI) after settings.StimDur elapses
    if (~stimEnded && (keyTime - tStimOn) > settings.StimDur)
        obj.DrawPerformanceMetrics(runningVals);
        if strcmpi(settings.ITIStim, "fixation")
            obj.DrawFixationCross();
        end
        [~, tStimOff, ~, ~, ~]  = Screen('Flip',obj.window); % GetSecs called internally for timestamp
        trials(runningVals.currentTrial).ITIOnsetTimestamp = tStimOff;
        trials(runningVals.currentTrial).StimulusOffsetTimestamp = tStimOff;
    end
    
    % Turn on answer polling after settings.AnswerPollDelay elapses
    if (~startedPolling && (keyTime - tStimOn) > settings.AnswerPollDelay)
        startedPolling = true;
    end
    
    % Time out after the settings.StimDur and ITIDur both elapse
    if ((keyTime - tStimOn) > settings.StimDur + ITIDur)
        if ~keyPressed
            trials(runningVals.currentTrial).Answer = 0;
        end
        [~, tITIEnd, ~, ~, ~]  = Screen('Flip',obj.window); % GetSecs called internally for timestamp
        trials(runningVals.currentTrial).ITIOffsetTimestamp = tITIEnd;
        timedout = true;
    end
    
end

% Check if answer is correct
if trials(runningVals.currentTrial).Answer == trials(runningVals.currentTrial).CorrectAnswer
    trials(runningVals.currentTrial).Correct = true;
else
    trials(runningVals.currentTrial).Correct = false;
end

% Re-enable all keys (restricted during trial)
RestrictKeysForKbCheck([]);

end
