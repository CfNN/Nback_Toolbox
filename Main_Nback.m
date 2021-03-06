% Author: Morgan Talbot, morgan_talbot@alumni.brown.edu
% To run an experiment session, enter "Main_Nback" into the MATLAB console, 
% or press the "Run" betton in the menu above under the "EDITOR" tab. 


% Giant try-catch block enables PsychToolbox to exit gracefully in the
% event of an error (rather than freezing and possibly requiring reboot)
try
    % Clear the workspace and the screen, close all plot windows
    close all;
    clear;
    sca;

    % Shuffle random number generator (necessary to avoid getting the same
    % "random" numbers each time
    rng('shuffle');

    % Set the current MATLAB folder to the folder where this script is stored
    disp('Setting the current MATLAB folder to the location of this script');
    cd(fileparts(which(mfilename)));

    % Make sure the code files in /code_backend and other directories are accessible to MATLAB
    disp('Adding code directories to MATLAB search path');
    addpath('./code_backend/');
    addpath('./data_analysis/');
    addpath('./software_tests/');

    try
        % Contains the pre-generated "trials" struct array
        load('CURRENTTRIALS.mat', 'trials', 'blockOutline', 'stimulusList', 'zeroBackYesStimuli');
    catch
        error('CURRENTTRIALS.mat not found. Generate a trial sequence by running GenRandomTrials.m or GenRandomTrialsSimple.m. Type ''help GenRandomTrials'' or ''help GenRandomTrialsSimple'' in the MATLAB console for information on how to use these functions.');
    end

    % Set user-defined variables to configure experiment. creates a workspace
    % struct variable called 'settings'. Settings variables should NEVER change
    % during the experiment session. 
    ExperimentSettings;
    % Clean up the settings variables (removing any unused variables)
    ExperimentSettingsCleanup;

    % Set up running values that change during the experiment session
    % (e.g. live performance metrics) 
    InitRunningVals;

    % Use dialog boxes to get subject number, session number, etc. from the experimenter
    [subjectNumber, sessionNumber, subjectHandedness, cancelled] = GetSessionConfig(settings);
    if (cancelled)
        disp('Session cancelled by experimenter');
        return % Ends the session
    end
    clear cancelled;

    % Initialize the user interface (ui) and PsychToolbox
    ui = UserInterface();

    % Use the ui to show experiment instructions
    quitKeyPressed = ui.ShowInstructions(settings);
    if quitKeyPressed
        cleanup();
        return  % Ends the session
    end

    % Use the ui to show the "ready" screen with a timer, and wait for the MRI
    % trigger (or a key press, depending on what is specified in
    % ExperimentSettings.m)
    % IMPORTANT: sessionStartDateTime is not exactly the same as
    % triggerTimestamp, there is be a (tiny) time difference between when
    % the two are recorded! For this reason, always use triggerTimestamp for 
    % important calculations if possible. 
    [triggerTimestamp, sessionStartDateTime, quitKeyPressed] = ui.ShowReadyTrigger(settings);
    if quitKeyPressed
        cleanup();
        return  % Ends the session
    end

    % Use the ui to show a fixation cross for the specified amount of time in
    % seconds
    [sessionStartFixationOnsetTimestamp, sessionStartFixationOffsetTimestamp, quitKeyPressed] = ui.ShowFixation(settings.SessionStartFixationDur, settings, runningVals);
    if quitKeyPressed
        cleanup();
        return  % Ends the session
    end

    % Loop through the trials structure (note - runningVals.currentTrial keeps
    % track of which trial you are on)
    while (runningVals.currentTrial <= length(trials))

        % Show a rest/instruction message at the beginning of each block
        if runningVals.currentTrial == 1 || trials(runningVals.currentTrial).BlockNumber > trials(runningVals.currentTrial - 1).BlockNumber

            if trials(runningVals.currentTrial).Nback == 0
                msg = ['Press ''' settings.YesKeyNames{1} ''' if the letter is ' commaSepList(zeroBackYesStimuli, 'or', true) '\n\nPress ''' settings.NoKeyNames{1} ''' for any other letter'];
            elseif trials(runningVals.currentTrial).Nback > 0
                msg = ['Press ''' settings.YesKeyNames{1} ''' if the letter matches the one seen ' num2str(trials(runningVals.currentTrial).Nback) ' trials ago\n\nPress ''' settings.NoKeyNames{1} ''' if it does not match'];
            end

            [~, ~, quitKeyPressed] = ui.RestBreak(msg, 28, settings.RestDur, settings, runningVals);
            if quitKeyPressed
                cleanup();
                return  % Ends the session
            end
        end

        % Run the next trial (stimulus display) according to what is specified 
        % in the "trials" variable
        [trials, runningVals, quitKeyPressed] = ui.RunNextTrial(trials, settings, runningVals);
        if quitKeyPressed
            cleanup();
            return % Ends the session
        end

        % Autosave data in case the experiment is interrupted partway through
        save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness', 'triggerTimestamp', 'sessionStartDateTime', 'sessionStartFixationOnsetTimestamp', 'sessionStartFixationOffsetTimestamp', 'blockOutline', 'stimulusList', 'zeroBackYesStimuli');

        % Update the live performance metrics that are optionally displayed on
        % the screen (see ExperimentSettings.m to disable/enable)
        runningVals = UpdateLivePerfMetrics(runningVals, trials);

        % Advance iterator to next trial
        runningVals.currentTrial = runningVals.currentTrial + 1;
    end

    % Use the ui to show a fixation cross for the specified amount of time in
    % seconds
    [sessionEndFixationOnsetTimestamp, sessionEndFixationOffsetTimestamp, quitKeyPressed] = ui.ShowFixation(settings.SessionEndFixationDur, settings, runningVals);
    if quitKeyPressed
        cleanup();
        return % Ends the session
    end
    
    cleanup();

    % Save the data to a .mat, delete autosaved version
    save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness', 'triggerTimestamp', 'sessionStartDateTime', 'sessionStartFixationOnsetTimestamp', 'sessionStartFixationOffsetTimestamp', 'sessionEndFixationOnsetTimestamp', 'sessionEndFixationOffsetTimestamp', 'blockOutline', 'stimulusList', 'zeroBackYesStimuli');
    delete(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat']);

catch e
    cleanup();
    rethrow(e);
end

function cleanup()
    % Clear the screen and unneeded variables
    sca;
    clear ui msg;
end
