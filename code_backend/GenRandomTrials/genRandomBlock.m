function [stimuli, yesNo] = genRandomBlock(blockDef, stimulusList, zeroBackYesStimuli)
% GENRANDOMBLOCK: A helper function to GenRandomTrials.m, which generates a
% random list of stimulus names. 
%
% Usage: stimuli = genRandomBlock(blockParams, stimulusList, zeroBackYesStimuli)
%
% blockDef: an array of three integers. The first integer specifies the
% "N" in "Nback" - e.g. if this number is 2, a 2-back block will be
% created. The second integer specifies the total number of trials/stimulus
% presentations in that block. The third integer specifies how many of
% these trials should have "yes" as the correct answer - i.e. how many of
% the trials have another trial with the same stimulus N trials previously.
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
%
% stimuli: a cell array of strings with a single column - specifies a
% sequence of stimulus names to be presented during an experiment block.
%
% yesNo: a matrix of booleans with one column, where each value of '1' or
% 'true' represents a "yes" trial and each value of '0' or 'false'
% represents a "no" trial. 
%
% See also: GENRANDOMTRIALS


nBack = round(blockDef(1));
nTrials = round(blockDef(2));
nYesTrials = round(blockDef(3));

% Make sure the inputs are reasonable
assert(nBack < nTrials, [num2str(nTrials) " trials per block is not enough trials per block for a " num2str(nBack) "-back experiment"]);
assert(nYesTrials <= nTrials-nBack, [num2str(nYesTrials) " 'yes' trials is too many to fit in a " num2str(nBack) "-back block with only " num2str(nTrials) " total trials"]);

% Warn the user if the proportion of yes trials exceeds 50%
if nBack > 0 && nYesTrials/nTrials > 0.5
    warning('A proportion of "yes" trials in a single block greater than 50% can cause the trial generation algorithm to "get stuck" in an infinite loop, because the possible stimulus orders are too constrained. If the algorithm does not finish within a few seconds, cancel it with "control-c" and try again if necessary');
end

% Start with all trials as "no" trials (false)
yesNo = false(blockDef(2), 1);

% First trial that could possibly be a "yes" trial based on the nBack
% number (e.g. for 2-back, the third trial is the first time there was a
% stimulus two trials ago for the participant to keep track of)
firstPossibleYesLoc = nBack+1;

% Choose a random selection of trials to turn into "yes" trials
yesInds = randsample(firstPossibleYesLoc:nTrials, blockDef(3));
yesNo(yesInds) = true;

% Choose appropriate stimuli such that each prescribed "yes" trial is
% turned into a yes trial, while making sure not to inadvertently create
% extra yes trials.
if nBack == 0
    stimuli = cell(nTrials, 1);
    for i = 1:numel(yesInds)
        [stim, ~] = getRandomStimPair(zeroBackYesStimuli);
        stimuli(yesInds(i)) = {stim};
    end
