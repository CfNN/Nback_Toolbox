function runningVals = UpdateLivePerfMetrics(runningVals, trials)
% UPDATELIVEPERFMETRICS - Updates variables needed to display live 
% performance metrics. 
%
% Usage: runningVals = UpdateLivePerfMetrics(runningVals)
% -------------

% Get previous answer
runningVals.PreviousResponse = trials(runningVals.currentTrial).ResponseKeyName;

% Calculate average response accuracy (proportion of correct answers)
prevTrials = trials(1:runningVals.currentTrial);
runningVals.AvgResponseAccuracy = round( nnz([prevTrials.Correct])/numel(prevTrials) * 100);

% Get previous reaction time
runningVals.PreviousRT = round(1000*trials(runningVals.currentTrial).ReactionTime);

end