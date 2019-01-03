classdef UserInterface < handle
% USERINTERFACE - Wrapper class that contains PsychToolbox functions for
% displaying graphics. This includes code for running trials, showing 
% fixation and blank screens, and showing instructions/'ready' screens 
% during the experiment session. The superscript 'Main_Nback.m' works 
% primarily by calling functions in this class.
    
    properties (GetAccess=private)
        % Settings (initialized once by main script, never change during
        % experiment)
        settings;
        
        % Screen properties
        window;
        windowRect;
        screenXpixels;
        screenYpixels;
        xCenter;
        yCenter;
        
    end
    
    properties(Constant)
        %---COLOR DEFINITIONS---%
        c_black = [0 0 0]; % formerly BlackIndex(screenNumber);
        c_white = [1 1 1]; % formerly WhiteIndex(screenNumber);
        c_yellow = [1 1 0];
    end
    
    methods
        function obj = UserInterface(settings_init)
            
            obj.settings = settings_init;
            
            % Call some default settings for setting up Psychtoolbox
            PsychDefaultSetup(2);
            
            % Skip sync checks if running on Mac. Running on a Mac may 
            % cause stimulus timing errors of up to a few milliseconds.
            if contains(upper(computer), 'MAC')
                Screen('Preference', 'SkipSyncTests', 1);
            end
            
            %---KEYBOARD SETUP---%
            
            % Needed for the experiment to run on different operating systems with
            % different key code systems
            KbName('UnifyKeyNames');
            
            % Enable all keyboard keys for key presses
            RestrictKeysForKbCheck([]);

            %---SCREEN SETUP---%

            % Get the screen numbers
            screens = Screen('Screens');

            % Select the external screen if it is present, else revert to the native
            % screen
            screenNumber = max(screens);

            % Open an on screen window and color it grey
            [obj.window, obj.windowRect] = PsychImaging('OpenWindow', screenNumber, obj.c_black);

            % Set the blend function for the screen
            Screen('BlendFunction', obj.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

            % Get the size of the on screen window in pixels
            % For help see: Screen WindowSize?
            [obj.screenXpixels, obj.screenYpixels] = Screen('WindowSize', obj.window);

            % Get the centre coordinate of the window in pixels
            % For help see: help RectCenter
            [obj.xCenter, obj.yCenter] = RectCenter(obj.windowRect);
            
        end
        
        ShowInstructions(obj);
        
        [triggerTimestamp, sessionStartDateTime] = ShowReadyTrigger(obj);
        
        [onsetTimestamp, offsetTimestamp] = ShowFixation(obj, duration, runningVals);
        
        [onsetTimestamp, offsetTimestamp] = ShowBlank(obj, duration, runningVals);
        
        [onsetTimestamp, offsetTimestamp] = ShowText(obj, text, textSize, duration, runningVals);
        
        [onsetTimestamp, offsetTimestamp] = ShowTextWait(obj, text, textSize, runningVals);
        
        [onsetTimestamp, offsetTimestamp] = RestBreak(obj, text, textSize, duration, settings, runningVals);
        
        [trials, runningVals, quitKeyPressed] = RunNextTrial(obj, trials, settings, runningVals);
        
    end
    
    methods (Access = private)
        DrawPerformanceMetrics(obj, runningVals);
        DrawFixation(obj);
        DrawText(obj, text, textSize);
    end
end