% INVESTIGATOR: Edit this file to customize the parameters of your
% experiment. Note that these values should not change during the entire
% experiment session. 

% Set the name of the experiment, which will be added to the name of saved
% data files:
settings.ExperimentName = 'Nback';

% Literally puts the "N" in "Nback". Determines how many trials back a
% participant must remember stimuli to determine if they match the
% subsequent stimuli. This is overridden in 0-back blocks. 
settings.N = 2;

% Set whether an MRI trigger will be used to start the experiment session
% (otherwise a key press will be used)
settings.UseMRITrigger = false;

% Set to "true" to display live performance metrics at the bottom of the 
% screen during the experiment session. To hide metrics, set to "false"
settings.DisplayPerfMetrics = true;

% Stimulus duration
settings.StimDur = 0.5; % seconds

% Set what is displayed during the inter-trial interval (ITI). 
% Set to "blank" for a blank screen, "fixation" for a fixation cross. 
settings.ITIStim = "fixation";

% Constant inter-trial interval (ITI) duration
settings.ITIDur = 2.5; % seconds

% % Set to "true" to use a variable inter-trial interval duration, chosen for each
% % trial from a truncated exponential distribution. 
% IMPORTANT: unlike some other tasks implemented in this framework, this
% ITI is IN ADDITION to the constant ITIDur set above. In other words, the
% constant ITIDur will first elapse, followed by the additional, variable
% duration. Note that you can set ITIDur to zero if desired. Set
% VariableITIDur to "true" to add a variable duration to the constant ITI
% duration set above as settings.ITIDur
settings.VariableITIDur = false;
% Parameters for a truncated exponential distribution from which to choose
% the additional, variable ITI duration.
% NOT APPLICABLE if settings.VariableITIDur is set to false
settings.ITIDurMean = 1; % seconds
settings.ITIDurMin = 0.4; % seconds
settings.ITIDurMax = 3.9; % seconds

% Timeout duration of rests between blocks
settings.RestDur = 30; % seconds

% Set to "true" if you want the participant (or experimenter) to be able to
% press a key to end the rest break before the timeout period. "false" if
% you want the participant to wait until settings.RestDur (above) has
% elapsed. 
settings.CanSkipBreak = true;

% Delay after the beginning of the stimulus before polling for an answer
% begins. If, for example, settings.StimDur = 0.5 and
% settings.AnswerPollDelay = 0.7, the participant can press a key
% indicating their answer starting 0.2 seconds after the stimulus ends. 
settings.AnswerPollDelay = 0.7; % seconds

% Duration to display fixation cross before and after running the trials
% (e.g. to collect 'resting' data and avoid truncating HRF in MRI studies)
settings.SessionStartFixationDur = 4; % seconds
settings.SessionEndFixationDur = 4; % seconds

% Text size with which to display text stimuli on the screen (e.g. letters)
settings.StimulusTextSize = 100;