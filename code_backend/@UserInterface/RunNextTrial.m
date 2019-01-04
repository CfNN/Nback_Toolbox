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
% all keys are allowed). Uncomment the following line (and comment the next
% one) to restrict all keys except those of interest. This is not normally
% preferred, because participants may press the wrong buttons at times
% without the experimenter knowing,  and it is often best to log the data
% anyway and sort it out later.
% activeKeys = [KbName(settings.YesKeyIDs) KbName(settings.NoKeyIDs) KbName('Escape') KbName('q')];
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
while ~timedout
    
    % Check for keyboard presses while also getting a timestamp (timestamp
    % is recorded in keyTime regardless of whether a key was pressed)
    [ keyIsDown, keyTime, keyCode ] = KbCheck; % keyTime is from an internal call to GetSecs

    % Record response and response timestamp if key pressed
    if (keyIsDown)
        if strcmpi(KbName(keyCode), 'q') || strcmpi(KbName(keyCode), 'escape')
            quitKeyPressed = true;
            return;
        end

        trials(runningVals.currentTrial).ResponseTimestamp = keyTime;
        % Note: ReactionTime is exactly the same as ResponseTimestamp
        % minus StimulusOnsetTimestamp
        trials(runningVals.currentTrial).ReactionTime = keyTime - tStimOn;
        trials(runningVals.currentTrial).Response = KbName(keyCode);
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
    
    % Time out after the settings.StimDur and ITIDur both elapse
    if ((keyTime - tStimOn) > settings.StimDur + ITIDur)
        [~, tITIEnd, ~, ~, ~]  = Screen('Flip',obj.window); % GetSecs called internally for timestamp
        trials(runningVals.currentTrial).ITIOffsetTimestamp = tITIEnd;
        timedout = true;
    end
    
end

% Check if response is correct
if trials(runningVals.currentTrial).YesTrial == true
    correctKeys = settings.YesKeyIDs;
else
    correctKeys = settings.NoKeyIDs;
end

correct = false;
for i = 1:numel(correctKeys)
    if strcmpi(correctKeys{i}, trials(runningVals.currentTrial).Response)
        correct = true;
        break;
    end
end
trials(runningVals.currentTrial).Correct = correct;

% Re-enable all keys (restricted during trial)
RestrictKeysForKbCheck([]);

end
