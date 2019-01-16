function stimulusListValidityCheck(stimulusList)
% STIMULUSLISTVALIDITYCHECK: checks whether stimulusList (2D cell array of
% character vectors) is valid. That is, that it is not empty, that it
% contains no duplicates (aliases must also not be duplicates of each
% other), and that it contains only character vectors and {} placeholder
% entries. No outputs - the function simply throws an error if there is a
% problem with the stimulusList.

assert(~isempty(stimulusList), 'stimulusList is empty!');

flatStimulusList = reshape(stimulusList, [numel(stimulusList), 1]);

flatStimulusList = flatStimulusList(~cellfun('isempty',flatStimulusList));

assert(iscellstr(flatStimulusList), 'stimulusList must contain only strings, character vectors (e.g. ''A'', ''Koala''), and {} placeholder entries.');  %#ok<ISCLSTR>

assert(numel(unique(flatStimulusList)) == numel(flatStimulusList), 'stimulusList contains duplicate entries! No duplicates are allowed as these will cause defective trial sequences. If you are just trying to make all the rows the same length, use {} as a placeholder instead of adding duplicates.');

end

