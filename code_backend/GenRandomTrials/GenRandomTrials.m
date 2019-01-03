function GenRandomTrials(blockOutline, stimulusList, zeroBackYesStimuli)
% GENRANDOMTRIALS - Generates pseudo-random blocks of trials.
% Trial/stimulus presentation order is random, but with certain enforced
% features as required by the N-Back task. 
%
% Usage: GenRandomTrials(blockOutline, stimulusList, zeroBackYesStimuli);
% Please see GenRandomTrials_example.m for example usage, including
% examples of blockOutline and stimulusList structures. 
% 
% blockOutline: Each row outlines one "run" of data collection that
% consists of one or more "blocks" of trials. In each row, the first entry
% (a single integer) defines the number of cycles, i.e. the number of times
% the blocks in that run should be repeated in order. All subsequent
% entries in the row define blocks of trials (there can be any number of
% blocks, meaning rows can have any length). 
% Each block entry is an array of three integers. The first integer
% specifies the "N" in "Nback" - e.g. if this number is 2, a 2-back block
% will be created. The second integer specifies the total number of
% trials/stimulus presentations in that block. The third integer specifies
% how many of these trials should have "yes" as the correct answer - i.e.
% how many of the trials have another trial with the same stimulus N trials
% previously.
%
% stimulusList: A cell array of stimulus names where each distinct stimulus
% has its own row, and stimuli in the same row are aliases/variants of each
% other. That is, if 'a', 'A'; forms a row, then 'a' and 'A' are treated as
% equivalent to each other in the N-back task. In the GenRandomTrials
% function, a row is randomly chosen from this array for each stimulus
% presentation.
%
% zeroBackYesStimuli: A cell array of stimulus names, like stimulusList,
% with a single row. This defines the stimulus names for which the correct
% answer should be "yes" in a zero-back block.
% ----------------

% Add helper functions to path
addpath('./code_backend/GenRandomTrials');

% Seed random number generator. Otherwise, same 'random' sequence of
% numbers will be generated each time after opening MATLAB.
rng('shuffle');

% Determine the total number of trials and generate block numbers, Nback
% numbers, Stimulus names, answers (which are based on stimulus names,
% block numbers, and Nback numbers)
n_trials = 0;
blockNumbers = {};
nbackNumbers = {};
stimuli = {};
correctAnswers = {};
newBlockNumber = 1;
for run = 1:size(blockOutline, 1)
    for cycle = 1:blockOutline{run, 1}
        for block = 2:size(blockOutline(run, :), 2)
            % Gets array of 3 integers specifying block
            blockDef = blockOutline{run, block};

            newBlockNumbers = cell(blockDef(2), 1);
            newBlockNumbers(:, 1) = {newBlockNumber};
            newBlockNumber = newBlockNumber + 1;
            blockNumbers = vertcat(blockNumbers, newBlockNumbers); %#ok<AGROW>

            newNbackNumbers = cell(blockDef(2), 1);
            newNbackNumbers(:, 1) = {blockDef(1)};
            nbackNumbers = vertcat(nbackNumbers, newNbackNumbers); %#ok<AGROW>

            newStimuli = genRandomBlock(blockDef, stimulusList, zeroBackYesStimuli);
            stimuli = vertcat(stimuli, newStimuli); %#ok<AGROW>
            
            % Note - the getAnswers function internally checks that the
            % number of correct answers matches that defined in the
            % blockDef. 
            newCorrectAnswers = getAnswers(newStimuli, blockDef, stimulusList, zeroBackYesStimuli); 
            correctAnswers = vertcat(correctAnswers, newCorrectAnswers); %#ok<AGROW>

            n_trials = n_trials + blockDef(2);
        end
    end
end

trials(n_trials) = struct();

[trials.BlockNumber] = blockNumbers{:};
[trials.Nback] = nbackNumbers{:};
[trials.Stimulus] = stimuli{:};
[trials.CorrectAnswer] = correctAnswers{:};

% Generate CorrectAnswer as boolean, check to make sure that each block has
% exactly the right number of "yes" answers. Separate analysis for each
% block.
for t = 1:n_trials
    
end

% Initialize empty fields;
for t = 1:n_trials
    
    trials(t).Answer = false;
    trials(t).Correct = false; %Boolean indicating whether Answer matches CorrectAnswer
    
    % Initialize Timestamps to NaN
    trials(t).StimulusOnsetTimestamp = NaN;
    trials(t).StimulusOffsetTimestamp = NaN;
    trials(t).ITIOnsetTimestamp = NaN;
    trials(t).ResponseTimestamp = NaN;
    trials(t).ITIOffsetTimestamp = NaN;
end

assignin('base', 'trials', trials);
save('CURRENTTRIALS.mat', 'trials', 'blockOutline', 'stimulusList', 'zeroBackYesStimuli');
disp('Random ''trials'' struct saved as CURRENTTRIALS.mat');

end