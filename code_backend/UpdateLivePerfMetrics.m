function runningVals = UpdateLivePerfMetrics(runningVals, trials)
% UPDATELIVEPERFMETRICS - Updates variables needed to display live 
% performance metrics. 
%
% Usage: runningVals = UpdateLivePerfMetrics(runningVals)
% -------------

% Get previous answer
runningVals.PreviousAnswer = trials(runningVals.currentTrial).Answer;

% Calculate average response accuracy (proportion of correct answers)
prevTrials = trials(1:runningVals.currentTrial);
runningVals.AvgResponseAccuracy = round( nnz([prevTrials.Correct])/numel(prevTrials) * 100);

end