else
    
    start_over = true;
    iters = 0;
    
    while start_over
        iters = iters + 1;
        if iters >= 1000 && mod(iters,1000) == 0
            warning(['genRandomBlock algorithm is having difficulty finding a random block with the chosen random sample of "yes trial" indices: ' num2str(iters) ' attempts and counting! If the algorithm finishes, it''s fine, but probably best to inspect the trials to make sure they''re ok.']);
        end
        
        start_over = false;
        
        stimuli = cell(nTrials, 1);
    
        remainingYesInds = yesInds;
        
        % Shuffle - each time the algorithm starts over with these same yes
        % trial indices, it attempts to add the "yes" trials in a different
        % order
        remainingYesInds = remainingYesInds(randperm(numel(remainingYesInds)));

        while numel(remainingYesInds) > 0 && ~start_over

            firstInd = remainingYesInds(1) - nBack;
            secondInd = remainingYesInds(1);

            foundLetter = false;

            while (~foundLetter)
                
                %% Check for any conditions that predetermine the choice of stimulus (random stimulus otherwise)
                % First, check for the case where both indices are
                % already occupied (and not by aliases of each other). If
                % this occurs, start over with an empty stimulus list.
                if ~isempty(stimuli{firstInd}) && ~isempty(stimuli{secondInd}) && ~stimMatch(stimuli(firstInd), stimuli(secondInd), stimulusList)
                    start_over = true;
                    break;
                    
                % If there is already a stimulus at the first index, we must use aliases of that stimulus.
                elseif ~isempty(stimuli{firstInd})

                    % Find the row of stimulusList that matches the stimulus
                    % already at the first index
                    [stimulusListRow, ~] = find(strcmp(stimulusList, stimuli{firstInd}));

                    % Choose two random entries (aliases) from that row
                    [stim1, stim2] = getRandomStimPair(stimulusList(stimulusListRow, :));

                    predeterminedStimChoice = true;
                
                % If there is already a stimulus at the second index, we
                % must use aliases of that stimulus
                elseif ~isempty(stimuli{secondInd})
                    
                    % Find the row of stimulusList that matches the stimulus
                    % already at the first index
                    [stimulusListRow, ~] = find(strcmp(stimulusList, stimuli{secondInd}));

                    % Choose two random entries (aliases) from that row
                    [stim1, stim2] = getRandomStimPair(stimulusList(stimulusListRow, :));

                    predeterminedStimChoice = true;
                
                % Check for the case where both of the following are true: 
                % 1. There is already a stimulus N trials before the first 
                % index 
                % 2. The first index is itself designated as a "yes" trial 
                % If this occurs, we must use aliases of the stimulus N 
                % trials before the first index.
                elseif firstInd - nBack >= 1 && ~isempty(stimuli{firstInd - nBack}) && yesNo(firstInd) == true
                    
                    % Find the row of stimulusList that matches the stimulus
                    % already at the first index
                    [stimulusListRow, ~] = find(strcmp(stimulusList, stimuli{firstInd - nBack}));

                    % Choose two random entries (aliases) from that row
                    [stim1, stim2] = getRandomStimPair(stimulusList(stimulusListRow, :));

                    predeterminedStimChoice = true;
                
                % Check for the case where both of the following are true: 
                % 1. There is already a stimulus N trials after the
                % second index
                % 2. The trial N trials after the second index is itself
                % designated as a "yes" trial
                % If this occurs, we must use aliases of the stimulus N
                % trials after the second index
                elseif secondInd + nBack <= nTrials && ~isempty(stimuli{secondInd + nBack}) && yesNo(secondInd + nBack) == true
                    % Find the row of stimulusList that matches the stimulus
                    % already at the first index
                    [stimulusListRow, ~] = find(strcmp(stimulusList, stimuli{secondInd + nBack}));

                    % Choose two random entries (aliases) from that row
                    [stim1, stim2] = getRandomStimPair(stimulusList(stimulusListRow, :));

                    predeterminedStimChoice = true;
                    
                % If none of the conditions above are met, we are free to
                % choose a random stimulus.
                else
                    % Choose a random stimulus, and then pick two random
                    % aliases of that stimulus
                    [stim1, stim2] = getRandomStimPair(stimulusList);

                    predeterminedStimChoice = false;
                end
                

                %% Check if the chosen stimulus conflicts with which trials should be yes/no trials
                % This will be set to "true" if our choice of stimulus for
                % these two indices is unnaceptable for some reason
                rejectStimChoice = false;

                % Check for any problems caused by the earliest stimulus that
                % was changed forming an "nBack chain" with previous trials.
                if firstInd - nBack >= 1 && ~isempty(stimuli{firstInd - nBack}) && stimMatch(stim1, stimuli(firstInd - nBack), stimulusList)

                    % If chaining has occurred but the extra yes trial was
                    % going to be a yes trial anyway, it's fine
                    if yesNo(firstInd) == true

                        % Remove the extra "yes" trial from the list of yes
                        % trials to add, as it has been added "by accident"
                        remainingYesInds = remainingYesInds(remainingYesInds ~= firstInd);
                    else

                        % An extra yes trial has been added at an unwanted
                        % position - reject this stimulus choice
                        rejectStimChoice = true;
                    end

                end

                % Check for any problems caused by the latest stimulus that was
                % changed forming an "nBack chain" with later trials.
                if secondInd + nBack <= nTrials && ~isempty(stimuli{secondInd + nBack}) && stimMatch(stim1, stimuli(secondInd + nBack), stimulusList)

                    % If chaining has occurred but the extra yes trial was
                    % going to be a yes trial anyway, it's fine
                    if yesNo(secondInd + nBack) == true

                        % Remove the extra "yes" trial from the list of yes
                        % trials to add, as it has been added "by accident"
                        remainingYesInds = remainingYesInds(remainingYesInds ~= secondInd + nBack);
                    else

                        % An extra yes trial has been added at an unwanted
                        % position - reject this stimulus choice
                        rejectStimChoice = true;
                    end
                end
                
                %% Start over if a predetermined stimulus choice is invalid
                % If the letter choice is invalid, but it was also
                % constrained by the existing stimuli, there is no way
                % forward - the simplest solution is to start over with
                % generating this block. This should not happen very often
                % except possible with very constrained blocks (i.e. high
                % number of "yes" trials)
                if rejectStimChoice && predeterminedStimChoice
                    start_over = true;
                    break;
                end
                
                foundLetter = ~rejectStimChoice;

            end
            
            %% Assign the stimuli to create the new yes trial(s)
            stimuli(firstInd) = {stim1};
            stimuli(secondInd) = {stim2};

            % Remove the index of the yes trial that has been added from yesInds 
            remainingYesInds = remainingYesInds(2:end);

        end
    end
end

%% Initialize remaining empty trials to random stimuli,
% avoiding stimuli that would cause additional "yes" answers in the block. 
for i = 1:nTrials
    
    if isempty(stimuli{i})
        
        % Find a stimulus that doesn't cause an additional "yes" trial
        foundStim = false;
        while ~foundStim
            % Get a random stimulus (only use the first stimulus in the pair)
            [stim, ~] = getRandomStimPair(stimulusList);
            if nBack > 0
                if i + nBack > nTrials || ~stimMatch(stim, stimuli(i+nBack), stimulusList)
                    if i - nBack < 1 || ~stimMatch(stim, stimuli(i-nBack), stimulusList)
                        foundStim = true;
                    end
                end
            elseif nBack == 0
                if ~stimMatch(stim, zeroBackYesStimuli{1}, zeroBackYesStimuli)
                    foundStim = true;
                end
            end
        end
        stimuli(i) = {stim};
    end
end

end