function stimuli = genRandomBlock(blockDef, stimulusList, zeroBackYesStimuli)
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

stimuli = cell(nTrials, 1);

yesTrialCount = 0;
while yesTrialCount < nYesTrials
    
    % Find an appropriate pair of locations to place the stimulus pair.
    % This is accomplished by first choosing a random stimulus index, and
    % checking whether it and its counterpart N trials ahead are both
    % either empty or contain an alias of the stimuli being used here. If
    % they meet this criterion, the stimuli are added to these two indices
    % - otherwise, start over with a new random index. 
    foundPlace = false;
    while (~foundPlace)
        
        if nBack > 0
            [stim1, stim2] = getRandomStimPair(stimulusList);
        elseif nBack == 0
            [stim1, stim2] = getRandomStimPair(zeroBackYesStimuli);
        end
        
        firstInd = randi([1, nTrials-nBack]);
        secondInd = firstInd + nBack;
        
        if isempty(stimuli{firstInd}) || stimMatch(stimuli{firstInd}, stim1, stimulusList)
            if isempty(stimuli{secondInd}) || stimMatch(stimuli{secondInd}, stim1, stimulusList)
                % Make sure that both indices don't just match the same
                % stimulus already (in this case, we would be replacing an
                % existing "yes" answer, and would end up with too few of
                % them)
                if ~(stimMatch(stimuli{firstInd}, stim1, stimulusList) && stimMatch(stimuli{secondInd}, stim1, stimulusList))
                    
                    % Make sure that any newly added stimuli that create
                    % more than one new "yes" trial by "bridging"
                    % previously separated matching stimuli do not cause
                    % the number of yes trials to get too high (not an
                    % issue for nBack = 0).
                    if nBack == 0
                        foundPlace = true;
                        yesTrialCount = yesTrialCount + 1;
                    else
                        yesTrialsAdded = 1;
                        if firstInd - nBack >= 1 && stimMatch(stim1, stimuli(firstInd - nBack), stimulusList) && ~stimMatch(stimuli{firstInd}, stim1, stimulusList)
                            yesTrialsAdded = yesTrialsAdded + 1;
                        end
                        if secondInd + nBack <= nTrials && stimMatch(stim1, stimuli(secondInd + nBack), stimulusList) && ~stimMatch(stimuli{secondInd}, stim1, stimulusList)
                            yesTrialsAdded = yesTrialsAdded + 1;
                        end
                        
                        if yesTrialCount + yesTrialsAdded <= nYesTrials
                            yesTrialCount = yesTrialCount + yesTrialsAdded;
                            foundPlace = true;
                        end
                        
                    end
                end
            end
        end
    end
    
    % Add the stimulus pair to the selected locations
    stimuli(firstInd) = {stim1};
    stimuli(secondInd) = {stim2};
    
end

% Initialize other trials to random stimuli, avoiding stimuli that would
% cause additional "yes" answers in the block. 
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