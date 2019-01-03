function [stim1, stim2] = getRandomStimPair(stimulusList)
% GETRANDOMSTIMPAIR: Randomly chooses a pair of stimulus names from one
% randomly selected row of stimulusList

% Choose a random row
stimID = randi([1, size(stimulusList, 1)]);

% Get number of non-empty entries in the row (number of aliases for this
% stimulus)
nAliases = numel(find(~cellfun(@isempty,stimulusList(stimID, :))));

% Choose two random entries from the row
stim1 = stimulusList{stimID, randi([1, nAliases])};
stim2 = stimulusList{stimID, randi([1, nAliases])};
end