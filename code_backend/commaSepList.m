function str = commaSepList(cell_strings, and_or, quotes)
% COMMASEPLIST - converts a cell array of strings into a grammatically
% correct comma separated list string with a word like "and" or "or" before
% the last entry. Entries may optionally be surrounded by quotation marks.
%
% Example: commaSepList({'Harry', 'Hermione', 'Ron'}, 'and', false)
% Evaluates to: Harry, Hermione, and Ron
%
% Another example: commaSepList({'A', 'B', 'C'}, '', true)
% Evaluates to: 'A', 'B', 'C'

if numel(cell_strings) > 2
    
    str = '';
    for i = 1:(numel(cell_strings)-1)
        if quotes
            str = [str '''' cell_strings{i} ''', '];  %#ok<AGROW>
        else
            str = [str cell_strings{i} ', '];  %#ok<AGROW>
        end
    end
    if quotes
        str = [str and_or ' ''' cell_strings{numel(cell_strings)} ''''];
    else
        str = [str and_or ' ' cell_strings{numel(cell_strings)}];
    end
    
elseif numel(cell_strings) == 2
    if strcmpi(and_or, '')
        if quotes
            str = ['''' cell_strings{1} ''', ''' cell_strings{2} ''''];
        else
            str = [cell_strings{1} ', ' cell_strings{2}];
        end
    else
        if quotes
            str = ['''' cell_strings{1} ''' ' and_or ' ''' cell_strings{2} ''''];
        else
            str = [cell_strings{1} ' ' and_or ' ' cell_strings{2}];
        end
    end
    
else
    error('Invalid number of entries in cell_strings cell array');
end

end