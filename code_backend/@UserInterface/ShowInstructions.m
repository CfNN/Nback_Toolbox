function ShowInstructions(obj)
% SHOWINSTRUCTIONS - Show a series of introductory/instruction screens
%   Usage: ShowInstructions();
% See also SHOWREADYTRIGGER
% -------------------

% User can proceed by hitting any key. 
% Change to (eg.) activeKeys = [KbName('space'), KbName('return')] to only 
% respond to the space or enter keys. 
activeKeys = [];
RestrictKeysForKbCheck(activeKeys);

instructions = [ % Use \n to start a new line. Just one \n doesn't give enough space - best to use two or three
    'Now we''re ready to start!\n\n\n',...
    'Press the 1 key to answer YES.\n\n\n',...
    'Press the 2 key to answer NO.\n\n\n',...
    'Make your choice as quickly as possible!'
    ];

Screen('TextSize', obj.window, 80);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 1); % 1 makes it bold;

DrawFormattedText(obj.window, 'Nback', 'center', 'center', obj.c_white);

Screen('Flip', obj.window); % Flip to the screen
KbStrokeWait; % Wait for key press

obj.DrawText(instructions, 24);

Screen('Flip', obj.window); % Flip to the screen
KbStrokeWait; % Wait for key press

end
