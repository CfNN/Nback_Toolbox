% INVESTIGATOR: Edit this file to customize the parameters of your
% experiment. Note that these values should not change during the entire
% experiment session. 

% Set the name of the experiment, which will be added to the name of saved
% data files:
settings.ExperimentName = 'Nback';

% Set whether an MRI trigger will be used to start the experiment session
% (otherwise a key press will be used)
settings.UseMRITrigger = false;
settings.MRITriggerManufacturer = 'Current Designs, Inc.';
settings.MRITriggerUsageName = 'Keyboard';

% Index of the keyboard/other device that the participant will use to make
% their responses. To see keyboard device indices, type GetKeyboardIndices()
% into the MATLAB command window and use the resulting value. For other
% device indices, type devices = PsychHID('devices'), and examine the
% "index" field in the "devices" struct that is created. To enable any
% device/keyboard to make a response, leave the field equal to []. 
settings.RespondDeviceIndex = [];

% Index of the keyboard/other device used to control the flow of the
% experiment (e.g. pressing "continue" on instructions screens, pressing
% the quit key to end the session early). Set by the same procedure as
% settings.RespondDeviceIndex above.
settings.ControlDeviceIndex = [];

% Determines which keyboard keys are used by the participant for "yes" or
% "no" responses. Entires can be single numbers/letters for number or
% letter keys. 'RightArrow', 'LeftArrow', 'UpArrow', 'DownArrow' also work.
% Note that if number keys are used, two entries might be necessary, one
% including the symbol that is conventionally placed on that same key on
% the keyboard. E.g. '1' is the numpad 1, '1!' is the number row 1. All key
% presses of keys in the same list will be recorded as the first entry in
% that list. 
settings.YesKeyNames = {'1', '1!'};
settings.NoKeyNames  = {'2', '2@'};

% Enter the names of the key(s) that you want to designate as "quit keys":
% When you press one of these, the session will immediately end (with data
% autosaved).
settings.QuitKeyNames = {'q', 'escape'};

% Set to "true" to display live performance metrics at the bottom of the 
% screen during the experiment session. To hide metrics, set to "false"
settings.DisplayPerfMetrics = true;

% Set what is displayed during the inter-trial interval (ITI). 
% Set to "blank" for a blank screen, "fixation" for a fixation cross. 
settings.ITIStim = "fixation";

% Stimulus duration
settings.StimDur = 0.5; % seconds

% Constant inter-trial interval (ITI) duration
settings.ITIDur = 2.0; % seconds

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

% Duration to display fixation cross before and after running the trials
% (e.g. to collect 'resting' data and avoid truncating HRF in MRI studies)
settings.SessionStartFixationDur = 4; % seconds
settings.SessionEndFixationDur = 4; % seconds

% Text size with which to display text stimuli on the screen (e.g. letters)
settings.StimulusTextSize = 100;