% This script sets the runningVals variables, which are used to keep track
% of the current trial number and live performance metrics optionally 
% displayed at the bottom of the screen (to disable/enable live performance 
% metrics, see ExperimentSettings). 

% Variable for keeping track of the trial number
runningVals.currentTrial = 1;

% Variables for keeping track of live performance metrics 
runningVals.AvgResponseAccuracy = -1; % Meaningless default value
runningVals.PreviousAnswer = -1; % Meaningless default value