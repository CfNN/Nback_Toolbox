function answers = getAnswers(stimuli, blockDef, stimulusList, zeroBackYesStimuli)
% GETANSWERS: iterates through a block of stimulus names and determines
% which stimuli should elicit "yes" answers. 
%
% stimuli: a cell array of strings with a single column - specifies a
% sequence of stimulus names to be presented during an experiment block.
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
% answers: a cell array of booleans with one column, where each value of '1' or
% 'true' represents a "yes" trial and each value of '0' or 'false'
% represents a "no" trial. 

nBack = round(blockDef(1));
nTrials = round(blockDef(2));
nYesTrials = round(blockDef(3));

% Use this to count up "yes" trials as the algorithm runs, in order to check that the number is consistent with what was specified
yesTrialsCount = 0; 

answers = cell(nTrials, 1);

if nBack == 0
    for i = 1:nTrials
        answer = false;
        for j = 1:numel(zeroBackYesStimuli)
            if stimMatch(stimuli{i}, zeroBackYesStimuli{j}, zeroBackYesStimuli)
                answer = true;
                yesTrialsCount = yesTrialsCount + 1;
                break;
            end
        end
        answers(i) = {answer};
    end
elseif nBack > 0
    nBackStims = stimuli(1:nBack);
    
    for i = 1:nBack
        answers(i) = {false};
    end
    
    for i = 1+nBack:numel(stimuli)
        if stimMatch(stimuli{i}, nBackStims{1}, stimulusList)
            answers(i) = {true};
            yesTrialsCount = yesTrialsCount + 1;
        else
            answers(i) = {false};
        end
        
        nBackStims = vertcat(nBackStims, stimuli(i)); %#ok<AGROW>
        nBackStims = nBackStims(2:end);
    end
end

assert(nYesTrials == yesTrialsCount, ['Internal error in GenRandomTrials - a block with definition [' num2str(blockDef) '] appears to have the wrong number of "yes" answers - ' num2str(yesTrialsCount) ' were counted, but ' num2str(nYesTrials) ' were required.']);

end