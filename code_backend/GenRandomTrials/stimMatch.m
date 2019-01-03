function ismatch = stimMatch(stim1, stim2, stimulusList)
% ISMATCH: checks if two stimuli are aliases of each other in any row of
% the stimulusList structure.

[i1, ~] = ind2sub(size(stimulusList), find(strcmp(stimulusList, stim1)));
[i2, ~] = ind2sub(size(stimulusList), find(strcmp(stimulusList, stim2)));

ismatch = false;
for iter1 = 1:numel(i1)
    for iter2 = 1:numel(i2)
        if i1(iter1) == i2(iter2)
            ismatch = true;
        end
    end
end

end